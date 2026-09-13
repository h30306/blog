---
title: "LeetCode 310: Minimum Height Trees"
summary: "LeetCode 解題筆記：Minimum Height Trees"
description: "2026-04-11 的 LeetCode 學習紀錄"
date: 2026-04-11
tags: ["leetcode", "medium", "graph", "topological-sort"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-11
來源筆記：`notes/day3-topological-sort-tcp-sockets-load-balancer.md`

## 解題思路

這篇整理 Minimum Height Trees 的解題筆記，重點放在 Topological-style leaf trimming on an undirected tree、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Topological-style leaf trimming on an undirected tree
- **Key insight:** The root of a minimum height tree must be the center of the tree. A tree has either 1 or 2 centers.
- **Approach:** Build undirected adjacency sets and degree array. Start with all leaves where degree is 1. Remove leaves layer by layer. Each removal reduces neighbor degree. New leaves are added to the queue. Stop when remaining nodes <= 2.
- **Why leaf trimming works:** The farthest nodes from the center are leaves. Removing outer layers repeatedly leaves the center node(s).
- **Special case:** If `n == 1`, return `[0]`.
- **Complexity:** Time O(n), Space O(n)
- **Common bugs:** Treating this as directed topo sort, forgetting `n == 1`, returning removed leaves instead of remaining centers, not decrementing remaining node count.

## Pattern Comparison
- **Alien Dictionary:** Directed graph ordering problem.
- **Recipes:** Directed dependency unlocking problem.
- **Minimum Height Trees:** Undirected tree center problem using topo-style pruning.
- **Interview distinction:** Topological sort is not only one template. The same in-degree idea can model ordering, availability, or layer removal, but the graph direction and meaning must be explained clearly.

## Topic - TCP, Sockets, Load Balancer

## Socket
- **Interview-ready definition:** A socket is an OS-provided endpoint/interface used by an application for network communication. The application reads and writes data through the socket, while the OS handles the underlying transport protocol such as TCP or UDP.
- **Socket vs TCP:** A socket is the application-facing handle. TCP is the transport protocol underneath that establishes connection state and provides reliable ordered byte delivery.
- **Listening socket vs connected socket:** A listening socket waits for incoming connections on an IP and port. After a client connects, the server accepts it and gets a separate connected socket for that specific client connection.
- **Multiple clients on one port:** Many clients can connect to the same server port because each TCP connection is identified by source IP, source port, destination IP, destination port, and protocol.
- **Same client, multiple connections:** Same client IP can still open multiple connections to the same server port because the OS uses different client-side ephemeral ports.

## TCP Handshake
- **3-way handshake:** Client sends `SYN`, server replies `SYN-ACK`, client sends `ACK`.
- **Purpose:** Synchronize initial sequence numbers and confirm both sides are reachable before application data is sent.
- **Not the purpose:** TCP does not prove trust or identity. TLS/certificates handle identity and encryption.
- **SYN:** Synchronize. Starts connection setup and consumes one sequence number.
- **ACK:** Acknowledgment. Means "the next sequence number I expect from you is X."
- **Example:** If client sends `SYN(seq=100)`, server replies `ack=101`. Client's first real data byte starts at `seq=101` because pure ACK consumes zero sequence numbers.

## Sequence Numbers and ACKs
- **Sequence number:** Position of bytes in the TCP byte stream.
- **ACK number:** Next byte expected by the receiver.
- **Example:** If client sends 20 bytes starting at `seq=101`, the bytes are `101` through `120`, so the server replies `ack=121`.
- **Lost earlier chunk:** If bytes `101-120` are missing but `121-130` arrive, receiver still sends `ack=101` because TCP must deliver an ordered byte stream.
- **Interview wording:** Sequence numbers do not identify destination. The 4-tuple identifies the connection; sequence numbers identify byte position inside the connection.

## TCP Stream vs UDP Datagram
- **TCP:** Reliable ordered byte stream. One `send()` does not equal one `read()`.
- **UDP:** Connectionless datagram protocol. Each send is a separate datagram, but delivery and ordering are not guaranteed.
- **TCP example:** `send("hello")` and `send("world")` may be read as `"helloworld"`, `"hel" + "loworld"`, or two separate reads.
- **Why framing is needed:** TCP does not preserve application message boundaries, so protocols need framing such as `Content-Length`, chunked encoding, delimiters, or length prefixes.
- **HTTP over TCP:** TCP delivers ordered bytes. HTTP defines meaning: method, path, headers, status code, body length, content type.

## TCP vs UDP Use Cases
- **TCP:** APIs, databases, file transfer, HTTP. Use when complete and ordered data matters.
- **UDP:** DNS, video calls, live streaming, gaming. Use when low latency matters more than perfect delivery.
- **DNS over UDP:** DNS queries are usually small, and TCP handshake overhead is not worth it for common lookups. DNS can retry on loss and fall back to TCP for large/truncated responses.

## Flow Control vs Congestion Control
- **Flow control:** Protects the receiver. Sender slows down if receiver cannot read or buffer data fast enough.
- **Congestion control:** Protects the network. Sender slows down when the network path appears overloaded, usually inferred from loss or high delay.
- **Interview shortcut:** Flow control = receiver bottleneck. Congestion control = network bottleneck.

## Request Lifetime vs Connection Lifetime
- **Request:** One application-level operation, such as `GET /users/123`.
- **Connection/socket:** Underlying transport channel that can carry one request or many requests.
- **Keep-alive:** One TCP connection can be reused for multiple HTTP requests.
- **Why it matters:** Creating a new TCP/TLS connection for every request adds handshake latency, CPU cost, and risk of ephemeral port exhaustion.
- **Interview wording:** Request lifetime and connection lifetime are separate. A request can finish while the TCP connection stays open for reuse.

## Production Socket Issues
- Accept backlog overflow when clients connect faster than server accepts them.
- File descriptor exhaustion when the process opens too many sockets.
- Connection leaks when sockets are not closed properly.
- Too many short-lived connections causing handshake overhead and ephemeral port exhaustion.
- Missing or too-long timeouts causing hanging connections.
- Slow clients holding sockets and consuming server resources.
- Keep-alive or idle timeout mismatch between client, load balancer, and server causing connection reset or socket hang up.

## TLS Termination and Load Balancers
- **HTTPS:** HTTP inside TLS.
- **TLS termination:** The TLS connection from the client ends at the load balancer. The load balancer decrypts the request, inspects HTTP data, and forwards the request to the backend.
- **L4 load balancer:** Routes using IP and port level information. It does not decrypt HTTPS traffic or inspect HTTP paths/headers, so it cannot route based on `/users/123`.
- **L7 load balancer:** Can route using HTTP information such as host, path, headers, cookies, auth, or rate limits. For HTTPS path routing, it must terminate TLS first.
- **Forwarding after termination:** `Browser --HTTPS--> LB --HTTP--> Backend` or `Browser --HTTPS--> LB --HTTPS--> Backend`.
- **Re-encryption:** If backend leg is HTTPS, there are two TLS connections: browser-to-LB and LB-to-backend. It is not one end-to-end TLS session.
- **L4 pass-through vs L7 termination:** Choose L4 pass-through for IP/port balancing and end-to-end TLS to backend. Choose L7 termination for HTTP-aware routing, centralized certificates, WAF, auth, rate limiting, and observability.

## Interview-Ready Answers

## What is a socket?
A socket is an OS-provided endpoint/interface used by an application for network communication. The application reads and writes data through the socket, while the OS handles the underlying transport protocol such as TCP or UDP.

## Why can many clients connect to the same server port?
Because a TCP connection is identified by source IP, source port, destination IP, destination port, and protocol. Even if many clients connect to the same server IP and port, their source IP or source port is different.

## Why does TCP need sequence numbers and ACKs after the handshake?
TCP needs sequence numbers and ACKs to keep the byte stream reliable and ordered. Sequence numbers identify byte positions, while ACKs tell the sender the next byte expected, allowing TCP to detect missing data and retransmit it.

## Why does HTTP need `Content-Length` if TCP is reliable?
TCP gives HTTP reliable ordered bytes, but it does not preserve message boundaries. HTTP needs framing rules like `Content-Length` or chunked encoding so the receiver knows where the response body ends.

## What does TLS termination mean?
TLS termination means the client's TLS connection ends at the load balancer. The load balancer decrypts the request, inspects HTTP data like path or headers, and then forwards it to the backend over either HTTP or a new HTTPS connection.

## When choose L4 pass-through vs L7 termination?
Choose L4 pass-through when only IP/port load balancing is needed and TLS should remain end-to-end to the backend. Choose L7 termination when HTTP-aware features are needed, such as path routing, centralized certificates, WAF, auth, rate limiting, or observability.

## Mistakes to Avoid
- Do not call a socket a protocol.
- Do not call a socket a frame.
- Do not say sequence numbers identify destination.
- Do not say TCP preserves messages. TCP preserves byte order, not message boundaries.
- Do not say TCP prevents packet loss. Packets can be lost; TCP detects loss and retransmits so the application receives a reliable byte stream.
- Do not say "socket TTL." Say keep-alive timeout or idle timeout.
- Do not say TCP provides trust. TLS provides identity verification and encryption.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
