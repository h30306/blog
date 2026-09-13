---
title: "Backend Networking Fundamentals"
summary: "用 Tier A/S backend interview 口徑整理 DNS、TCP、HTTP、TLS、Load Balancing 與 request-path debugging"
description: "DNS、TCP、HTTP、TLS、L4/L7 load balancing、timeouts、connection reuse、observability 與 production failure mode 的 backend 複習筆記"
date: 2026-04-08
tags: ["networking", "dns", "tcp", "http", "tls", "load-balancing", "observability"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- 一個 request 從 browser/client 到 backend 的完整路徑：DNS -> TCP/QUIC -> TLS -> L4/L7 edge -> app -> downstream
- 每一層保證什麼、不保證什麼，以及失敗時要去哪裡看
- TCP socket、stream framing、connection reuse、idle timeout mismatch、ephemeral port / file descriptor exhaustion
- HTTP/1.1、HTTP/2、HTTP/3 的 latency、multiplexing、head-of-line blocking trade-off
- TLS handshake、certificate validation、SNI、termination、re-encryption、trust boundary
- L4 vs L7 load balancing 的 routing 能力、成本、debuggability、安全邊界
- 502/503/504、connection reset、TLS failure、DNS stale record、connection storm 的 production triage

## Tier A/S 判斷

原本如果只說「DNS 解析 IP、TCP reliable、TLS 加密、LB 分流」，只能算 baseline。Tier A/S backend 面試會繼續追：

- client timeout 後 request 到底有沒有成功？
- 為什麼 TCP reliable 不等於 application request 成功？
- 為什麼 HTTP/2 還會被 single packet loss 拖慢？
- 為什麼 load balancer idle timeout 和 client pool idle timeout 不一致會造成 `socket hang up`？
- L7 TLS termination 之後，內網流量還需不需要加密？
- 看到 502/504 時，你怎麼判斷是 edge、app、DB pool、network path 還是 downstream？

強回答不是背 OSI layer，而是把 request path、failure boundary、timeout budget、observability 和 security trade-off 串起來。

## Request Path Mental Model

用一個 API request 來綁住整篇：

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

每一層要能回答三件事：

- 這層提供什麼 guarantee？
- 這層不保證什麼？
- 如果這層壞了，我看什麼 signal？

一個好用的 backend answer：

```text
DNS solves discovery, not connectivity.
TCP solves reliable ordered bytes, not request success.
TLS solves confidentiality, integrity, and server identity, not authorization.
HTTP defines request semantics, status codes, headers, and body framing.
Load balancers solve routing and traffic management, but add timeout, trust, and observability boundaries.
```

## DNS

DNS 把 hostname 解析成 address。常見流程：

```text
browser cache
-> OS cache
-> recursive resolver cache
-> root server
-> TLD server
-> authoritative nameserver
-> A / AAAA record
```

### TTL 和 Migration

TTL 控制 resolver 可以 cache DNS answer 多久。

低 TTL：

- failover / migration 變更比較快被看到
- resolver query volume 增加
- 不代表所有 client 立刻切走，因為 cache、library、proxy、mobile network 都可能有自己的行為

高 TTL：

- lookup 壓力較低
- incident 或 migration 時 stale record 會留比較久

正確 migration 思路：

```text
lower TTL
wait for old higher TTL to expire
change record
keep old target alive during transition
monitor traffic drain
```

### DNS 不保證什麼

DNS 只幫 client 找到要連去哪裡。它不保證：

- target 正常
- TCP connection 建得起來
- TLS certificate 正確
- request 會成功
- failover 會瞬間生效

### Production Failure

常見 DNS 問題：

- stale record 指到舊 load balancer
- recursive resolver cache 未更新
- split-horizon DNS 導致內外網解析不同
- missing `AAAA` 或 IPv6 path 壞掉
- authoritative DNS incident
- client / container runtime DNS cache 行為和預期不同

要看：

- DNS resolution latency / failure rate
- 哪個 resolver 回了什麼 record
- record TTL
- client 解析到的 IP distribution
- 舊 target 是否仍有流量

## Socket And TCP

Socket 是 application 面向 OS 的 communication endpoint。TCP 是底下的 transport protocol。

Listening socket 等待連線；accept 後會得到 connected socket。很多 client 可以連同一個 server port，因為一條 TCP connection 由這個 tuple 區分：

```text
source IP, source port, destination IP, destination port, protocol
```

### TCP Handshake

TCP 3-way handshake：

```text
SYN -> SYN-ACK -> ACK
```

目的：

- synchronize initial sequence numbers
- 確認雙方可達
- 建立 connection state

不負責：

- server identity
- encryption
- authorization
- application success

這些是 TLS 和 application contract 的事情。

### Reliable Ordered Byte Stream

TCP 提供 reliable ordered byte stream。它靠 sequence number、ACK、retransmission、flow control、congestion control 來維持 byte stream。

但要講清楚：

```text
TCP reliable bytes != HTTP request succeeded
TCP stream != message boundary
```

`send("hello")` 和 `send("world")` 可能被對方一次讀成 `helloworld`，也可能分段讀到。TCP 不保留 application message boundary，所以 HTTP 需要 framing，例如：

- `Content-Length`
- chunked encoding
- HTTP/2 frame
- gRPC message framing
- length-prefix protocol

### Flow Control vs Congestion Control

Flow control 保護 receiver：

```text
receiver buffer almost full -> advertised receive window shrinks -> sender slows down
```

Congestion control 保護 network path：

```text
loss / timeout / high delay -> congestion window shrinks -> sender reduces in-flight bytes
```

面試簡化：

```text
flow control = receiver bottleneck
congestion control = network bottleneck
send window is roughly limited by min(rwnd, cwnd)
```

如果 API latency 在 load 下變高，可能不是 app code 變慢而已，也可能是 queueing、packet loss、retransmission、congestion window backoff 或 receiver 讀取速度跟不上。

## Connection Lifetime vs Request Lifetime

Request 是 application operation，例如：

```text
GET /patients/123
POST /appointments
```

Connection 是底層 transport channel。它可以承載一個或多個 request。

Bad model：

```text
request 1 -> new TCP/TLS connection -> close
request 2 -> new TCP/TLS connection -> close
request 3 -> new TCP/TLS connection -> close
```

這會放大：

- TCP handshake latency
- TLS handshake CPU cost
- accept backlog pressure
- file descriptor churn
- ephemeral port usage
- connection storm risk

Better model：

```text
open connection
request 1 -> response 1
request 2 -> response 2
request 3 -> response 3
close after idle timeout
```

### Idle Timeout Mismatch

常見 production bug：

```text
t=0   request succeeds
t=30  load balancer closes idle connection
t=45  client pool still thinks connection is reusable
t=45  client sends next request on stale connection
```

可能看到：

- connection reset
- broken pipe
- socket hang up
- first request after idle fails, retry succeeds

修法通常是讓 client pool idle timeout 短於 load balancer / server idle timeout，讓 client 主動淘汰 stale connection。

## HTTP Versions

### HTTP/1.1

- runs over TCP
- 通常一條 connection 上同時間處理能力有限
- browser 常用多條 TCP connections 增加 concurrency
- 代價是更多 handshakes、更多 congestion windows、更多 socket resource

### HTTP/2

- runs over one TCP connection
- multiplex multiple streams
- 減少 HTTP-level head-of-line blocking
- 但仍有 TCP-level head-of-line blocking

關鍵句：

```text
HTTP/2 multiplexing removes most application-level request blocking, but not TCP-level ordered-byte blocking.
```

如果一個 TCP segment lost，後面的 bytes 不能交給 HTTP/2 layer，所有 stream 都可能被影響。

### HTTP/3

- uses QUIC over UDP
- QUIC 提供 encryption、reliability、congestion control、stream multiplexing
- streams 比 HTTP/2 over TCP 更獨立
- packet loss 通常只阻塞 affected stream，不阻塞整條 connection 上所有 streams

面試不要只說「HTTP/3 比較快」。比較準確：

```text
HTTP/3 improves connection setup and reduces TCP-level head-of-line blocking, especially on lossy or high-latency networks.
```

## TLS

TLS 加在 TCP 之上，提供：

- confidentiality
- integrity
- server authentication

HTTPS：

```text
HTTP over TLS over TCP
```

### TLS Handshake

TCP 建好後，TLS handshake 大致是：

```text
ClientHello
-> ServerHello + selected parameters + key exchange info + certificate chain
-> client validates certificate chain, hostname, expiry
-> server proves private-key ownership by signing handshake data
-> client verifies the signature using the server public key
-> both sides derive shared symmetric session keys
-> encrypted HTTP begins
```

`ClientHello` 常包含：

- supported TLS versions
- cipher suites
- random data
- SNI
- key exchange information

### Certificate Validation

兩個層次：

```text
CA public key verifies the certificate chain.
Server public key verifies the server's handshake signature.
```

client 會檢查：

- certificate chain 是否能連到 trusted root
- hostname 是否 match
- certificate 是否過期
- server 是否真的持有對應 private key

常見錯誤說法：

```text
public key decrypts the signature
```

更精準：

```text
client verifies the signature using the server public key
```

### TLS 不保證什麼

TLS 不代表：

- user 有權限
- payload 合法
- backend service 是健康的
- request side effect 成功
- downstream DB transaction committed

TLS 解的是 secure channel 和 server identity，不是 business correctness。

## L4 vs L7 Load Balancing

### L4

L4 load balancer 依據 transport-level 資訊 routing：

- IP
- port
- protocol
- connection-level state

優點：

- overhead 較低
- 適合 TCP pass-through
- 適合非 HTTP protocol
- 可以保留 client-to-backend TLS pass-through

限制：

- 不看 HTTP path/header/cookie
- 不能做 path-based routing
- 不適合做 HTTP-aware auth、WAF、rate limit、request logging

### L7

L7 load balancer / gateway 理解 HTTP：

- host
- path
- method
- headers
- cookies
- sometimes JWT / auth context

適合：

- path / host routing
- centralized certificates
- WAF
- coarse authn
- edge rate limiting
- request logging
- canary / blue-green routing
- trace propagation

代價：

- CPU overhead 較高
- latency 可能增加
- load balancer 成為能看到 plaintext 的 trusted component
- timeout / retry / buffering policy 變成新的 failure boundary

### TLS Termination, Re-Encryption, Pass-Through

TLS termination：

```text
client --TLS--> LB --HTTP--> backend
```

LB 解密，所以能看 HTTP path/header，做 L7 routing、WAF、auth、rate limit。

TLS re-encryption：

```text
client --TLS #1--> LB --TLS #2--> backend
```

這保護內部傳輸，但要記得它是兩段 TLS，不是 client 到 backend 的同一條 end-to-end TLS session。

TCP pass-through：

```text
client --TLS through LB--> backend
```

LB 不解密，保留 end-to-end TLS，但也失去 HTTP-aware routing 和 edge inspection。

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

如果 edge 顯示 504，不要只說「increase timeout」。我會先拆 timeout budget：

```text
client timeout
edge timeout
app request timeout
downstream timeout
DB query timeout
```

然後查：

- 504 是 gateway 等 app 太久，還是 app 等 DB/downstream 太久？
- app log 裡該 `trace_id` 有沒有進來？
- app 是卡 CPU、thread/event loop、connection pool，還是 slow query？
- upstream latency p95/p99 是否接近 LB timeout？
- 有沒有 retry storm 讓 overload 更嚴重？

如果是 502，我會優先問：

- LB 是否能連到 healthy target？
- upstream 是否 crash / restart / close connection？
- app 是否回了 malformed response？
- TLS between LB and backend 是否失敗？
- deployment 時 readiness / drain 設定是否讓流量打到未 ready instance？

## What Breaks At Scale

- DNS failover 不會瞬間生效，舊 record 可能殘留
- 每 request 新建 TCP/TLS connection 會造成 connection storm
- accept backlog 滿了會讓新 connection delay / refuse / timeout
- file descriptor limit 會讓 socket 建不起來
- ephemeral port exhaustion 會出現在大量 outbound short-lived connections 的 client side
- slow clients 會佔住 socket、buffer、worker 或 event loop capacity
- HTTP/2 降低 connection 數，但 packet loss 還是會造成 TCP-level HOL blocking
- TLS termination 集中 certificate 和 inspection，也集中 trust 和 blast radius
- L7 routing 彈性高，但 CPU、latency、timeout policy 都比 L4 更複雜

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

### If interviewer asks: "TCP is reliable, so why can a POST still duplicate?"

TCP only guarantees ordered byte delivery for one connection. If the client times out, it may not know whether the server committed the side effect and lost the response. Duplicate prevention needs application-level idempotency, not TCP.

### If interviewer asks: "Why not always use L7?"

L7 gives HTTP-aware routing, WAF, auth hooks, observability, and canary routing, but it costs more CPU and creates a plaintext trust boundary at the LB. For non-HTTP traffic, simple TCP balancing, or strict pass-through TLS, L4 may be the better fit.

### If interviewer asks: "Why can HTTP/2 be slow on bad networks?"

HTTP/2 multiplexes streams over one TCP connection. TCP must deliver bytes in order, so a lost segment blocks later bytes from reaching the HTTP/2 layer until retransmission. That is TCP-level head-of-line blocking.

### If interviewer asks: "What do you do before DNS migration?"

Lower TTL ahead of time, wait for old TTL to expire, change the record, keep the old target alive while traffic drains, and monitor answer distribution plus old-target traffic.

### If interviewer asks: "Where do you put rate limiting?"

At the edge for infrastructure protection before expensive app and DB work. In the service for business quotas, tenant fairness, or resource-specific limits. The key is to define the identity used for the limit and return a clear `429` contract.

## Common Mistakes

- Saying TCP preserves messages. It preserves byte order, not message boundaries.
- Saying TCP proves trust. TLS and certificates handle identity and encryption.
- Saying DNS migration is instant after changing a record.
- Saying HTTP/2 removes all head-of-line blocking.
- Saying TLS termination is still one end-to-end TLS session.
- Saying L7 is always better than L4.
- Increasing timeout before checking whether the system is overloaded or stuck behind DB/downstream.
- Treating a network retry as safe without idempotency on side-effecting requests.

## 60-90 秒回答

我會把 networking 從 request path 講起。Client 先透過 DNS 找到 API domain 的 address，DNS 只解 discovery，不保證 target 健康。接著 client 建 TCP connection，TCP 提供 reliable ordered byte stream，但不保證 request 成功，也不保留 message boundary，所以 HTTP 要定義 method、headers、status、body framing。HTTPS 會在 TCP 上做 TLS handshake，驗證 certificate chain、hostname、server private-key proof，然後 derive symmetric session keys。Request 到 edge 後，L4 可以做低成本 TCP-level routing，L7 則可以在 TLS termination 後看 HTTP path/header，做 WAF、rate limiting、auth hook、observability 和 canary routing。Production 裡我會特別看 timeout budget、connection reuse、idle timeout mismatch、502/504、DB/downstream latency、trace ID propagation，以及 TLS termination 帶來的 trust boundary。

## 10-15 分鐘 Deep Dive 路線

1. 先畫 request path：client -> DNS -> TCP/QUIC -> TLS -> LB/gateway -> app -> downstream。
2. 對每層說 guarantee / non-guarantee。
3. 展開 TCP：socket、4-tuple、stream framing、keep-alive、flow vs congestion control。
4. 展開 HTTP：HTTP/1.1 connection pressure、HTTP/2 multiplexing、HTTP/3 QUIC streams。
5. 展開 TLS：certificate validation、SNI、signature verification、session key derivation。
6. 展開 LB：L4 vs L7、termination vs re-encryption vs pass-through。
7. 用 502/504 或 slow p95 做 debugging：trace ID、edge metrics、app p95、pool wait、downstream latency。
8. 收斂到 trade-off：performance、observability、security boundary、operational complexity。

## 最後要能交付

你要能做到三件事：

- 畫出 request path，並說明 DNS、TCP、TLS、HTTP、LB 各自負責什麼。
- 遇到 timeout、502、504、connection reset、TLS fail、DNS stale record 時，能說出優先 debug 順序。
- 在 L4/L7、HTTP/1.1/2/3、TLS termination/re-encryption/pass-through 之間做 trade-off，而不是只背定義。
