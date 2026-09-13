---
title: "Backend Networking Fundamentals"
summary: "用 backend interview 口徑整理 DNS、TCP、HTTP、TLS 與 Load Balancing"
description: "從 networking learning notes 重新整理的 backend 筆記"
date: 2026-04-08
tags: ["networking", "dns", "tcp", "http", "tls", "load-balancing"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Learning Note Sources

- Day 1: OSI model, TCP vs UDP, TLS, L4 vs L7, DNS
- Day 2: DNS and HTTP versions
- Day 3-5: TCP behavior, sockets, load balancers, flow control, congestion control
- Day 6-14: DNS, HTTP, TLS handshake, certificate validation, TLS termination, re-encryption

## 心智模型

Backend 面試裡，networking 不應該只背定義，而是要能從 request path 講：

```text
client -> DNS -> TCP or QUIC connection -> TLS -> load balancer -> app -> database -> response
```

重點是說清楚每一層保證什麼，以及不保證什麼。

## DNS

DNS 把 hostname 對應到 address。production 裡最重要的是 TTL caching。TTL 低可以讓 failover 或 routing 變更比較快生效，但 resolver traffic 會增加。TTL 高可以減少 lookup load，但 migration 或 incident 時 stale record 會留比較久。

強回答：

```text
DNS 不負責建立 connection，它只幫 client 找到要連去哪裡。
```

## TCP

TCP 提供 reliable, ordered byte stream。它靠 sequence number、ACK、retransmission、flow control、congestion control 來做到。

面試安全說法：

- TCP reliable 不代表 application request 已經成功。
- TCP 是 stream，所以 HTTP 需要 `Content-Length` 或 chunked encoding 這種 framing。
- 每個 request 都開新 TCP connection，流量尖峰時會放大 latency 和 server 壓力。
- HTTP/2 雖然 multiplex streams，但因為底層還是 TCP，一個 packet loss 仍可能影響共用的 byte stream。

## HTTP Versions

```text
HTTP/1.1: request/response over TCP，受 connection reuse 和 head-of-line behavior 影響
HTTP/2: 在一條 TCP connection 上 multiplex 多個 streams
HTTP/3: 用 QUIC over UDP，減少 TCP-level head-of-line blocking
```

重點不是背版本，而是能說出 latency、connection reuse、failure behavior 的差異。

## TLS

TLS 提供 encryption、integrity、server authentication。Certificate validation 證明 server certificate 可以 chain 到 trusted CA。Server 也會在 handshake 中證明自己控制 private key。

常見修正：

```text
不是 public key decrypts a signature。
比較準確是 client 用 public key verify signature。
```

## L4 vs L7 Load Balancing

L4 load balancer 用 IP、port 這種 connection-level 資訊 routing。L7 load balancer 理解 host、path、headers、cookies 等 application-layer 資訊。

TLS 選項：

- TLS termination: load balancer 解密，再轉發到內部。
- TLS re-encryption: load balancer 解密檢查或 routing 後，再和 backend 建一條新的 TLS。
- TCP pass-through: load balancer 不解密 application traffic。

## Scale 下會壞什麼

- DNS changes 不會瞬間生效，因為 client 和 resolver 會 cache。
- Connection storm 會壓 load balancer 和 app server。
- HTTP/2 減少 connection 數，但 packet loss 還是會影響 shared TCP stream。
- TLS termination 讓 certificate 和 inspection 集中，但也建立新的 trust boundary。
- L7 routing 彈性高，但比 L4 forwarding 更吃 CPU。

## 要量測什麼

- DNS resolution failures and latency
- TCP connection errors and resets
- TLS handshake failures
- load balancer 4xx/5xx split
- upstream latency and timeout rate
- per-route request volume

## 面試回答形狀

60-90 秒內，我會從 browser 到 backend 講完整 request path：DNS 解析 hostname，client 建 TCP 或 QUIC connection，TLS 建立加密並驗證 server，load balancer routing，application 做 auth/business logic，接著呼叫 storage 並回傳 response。每一層都補一句 guarantee：DNS discovery、TCP reliable byte stream、TLS confidentiality/integrity、HTTP request semantics、load balancer routing。
