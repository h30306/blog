---
title: "Backend Networking Fundamentals"
summary: "DNS, TCP, HTTP, TLS, and load balancing in backend interview terms"
description: "Backend review notes for DNS, TCP, HTTP, TLS, and load balancing"
date: 2026-04-08
tags: ["networking", "dns", "tcp", "http", "tls", "load-balancing"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

- DNS resolution, caching, TTL, migration / failover behavior
- TCP reliable ordered byte stream, flow control, congestion control, connection reuse
- HTTP/1.1, HTTP/2, and HTTP/3 latency and head-of-line trade-offs
- TLS handshake, certificate validation, termination, and re-encryption
- L4 vs L7 load balancing and production failure points

## Mental Model

For backend interviews, networking should be explained as the request path, not as isolated definitions:

```text
client -> DNS -> TCP or QUIC connection -> TLS -> load balancer -> app -> database -> response
```

The important skill is saying what each layer guarantees and what it does not guarantee.

## DNS

DNS maps a hostname to an address. The key production detail is caching through TTL. A lower TTL makes failover and routing changes faster, but increases resolver traffic. A higher TTL reduces lookup load, but stale records can last longer during migration or incident response.

Strong answer:

```text
DNS does not create the connection. It only helps the client discover where to connect.
```

## TCP

TCP provides reliable, ordered byte streams. It uses sequence numbers, ACKs, retransmission, flow control, and congestion control.

Interview-safe distinctions:

- TCP reliability does not mean the application request succeeded.
- TCP is a stream, so HTTP needs framing such as `Content-Length` or chunked encoding.
- Creating a new TCP connection per request can amplify latency and load during spikes.
- One lost packet can hurt HTTP/2 over TCP because streams share the same underlying ordered byte stream.

## HTTP Versions

```text
HTTP/1.1: request/response over TCP, limited by head-of-line behavior and connection reuse
HTTP/2: multiplexes streams over one TCP connection
HTTP/3: uses QUIC over UDP to reduce TCP-level head-of-line blocking
```

The practical point is not version trivia. It is understanding latency, connection reuse, and failure behavior.

## TLS

TLS provides encryption, integrity, and server authentication. Certificate validation proves the server's certificate chains to a trusted CA. The server also proves it controls the private key during the handshake.

Common wording repair:

```text
The public key does not decrypt the signature in the application sense.
The client verifies a signature using the public key.
```

## L4 vs L7 Load Balancing

L4 load balancers route using connection-level information such as IP and port. L7 load balancers understand application-layer information such as host, path, headers, and cookies.

TLS options:

- TLS termination: the load balancer decrypts, then forwards internally.
- TLS re-encryption: the load balancer decrypts, inspects or routes, then creates a new TLS connection to the backend.
- TCP pass-through: the load balancer does not decrypt application traffic.

## What Breaks At Scale

- DNS changes are not instant because clients and resolvers cache records.
- Connection storms can pressure load balancers and app servers.
- HTTP/2 multiplexing helps connection count, but packet loss can still hurt shared TCP streams.
- TLS termination centralizes certificates and inspection, but it also creates a trust boundary.
- L7 routing is flexible but more CPU-expensive than L4 forwarding.

## What To Log Or Measure

- DNS resolution failures and latency
- TCP connection errors and resets
- TLS handshake failures
- load balancer 4xx/5xx split
- upstream latency and timeout rate
- per-route request volume

## Interview Answer Shape

In 60-90 seconds, I would describe a request from the browser to the backend: DNS resolves the hostname, the client opens a TCP or QUIC connection, TLS establishes encryption and authenticates the server, the load balancer routes the request, the application handles auth/business logic, then calls storage and returns the response. At each layer, I would name the guarantee: DNS discovery, TCP reliable byte stream, TLS confidentiality/integrity, HTTP request semantics, and load balancer routing.
