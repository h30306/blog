---
title: "LeetCode 1425: Constrained Subsequence Sum"
summary: "LeetCode 1425 note: dp[i] = nums[i] + max(0, max of the previous k dp values); that max is a sliding window maximum, available in O(1) from a monotonic deque"
description: "LeetCode 1425 record from 2026-09-10"
date: 2026-09-10
tags: ["hard", "sliding-window", "dynamic-programming", "monotonic-queue", "heap", "queue", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-10
- Submissions: Time Limit Exceeded → Accepted ×2

## Approach

`dp[i]` = the best sum of a subsequence ending at `nums[i]`. The previous element must lie in `[i - k, i - 1]`, or `nums[i]` starts a new one:

```text
dp[i] = nums[i] + max(0, max(dp[i-k], ..., dp[i-1]))
```

Computed directly that is `O(nk)`. `max(dp[i-k..i-1])` is a **sliding window maximum of length `k`**, kept by a monotonic deque of indices with decreasing `dp` values:

1. Pop front indices `< i - k` (expired).
2. The front is the window maximum; extend from it only if it is `> 0`.
3. Pop back entries with `dp <= dp[i]` (dominated), then push `i`.

The answer is `max(dp)` (the subsequence must be non-empty).

## My Attempts

Attempt 1 tried to jump forward greedily block by block, bridging each block with one number. The loop ended with `i = j`, where `j` is the block's last position, so on the final block (or whenever `k = 1`) `j == i`, `i` never advanced, and the loop never ended: TLE. The DP with a monotonic deque above passed.

## Solution

```python
from collections import deque

class Solution:
    def constrainedSubsetSum(self, nums: List[int], k: int) -> int:
        dp = nums[:]
        dq = deque()                               # indices, dp values decreasing
        for i in range(len(nums)):
            if dq and dq[0] < i - k:
                dq.popleft()                       # expired
            if dq and dp[dq[0]] > 0:
                dp[i] += dp[dq[0]]                 # extend the best previous element
            while dq and dp[dq[-1]] <= dp[i]:
                dq.pop()                           # dominated by dp[i]
            dq.append(i)
        return max(dp)
```

My original wrote `dp = nums`, which modifies the input; `nums[:]` copies it.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Taking the max of the previous `k` directly in `O(nk)`: `n` and `k` both reach `10^5`.
- When the best previous value is negative, do not extend it; starting fresh is better.
- The answer is `max(dp)`, not `dp[-1]`.

## Interview Explanation

`dp[i]` is the best sum ending at `nums[i]`: `nums[i]` plus the max of the previous `k` dp values, skipped if that max is negative. The max of the previous `k` is a sliding window maximum, so a monotonic deque keeps it, dropping expired indices at the front and dominated ones at the back, with the maximum at the front. Each index enters and leaves once: `O(n)`.
