---
title: "LeetCode 413: Arithmetic Slices"
summary: "LeetCode Problem Solving - 1D streak DP on contiguous subarrays"
description: "LeetCode study note from 2026-05-10"
date: 2026-05-10
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-10
Source Note: `notes/day21-week4-weekend-day2-api-recall-speed-round.md`

## Intuition

This is streak DP on contiguous subarrays. I define curr as the number of arithmetic slices ending at the current index, and total as the total number of arithmetic slices seen so far. Starting from index 2, if the last

Pattern: 1D streak DP on contiguous subarrays

## Approach

- **Pattern:** 1D streak DP on contiguous subarrays.

## Correct State
```text
curr = number of arithmetic slices ending at the current index
total = total number of arithmetic slices seen so far
```

## Why This State Fits
The problem is about:
```text
contiguous subarrays
```

So at each index `i`, only the last 2 adjacent differences matter:
```text
nums[i] - nums[i - 1]
nums[i - 1] - nums[i - 2]
```

If they match, then:
- every arithmetic slice ending at `i - 1` can extend to `i`
- plus the last 3 elements form one new arithmetic slice

So:
```text
curr += 1
total += curr
```

If the difference breaks:
```text
curr = 0
```

## Initialization
```text
curr = total = 0
```

Why:
```text
fewer than 3 elements cannot form an arithmetic slice
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- confusing contiguous subarrays with subsequences
- saying only the new length-3 slice matters and forgetting earlier slices can extend
- using extra state that duplicates the rolling DP meaning

## Interview-Ready Explanation
This is streak DP on contiguous subarrays. I define `curr` as the number of arithmetic slices ending at the current index, and `total` as the total number of arithmetic slices seen so far. Starting from index `2`, if the last 2 adjacent differences are equal, then every arithmetic slice ending at `i - 1` can extend to `i`, and the last 3 elements form one new slice, so I do `curr += 1` and `total += curr`. Otherwise the streak breaks and `curr = 0`. The time complexity is `O(n)` and the space complexity is `O(1)`.

## Code
```python
class Solution:
    def numberOfArithmeticSlices(self, nums: List[int]) -> int:
        total = 0
        curr = 0

        for i in range(2, len(nums)):
            if nums[i] - nums[i - 1] == nums[i - 1] - nums[i - 2]:
                curr += 1
                total += curr
            else:
                curr = 0

        return total
```

## Problem 3 - Patch Problem: LC 91 Decode Ways
- **Pattern:** Prefix DP with one-digit and two-digit transitions.

## Correct State
```text
dp[i] = number of ways to decode prefix s[:i]
```

## Base Case
```text
dp[0] = 1
```

Why:
```text
the empty prefix has one valid decoding: choose nothing
```

## Transitions
One-digit decode:
```text
if s[i - 1] != '0':
    dp[i] += dp[i - 1]
```

Two-digit decode:
```text
if i >= 2 and 10 <= int(s[i - 2:i]) <= 26:
    dp[i] += dp[i - 2]
```

## Important Zero Rule
```text
'0' cannot decode by itself
```

It only works as part of:
- `10`
- `20`

## Complexity
```text
Time: O(n)
Space: O(n)
```

## Common Mistakes
- mixing character-index thinking with prefix-index thinking
- forgetting `dp[0] = 1`
- letting `'0'` contribute through the one-digit transition
- saying return value is anything other than `dp[n]`

## Interview-Ready Explanation
This is prefix DP. I define `dp[i]` as the number of ways to decode the prefix `s[:i]`. The base case is `dp[0] = 1`, because the empty prefix has one valid decoding. For each position `i`, if `s[i - 1]` is not `'0'`, then the last character can decode by itself, so I add `dp[i - 1]`. If `i >= 2` and the last 2 characters form a valid number from `10` to `26`, then they can decode together, so I add `dp[i - 2]`. The answer is `dp[n]`.

## Code
```python
class Solution:
    def numDecodings(self, s: str) -> int:
        if s[0] == "0":
            return 0

        n = len(s)
        dp = [0] * (n + 1)
        dp[0] = 1

        for i in range(1, n + 1):
            if s[i - 1] != "0":
                dp[i] += dp[i - 1]

            if i >= 2 and 10 <= int(s[i - 2:i]) <= 26:
                dp[i] += dp[i - 2]

        return dp[n]
```

## Topic - API Failure Recall Speed Round

## First Judgment
The topic recall is now:
```text
good enough for Day 21
```

The main remaining weakness is not core understanding.

It is:
```text
first-answer precision under interview pressure
```

The user usually reaches the right answer after pushback, but Tier A/S signal improves if the first answer is already cleaner and more exact.

## `PUT` vs `PATCH`

### Strong Answer Components
`PUT` usually means:
- replace the full resource representation at a known URI
- repeated same full request should be idempotent

`PATCH` usually means:
- apply partial updates to an existing resource
- may or may not be idempotent depending on patch semantics

Real production nuance:
- the bigger issue is stale-write prevention, not only verb trivia
- both often need optimistic concurrency like `version`, `ETag`, or `If-Match`

### Main Risk
If a client sends partial data through a full-replacement contract:
```text
omitted fields may be accidentally cleared or overwritten
```

## `412` vs `409` vs `422`

### Strong Split
`412 Precondition Failed`:
- the client supplied an explicit precondition such as `If-Match`
- that precondition no longer holds
- precise stale-write answer

`409 Conflict`:
- the request conflicts with current server or resource state
- example: modifying a cancelled appointment into `checked_in`

`422 Unprocessable Entity`:
- payload shape is acceptable
- submitted data is semantically invalid
- example: `discharge_time < admission_time`

### Practical Rule
- `412` = stale precondition
- `409` = state conflict
- `422` = semantically invalid payload

## Retry-Safe `POST`

### Strong Answer Components
Use:
- durable idempotency key
- request fingerprint:
  - method
  - path
  - normalized payload or payload hash
- status such as `processing` and `completed`
- replay of original response for completed retries

### Core Contract
Same key + same payload + `completed`:
- replay original response and original status code

Same key + same payload + `processing`:
- return in-progress contract, often `202 Accepted`

Same key + different payload:
- reject, usually `409 Conflict`

No record:
- atomically create idempotency record first
- then perform side effect

### Why Durable Storage Matters
In-memory-only state is unsafe because of:
- process restart
- multi-instance routing
- TTL / eviction
- inability to prove whether the original side effect already committed

## REST vs gRPC

### Strong Split
REST is usually better externally because:
- broad client interoperability
- easier debugging
- easier JSON / HTTP tooling

gRPC is usually better internally because:
- strong schema contracts
- code generation
- efficient binary transport
- deadlines and service-to-service control in a controlled environment

### Important Nuance
Do not say:
```text
gRPC is just faster than HTTP
```

Safer answer:
```text
gRPC is often a better operational fit for internal service-to-service communication
```

## Full Request Path And Timeout Ambiguity

### Strong Path
1. browser / client resolves DNS
2. TCP connection established
3. TLS handshake
4. request reaches edge / LB / gateway
5. edge can apply rate limiting, trace propagation, and some authn checks
6. FastAPI app validates request and trusted identity context
7. app applies authorization and business logic
8. app checks idempotency or concurrency controls where needed
9. app uses DB connection pool and transaction boundary to talk to Oracle
10. response returns through the edge to the client

### Timeout Ambiguity
If the client times out, the backend may have:
- never received the request
- still be processing it
- already committed the DB write
- already generated the response but lost it on the way back

So:
```text
client timeout does not prove the side effect failed
```

That is why retries need idempotency and the request path needs traceability.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Pass.
