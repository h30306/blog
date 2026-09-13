---
title: "Backend Networking Fundamentals"
summary: "DNS, TCP, HTTP, TLS, load balancing, and request-path debugging at Tier A/S backend interview depth"
description: "Backend review notes for DNS, TCP, HTTP, TLS, L4/L7 load balancing, timeouts, connection reuse, observability, and production failure modes"
date: 2026-04-08
tags: ["networking", "dns", "tcp", "http", "tls", "load-balancing", "observability"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

- The full request path from browser/client to backend: DNS -> TCP/QUIC -> TLS -> L4/L7 edge -> app -> downstream
- What each layer guarantees, what it does not guarantee, and where to look when it fails
- TCP sockets, stream framing, connection reuse, idle timeout mismatch, ephemeral ports, and file descriptor exhaustion
- HTTP/1.1, HTTP/2, and HTTP/3 latency, multiplexing, and head-of-line blocking trade-offs
- TLS handshake, certificate validation, SNI, termination, re-encryption, and trust boundaries
- L4 vs L7 load balancing across routing power, cost, debuggability, and security boundaries
- Production triage for 502/503/504, connection reset, TLS failure, DNS stale records, and connection storms

## Tier A/S Readiness

The shallow answer is: DNS resolves IPs, TCP is reliable, TLS encrypts, and load balancers distribute traffic. That is only baseline.

A Tier A/S backend interview keeps pushing:

- After a client timeout, did the request succeed or not?
- Why does TCP reliability not mean application-level request success?
- Why can HTTP/2 still slow down after one packet loss?
- Why can load balancer idle timeout and client pool idle timeout mismatch cause `socket hang up`?
- After L7 TLS termination, should the internal hop still be encrypted?
- Given 502 or 504, how do you decide whether the issue is edge, app, DB pool, network path, or downstream?

The strong answer is not OSI memorization. It connects request path, failure boundary, timeout budget, observability, and security trade-offs.

## Request Path Mental Model

Anchor the whole topic with one API request:

```text
client
-> DNS cache / recursive resolver
-> TCP connection or QUIC connection
-> TLS handshake
-> L4 or L7 load balancer / gateway
-> app server
-> downstream service or database
-> response
```

For each layer, be able to answer:

- What guarantee does this layer provide?
- What does it not guarantee?
- What signal do I inspect when it fails?

A compact backend answer:

```text
DNS solves discovery, not connectivity.
TCP solves reliable ordered bytes, not request success.
TLS solves confidentiality, integrity, and server identity, not authorization.
HTTP defines request semantics, status codes, headers, and body framing.
Load balancers solve routing and traffic management, but add timeout, trust, and observability boundaries.
```

## DNS

DNS maps a hostname to an address. A common resolution path is:

```text
browser cache
-> OS cache
-> recursive resolver cache
-> root server
-> TLD server
-> authoritative nameserver
-> A / AAAA record
```

### TTL And Migration

TTL controls how long resolvers may cache a DNS answer.

Low TTL:

- failover and migration changes are observed faster
- resolver query volume increases
- still does not mean every client switches instantly, because clients, libraries, proxies, and mobile networks may cache differently

High TTL:

- lookup pressure is lower
- stale records last longer during incidents or migrations

Correct migration sequence:

```text
lower TTL
wait for old higher TTL to expire
change record
keep old target alive during transition
monitor traffic drain
```

### What DNS Does Not Guarantee

DNS only helps the client discover where to connect. It does not guarantee:

- the target is healthy
- TCP can connect
- the TLS certificate is valid
- the request will succeed
- failover is instant

### Production Failure

Common DNS issues:

- stale record pointing at an old load balancer
- recursive resolver cache not refreshed yet
- split-horizon DNS returning different answers inside and outside the network
- missing `AAAA` record or broken IPv6 path
- authoritative DNS incident
- client or container runtime DNS cache behavior differing from expectation

Check:

- DNS resolution latency and failure rate
- which resolver returned which record
- record TTL
- IP distribution seen by clients
- whether old targets still receive traffic

## Socket And TCP

A socket is the application-facing endpoint provided by the OS. TCP is the transport protocol underneath it.

A listening socket waits for connections. After accept, the server gets a connected socket for that client. Many clients can connect to the same server port because a TCP connection is identified by:

```text
source IP, source port, destination IP, destination port, protocol
```

### TCP Handshake

TCP three-way handshake:

```text
SYN -> SYN-ACK -> ACK
```

It:

- synchronizes initial sequence numbers
- confirms both sides are reachable
- establishes connection state

It does not provide:

- server identity
- encryption
- authorization
- application success

Those are TLS and application-contract concerns.

### Reliable Ordered Byte Stream

TCP provides a reliable ordered byte stream. It uses sequence numbers, ACKs, retransmission, flow control, and congestion control.

But be precise:

```text
TCP reliable bytes != HTTP request succeeded
TCP stream != message boundary
```

`send("hello")` and `send("world")` may be read as `helloworld`, or split across reads. TCP does not preserve application message boundaries, so HTTP and application protocols need framing:

- `Content-Length`
- chunked encoding
- HTTP/2 frames
- gRPC message framing
- length-prefixed protocols

### Flow Control vs Congestion Control

Flow control protects the receiver:

```text
receiver buffer almost full -> advertised receive window shrinks -> sender slows down
```

Congestion control protects the network path:

```text
loss / timeout / high delay -> congestion window shrinks -> sender reduces in-flight bytes
```

Interview shortcut:

```text
flow control = receiver bottleneck
congestion control = network bottleneck
send window is roughly limited by min(rwnd, cwnd)
```

When API latency increases under load, it may not only be slow application code. It can be queueing, packet loss, retransmission, congestion-window backoff, or a receiver that cannot read fast enough.

## Connection Lifetime vs Request Lifetime

A request is an application operation:

```text
GET /patients/123
POST /appointments
```

A connection is the underlying transport channel. One connection may carry one request or many requests.

Bad model:

```text
request 1 -> new TCP/TLS connection -> close
request 2 -> new TCP/TLS connection -> close
request 3 -> new TCP/TLS connection -> close
```

This amplifies:

- TCP handshake latency
- TLS handshake CPU cost
- accept backlog pressure
- file descriptor churn
- ephemeral port usage
- connection storm risk

Better model:

```text
open connection
request 1 -> response 1
request 2 -> response 2
request 3 -> response 3
close after idle timeout
```

### Idle Timeout Mismatch

A common production bug:

```text
t=0   request succeeds
t=30  load balancer closes idle connection
t=45  client pool still thinks connection is reusable
t=45  client sends next request on stale connection
```

Symptoms:

- connection reset
- broken pipe
- socket hang up
- first request after idle fails, retry succeeds

The usual fix is to make the client pool idle timeout shorter than the load balancer or server idle timeout, so the client discards stale connections first.

## HTTP Versions

### HTTP/1.1

- runs over TCP
- usually limited in how much work one connection can carry concurrently
- browsers often open multiple TCP connections for more concurrency
- the cost is more handshakes, more congestion windows, and more socket resources

### HTTP/2

- runs over one TCP connection
- multiplexes multiple streams
- reduces HTTP-level head-of-line blocking
- still suffers TCP-level head-of-line blocking

Key sentence:

```text
HTTP/2 multiplexing removes most application-level request blocking, but not TCP-level ordered-byte blocking.
```

If one TCP segment is lost, later bytes cannot be delivered to the HTTP/2 layer, so all streams on that connection may be affected.

### HTTP/3

- uses QUIC over UDP
- QUIC provides encryption, reliability, congestion control, and stream multiplexing
- streams are more independent than HTTP/2 over TCP
- packet loss usually blocks only the affected stream, not every stream on the connection

Do not just say "HTTP/3 is faster." A better statement:

```text
HTTP/3 improves connection setup and reduces TCP-level head-of-line blocking, especially on lossy or high-latency networks.
```

## TLS

TLS sits above TCP and provides:

- confidentiality
- integrity
- server authentication

HTTPS:

```text
HTTP over TLS over TCP
```

### TLS Handshake

After TCP is established, the TLS handshake is roughly:

```text
ClientHello
-> ServerHello + selected parameters + key exchange info + certificate chain
-> client validates certificate chain, hostname, expiry
-> server proves private-key ownership by signing handshake data
-> client verifies the signature using the server public key
-> both sides derive shared symmetric session keys
-> encrypted HTTP begins
```

`ClientHello` commonly includes:

- supported TLS versions
- cipher suites
- random data
- SNI
- key exchange information

### Certificate Validation

There are two layers:

```text
CA public key verifies the certificate chain.
Server public key verifies the server's handshake signature.
```

The client checks:

- whether the certificate chain reaches a trusted root
- whether the hostname matches
- whether the certificate is expired
- whether the server owns the corresponding private key

Common wrong wording:

```text
public key decrypts the signature
```

More precise:

```text
client verifies the signature using the server public key
```

### What TLS Does Not Guarantee

TLS does not mean:

- the user is authorized
- the payload is valid
- the backend service is healthy
- the request side effect succeeded
- the downstream DB transaction committed

TLS solves secure channel and server identity, not business correctness.

## L4 vs L7 Load Balancing

### L4

An L4 load balancer routes using transport-level information:

- IP
- port
- protocol
- connection-level state

Benefits:

- lower overhead
- good for TCP pass-through
- good for non-HTTP protocols
- can preserve client-to-backend TLS pass-through

Limits:

- cannot inspect HTTP path/header/cookie
- cannot do path-based routing
- is not the right layer for HTTP-aware auth, WAF, rate limiting, or request logging

### L7

An L7 load balancer or gateway understands HTTP:

- host
- path
- method
- headers
- cookies
- sometimes JWT / auth context

Good for:

- path / host routing
- centralized certificates
- WAF
- coarse authentication
- edge rate limiting
- request logging
- canary / blue-green routing
- trace propagation

Costs:

- higher CPU overhead
- possible added latency
- the load balancer becomes a trusted component that can see plaintext
- timeout, retry, and buffering policy become new failure boundaries

### TLS Termination, Re-Encryption, Pass-Through

TLS termination:

```text
client --TLS--> LB --HTTP--> backend
```

The LB decrypts traffic, so it can inspect HTTP path/header and apply L7 routing, WAF, auth hooks, and rate limits.

TLS re-encryption:

```text
client --TLS #1--> LB --TLS #2--> backend
```

This protects internal traffic, but it is two TLS sessions, not the same client-to-backend end-to-end TLS session.

TCP pass-through:

```text
client --TLS through LB--> backend
```

The LB does not decrypt traffic. This preserves end-to-end TLS but gives up HTTP-aware routing and edge inspection.

## Failure Matrix

| Symptom | Likely Layer | What I Check |
|---|---|---|
| DNS lookup slow / fails | DNS | resolver latency, authoritative health, TTL, record value |
| some users hit old server | DNS / cache | stale resolver cache, old TTL, old target traffic |
| connection timeout | TCP / routing / firewall | SYN/SYN-ACK, security group, LB listener, target reachability |
| connection reset / socket hang up | connection lifecycle | idle timeout mismatch, server close, pool reuse, deploy restart |
| TLS handshake failure | TLS | cert chain, hostname, expiry, SNI, cipher / TLS version |
| 400 / 401 / 403 | HTTP / auth | client contract, authn/authz, gateway vs app decision |
| 429 | rate limiting | edge quota, client identity, burst policy, retry-after |
| 502 | LB to upstream | upstream connection failure, bad gateway, app crash, invalid upstream response |
| 503 | capacity / unavailable | no healthy targets, overload, deploy, maintenance |
| 504 | timeout budget | app p95, DB pool wait, downstream p95, LB timeout |
| slow p95 but low error rate | queueing / congestion | LB queue, app concurrency, DB pool, packet loss, retransmits |

## Debugging 502 / 504 Like A Backend Engineer

If the edge returns 504, do not immediately say "increase the timeout." First split the timeout budget:

```text
client timeout
edge timeout
app request timeout
downstream timeout
DB query timeout
```

Then check:

- Did the 504 happen because the gateway waited too long for the app, or because the app waited too long for DB/downstream?
- Did the app log show the same `trace_id`?
- Is the app stuck on CPU, thread/event loop, connection pool, or slow query?
- Are upstream p95/p99 latencies near the LB timeout?
- Is a retry storm making overload worse?

For 502, I ask:

- Can the LB connect to a healthy target?
- Did the upstream crash, restart, or close the connection?
- Did the app return a malformed response?
- Did TLS between LB and backend fail?
- During deploy, did readiness or drain settings send traffic to an unready instance?

## What Breaks At Scale

- DNS failover is not instant because old records may remain cached
- creating new TCP/TLS connections per request causes connection storms
- accept backlog pressure can delay, refuse, or time out new connections
- file descriptor limits can prevent new sockets
- ephemeral port exhaustion appears on clients that create many outbound short-lived connections
- slow clients consume sockets, buffers, workers, or event-loop capacity
- HTTP/2 reduces connection count, but packet loss can still cause TCP-level HOL blocking
- TLS termination centralizes certificates and inspection, but also centralizes trust and blast radius
- L7 routing is flexible, but CPU, latency, and timeout policy are more complex than L4

## What To Log Or Measure

### Edge / Load Balancer

- request count by route
- 4xx / 5xx split
- 502 / 503 / 504 count
- upstream connection errors
- target health
- TLS handshake failure count
- edge p50 / p95 / p99 latency
- request size / response size

### App

- request duration by route
- in-flight requests
- queue time if available
- timeout count
- retry count
- connection pool wait time
- downstream call duration
- trace ID and request ID propagation

### Network / TCP

- connection resets
- retransmits
- SYN backlog / accept backlog pressure
- open sockets
- file descriptor usage
- ephemeral port usage on heavy outbound clients

### DNS

- resolver latency
- resolution error rate
- answer distribution by IP
- traffic still hitting old targets during migration

## Security Boundaries

Backend networking answers should separate security responsibilities:

- DNS does not authenticate the server.
- TCP does not encrypt or verify identity.
- TLS authenticates server identity and encrypts traffic.
- Gateway authentication can reject obviously invalid clients early.
- Application authorization still belongs in service logic when it depends on tenant, hospital, ownership, role, or resource state.
- TLS termination means the LB can see plaintext, so the LB and internal network become part of the trusted boundary.
- Re-encryption protects internal traffic, but certificate validation and service identity still need operational discipline.

## Interview Pushback

### If the interviewer asks: "TCP is reliable, so why can a POST still duplicate?"

TCP only guarantees ordered byte delivery for one connection. If the client times out, it may not know whether the server committed the side effect and lost the response. Duplicate prevention needs application-level idempotency, not TCP.

### If the interviewer asks: "Why not always use L7?"

L7 gives HTTP-aware routing, WAF, auth hooks, observability, and canary routing, but it costs more CPU and creates a plaintext trust boundary at the LB. For non-HTTP traffic, simple TCP balancing, or strict pass-through TLS, L4 may be the better fit.

### If the interviewer asks: "Why can HTTP/2 be slow on bad networks?"

HTTP/2 multiplexes streams over one TCP connection. TCP must deliver bytes in order, so a lost segment blocks later bytes from reaching the HTTP/2 layer until retransmission. That is TCP-level head-of-line blocking.

### If the interviewer asks: "What do you do before DNS migration?"

Lower TTL ahead of time, wait for the old TTL to expire, change the record, keep the old target alive while traffic drains, and monitor answer distribution plus old-target traffic.

### If the interviewer asks: "Where do you put rate limiting?"

At the edge for infrastructure protection before expensive app and DB work. In the service for business quotas, tenant fairness, or resource-specific limits. The key is defining the identity used for the limit and returning a clear `429` contract.

## Common Mistakes

- Saying TCP preserves messages. It preserves byte order, not message boundaries.
- Saying TCP proves trust. TLS and certificates handle identity and encryption.
- Saying DNS migration is instant after changing a record.
- Saying HTTP/2 removes all head-of-line blocking.
- Saying TLS termination is still one end-to-end TLS session.
- Saying L7 is always better than L4.
- Increasing timeout before checking whether the system is overloaded or stuck behind DB/downstream.
- Treating a network retry as safe without idempotency on side-effecting requests.

## 60-90 Second Answer

I would explain networking through the request path. The client first uses DNS to discover the API domain address; DNS solves discovery, not target health. The client then opens a TCP connection. TCP provides reliable ordered bytes, but it does not guarantee request success or preserve message boundaries, so HTTP defines method, headers, status codes, and body framing. HTTPS adds a TLS handshake over TCP, validating the certificate chain, hostname, server private-key proof, and then deriving symmetric session keys. At the edge, L4 can do low-overhead TCP-level routing, while L7 can inspect HTTP path and headers after TLS termination and provide WAF, rate limiting, auth hooks, observability, and canary routing. In production I would watch timeout budgets, connection reuse, idle timeout mismatch, 502/504s, DB/downstream latency, trace propagation, and the trust boundary created by TLS termination.

## 10-15 Minute Deep Dive Path

1. Draw the request path: client -> DNS -> TCP/QUIC -> TLS -> LB/gateway -> app -> downstream.
2. For each layer, state its guarantee and non-guarantee.
3. Expand TCP: socket, 4-tuple, stream framing, keep-alive, flow vs congestion control.
4. Expand HTTP: HTTP/1.1 connection pressure, HTTP/2 multiplexing, HTTP/3 QUIC streams.
5. Expand TLS: certificate validation, SNI, signature verification, session key derivation.
6. Expand LB: L4 vs L7, termination vs re-encryption vs pass-through.
7. Use 502/504 or slow p95 as a debugging case: trace ID, edge metrics, app p95, pool wait, downstream latency.
8. Close with trade-offs: performance, observability, security boundary, and operational complexity.

## Final Deliverables

You should be able to do three things:

- Draw the request path and explain what DNS, TCP, TLS, HTTP, and LB each own.
- Given timeout, 502, 504, connection reset, TLS failure, or DNS stale record, explain the first debugging steps.
- Make trade-offs among L4/L7, HTTP/1.1/2/3, and TLS termination/re-encryption/pass-through instead of only reciting definitions.
