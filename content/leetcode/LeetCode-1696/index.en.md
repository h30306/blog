---
title: "LeetCode 1696: Jump Game VI"
summary: "LeetCode 1696 note: dp[i] = nums[i] + max of the previous k dp values, with that max kept by a monotonic deque in O(n)"
description: "LeetCode 1696 record from 2025-08-10"
date: 2025-08-10
tags: ["medium", "dynamic-programming", "monotonic-queue", "queue", "heap"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-10
- Submissions: Wrong Answer → Time Limit Exceeded → Accepted

## Approach

`dp[i]` = the best score walking from index 0 to `i`. The previous step lies in `i - k` to `i - 1`:

```text
dp[i] = nums[i] + max(dp[i - k], ..., dp[i - 1])
```

Directly that is `O(nk)`, too slow with `n` and `k` up to `10^5`. The max of the previous `k` is a sliding window maximum, kept by a monotonic deque:

1. Pop front indices `< i - k` (expired).
2. `dp[i] = nums[i] + dp[front]`.
3. Pop back entries with `dp <= dp[i]` (dominated), then push `i`.

## My Attempts

1. **Attempt 1, WA**: `dp[i + 1]` meant reaching `i` with `dp[0] = 0`, but the transition range let any of the first `k` cells jump straight from `dp[0]`, which **allowed not starting at index 0**. For `nums = [-1, 5]`, `k = 2`, the `-1` must be visited, so the answer is 4; this returned 5.
2. **Attempt 2, TLE**: switched to `dp[0] = nums[0]`, which is correct, but the double loop is `O(nk)`.
3. **AC**: replaced it with a monotonic deque.

## Solution

```python
from collections import deque

class Solution:
    def maxResult(self, nums: List[int], k: int) -> int:
        n = len(nums)
        dp = [0] * n
        dp[0] = nums[0]                            # always start at index 0
        dq = deque([0])                            # indices, dp values decreasing
        for i in range(1, n):
            if dq[0] < i - k:
                dq.popleft()                       # expired
            dp[i] = nums[i] + dp[dq[0]]
            while dq and dp[dq[-1]] <= dp[i]:
                dq.pop()                           # dominated by dp[i]
            dq.append(i)
        return dp[-1]
```

My accepted version checked expiry after computing `dp[i]` (`dq[0] <= i - k`), dropping one step early what would expire next round, with the same result; checking before reading is more intuitive.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The start is always index 0: `dp[0] = nums[0]`, not 0.
- An `O(nk)` double loop times out.

## Interview Explanation

`dp[i]` is the best score reaching `i`: `nums[i]` plus the max of the previous `k` dp values. That max is a sliding window maximum, so a monotonic deque keeps it, dropping expired indices at the front and dominated ones at the back, with the maximum at the front. Each index enters and leaves once: `O(n)`.
