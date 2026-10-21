---
title: "LeetCode 396: Rotate Function"
summary: "LeetCode 396 note: F(k) and F(k - 1) differ by one formula: F(k) = F(k - 1) + sum - n × the element moved to the front"
description: "LeetCode 396 record from 2022-11-16"
date: 2022-11-16
tags: ["medium", "array", "math", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-16
- Submissions: Time Limit Exceeded → Wrong Answer ×2 → Accepted

## Approach

Each rotation raises every coefficient by 1 except the last element's, adding `sum - nums[last]`; the last element's coefficient drops from `n - 1` to 0, losing `(n - 1) × nums[last]`. Together `F(k) = F(k - 1) + sum - n × nums[n - k]`. Compute `F(0)` and roll the recurrence, in `O(n)` ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}) Template 1).

## My Attempts

- The first 2022 version computed every rotation directly, `O(n²)` and a TLE, and `range(len(nums) - 1)` skipped one rotation. The second never accumulated the recurrence into `cur_sum`, always starting from `F(0)`.
- In a 2026 rewrite the index of the element moved to the front started at a fixed `3`, **hard-coded from the example's length**, so other lengths failed; `range(n - 1, 0, -1)` passed.

## Solution

```python
class Solution:
    def maxRotateFunction(self, nums: List[int]) -> int:
        n, total = len(nums), sum(nums)
        cur = best = sum(i * x for i, x in enumerate(nums))
        for k in range(1, n):
            cur += total - n * nums[n - k]
            best = max(best, cur)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The element moved to the front at rotation `k` is `nums[n - k]`; the index must follow `k`.
- Computing each rotation directly is `O(n²)` and times out.

## Interview Explanation

Each rotation raises every coefficient by one except for the element moved to the front, so F(k) = F(k - 1) + sum - n × that element. I compute F(0) and roll the recurrence, keeping the maximum. Time `O(n)`.
