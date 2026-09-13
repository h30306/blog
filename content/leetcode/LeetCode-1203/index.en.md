---
title: "LeetCode 1203: Sort Items by Groups Respecting Dependencies"
summary: "LeetCode Problem Solving - Sort Items by Groups Respecting Dependencies"
description: "LeetCode study note from 2026-04-13"
date: 2026-04-13
tags: ["hard", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-04-13
Source Note: `notes/day4-tcp-production-behavior.md`

## Intuition

Reason: This is a highdifficulty twolevel topo sort problem. It requires grouplevel and itemlevel ordering, so it should be attempted after standard topo variants are stable. Topic TCP Production Behavior Goal Day 3 cove

Pattern: see the study notes below.

## Approach

- **Reason:** This is a high-difficulty two-level topo sort problem. It requires group-level and item-level ordering, so it should be attempted after standard topo variants are stable.

## Topic - TCP Production Behavior

## Goal
Day 3 covered TCP/socket fundamentals. Day 4 focuses on production and interview follow-up questions:
- Why does API latency increase under load?
- Why can clients see `socket hang up` or `connection reset`?
- Why not create a new TCP connection for every request?
- What happens when traffic spikes faster than the server can accept connections?
- How do connection pools, timeouts, and OS limits affect backend reliability?

## Connection Pooling / Keep-Alive

## Core Idea
- A request is one application-level operation.
- A TCP connection/socket is the transport channel underneath.
- One TCP connection can carry multiple requests over time using keep-alive or connection pooling.

## Bad Model
```text
request 1 -> new TCP connection -> close
request 2 -> new TCP connection -> close
request 3 -> new TCP connection -> close
```

This is expensive because every request pays:
- TCP handshake
- TLS handshake if HTTPS
- kernel/socket setup cost
- client-side ephemeral port usage
- server-side file descriptor usage

## Better Model
```text
open TCP connection once
request 1 -> response 1
request 2 -> response 2
request 3 -> response 3
close later when idle
```

## Interview-Ready Answer
Connection pooling avoids creating a new TCP/TLS connection for every request. This reduces handshake latency, CPU overhead, file descriptor churn, and risk of ephemeral port exhaustion.

## Idle Timeout Mismatch

## Core Idea
Idle timeout mismatch happens when the client keeps an idle connection longer than the server or load balancer does.

Example:
```text
t=0   request succeeds
t=30  load balancer closes idle TCP connection
t=45  client thinks connection is still reusable
t=45  client sends next request on stale connection
```

Possible result:
- connection reset
- broken pipe
- socket hang up

## Correct Setting
If the load balancer closes idle connections after 30 seconds, the client pool should use a shorter idle timeout than 30 seconds.

## Why
The client should proactively discard idle connections before the load balancer or server closes them. Otherwise, the client may reuse a stale connection.

## Interview-Ready Answer
Idle timeout mismatch happens when the client keeps an idle connection longer than the server or load balancer. The client may later reuse a stale connection that the other side already closed, causing connection reset, broken pipe, or socket hang up.

## Accept Backlog Overflow

## Core Idea
Accept backlog matters when clients create new TCP connections.

A server has a listening socket:
```text
server listens on :8000
```

When clients try to connect, the OS handles TCP connection setup and queues connections before the application accepts them.

If clients connect faster than the server accepts:
```text
new TCP connections arrive too fast
-> accept backlog fills
-> new connections delayed / refused / dropped / timed out
```

## Common Causes
- Traffic spike
- Server CPU busy
- Application event loop blocked
- Too few worker processes or threads
- Backlog setting too small
- Too many short-lived connections

## Why Connection Pooling Helps
Existing keep-alive connections do not go through the accept backlog again. Reusing connections reduces pressure on new connection handling.

## Interview-Ready Answer
Creating a new TCP connection per request turns a request spike into a connection spike. The server must handle many handshakes and accept many new sockets, which can fill the accept backlog and cause connection delay, timeout, or refusal.

## Ephemeral Port Exhaustion

## Core Idea
When a client opens a TCP connection, it uses a temporary source port:

```text
client_ip:ephemeral_port -> server_ip:443
```

Example:
```text
10.0.1.20:51523 -> 10.0.2.10:443
```

If a service creates too many short-lived outbound connections, it can run out of available ephemeral ports. Closed TCP connections may also remain in `TIME_WAIT` for a while, delaying port reuse.

## Which Side Is Affected?
Usually the service making many outbound connections, not the service accepting them.

Example:
```text
Service A -> Service B
```

If Service A opens many new connections to Service B, Service A is more likely to hit ephemeral port exhaustion.

## Interview-Ready Answer
The service making many outbound connections usually suffers ephemeral port exhaustion because each outbound TCP connection needs a temporary source port. The accepting service listens on a fixed destination port, although it can still hit other limits like file descriptors.

## File Descriptor Exhaustion

## Core Idea
On Unix-like systems, sockets are represented as file descriptors. A process has a limit on how many file descriptors it can open.

If too many sockets are open, the process may log:
```text
Too many open files
```

## Common Causes
- Too many concurrent client connections
- Connection leaks
- Slow clients holding connections open
- Missing read/write/idle timeouts
- Oversized connection pools
- Outbound sockets not closed properly

## Common Fixes
- Close leaked sockets/connections
- Set proper read/write/idle timeouts
- Limit max concurrent connections
- Tune connection pool size
- Add more instances
- Increase file descriptor limit if the workload genuinely needs it

## Interview-Ready Answer
`Too many open files` means the process has exhausted its file descriptor limit. Since sockets are represented as file descriptors, too many open socket connections or leaked sockets can cause this error.

## Slow Clients

## Core Idea
A slow client is a client that connects successfully but reads or writes very slowly.

This matters because each slow connection stays open longer and consumes:
- socket/file descriptor
- memory buffers
- worker/thread/event-loop capacity
- connection limit slots

Even with low request rate, many slow clients can reduce capacity for normal clients.

## Common Protections
- Read timeout
- Write timeout
- Idle timeout
- Max request body size
- Reverse proxy buffering
- Connection limits
- Rate limiting

## Interview-Ready Answer
Slow clients can cause resource problems because each slow connection stays open longer and consumes a socket/file descriptor, buffers, and sometimes worker or event-loop capacity. Even with low request rate, many slow clients can exhaust connection limits or file descriptors and reduce capacity for normal clients.

## Timeout Strategy

## Important Timeouts
- **Connection timeout:** How long to wait to establish TCP/TLS connection.
- **Read timeout:** How long to wait for response data.
- **Write timeout:** How long to wait while sending data.
- **Idle timeout:** How long to keep an unused keep-alive connection.
- **Request timeout:** Total max time for one request.

## Why Missing Timeouts Are Dangerous
Without timeouts, bad network conditions or slow backends can leave calls hanging indefinitely.

Hanging calls can hold:
- sockets
- connection pool slots
- request threads
- memory
- file descriptors

This can spread a backend outage to caller services.

## Interview-Ready Answer
Without read timeouts, calls to a slow or partially down backend can hang indefinitely. Those hanging calls hold connection pool slots, sockets, threads, and memory in the caller service, eventually exhausting the caller's resources and spreading the outage.

## HTTP/2 Note

## HTTP/1.1
With HTTP/1.1, one TCP connection usually handles one in-flight request at a time.

If a request hangs, it can block that connection from being reused.

## HTTP/2
With HTTP/2, one TCP connection can carry multiple concurrent streams.

```text
1 TCP connection -> many HTTP/2 streams
```

A hanging request may block one stream rather than the whole connection, but it can still consume:
- stream slots
- buffers
- memory
- request limits

## Interview-Ready Answer
With HTTP/2, a hanging request usually consumes a stream slot rather than an entire TCP connection, because multiple requests can multiplex over one connection. But it can still exhaust max concurrent streams, buffers, memory, or request limits. So timeouts are still required even with HTTP/2.

## Checkpoint Answers

## What problem does connection pooling solve?
Connection pooling avoids creating a new TCP/TLS connection for every request. This reduces handshake latency, CPU overhead, file descriptor churn, and risk of ephemeral port exhaustion.

## What is idle timeout mismatch?
Idle timeout mismatch happens when the client keeps an idle connection longer than the server or load balancer does. The client may later reuse a stale connection that the other side already closed, causing connection reset, broken pipe, or socket hang up.

## Why can creating a new TCP connection per request make traffic spikes worse?
Creating a new TCP connection per request turns a request spike into a connection spike. The server must handle many handshakes and accept many new sockets, which can fill the accept backlog and cause connection delay, timeout, or refusal.

## Which side usually suffers ephemeral port exhaustion?
The service making many outbound connections usually suffers ephemeral port exhaustion because each outbound TCP connection needs a temporary source port. The accepting service listens on a fixed destination port.

## Why can missing read timeouts spread an outage?
Without read timeouts, calls to a slow or partially down backend can hang indefinitely. Those hanging calls hold connection pool slots, sockets, threads, and memory in the caller service, eventually exhausting the caller's resources and spreading the outage.

## Mistakes to Avoid
- Do not say "socket TTL." Say keep-alive timeout or idle timeout.
- Do not say "socket size limit." Say file descriptor limit, buffer limit, or connection limit depending on context.
- Do not call hanging requests a memory leak by default. Say they consume memory/resources unless there is an actual leak bug.
- Do not confuse accept backlog with file descriptor exhaustion.
- Do not say HTTP/2 removes the need for timeouts. It reduces connection pressure but stream/resource limits still exist.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Deferred to end of topological sort section.
