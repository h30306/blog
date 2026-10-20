---
title: "LeetCode 3824: Minimum K to Reduce Array Within Limit"
summary: "LeetCode 3824 note: binary search on k with a monotonic check; the upper bound must reach n because there are at least n operations"
description: "LeetCode 3824 record from 2026-01-31"
date: 2026-01-31
tags: ["medium", "binary-search", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-31
- Submissions: Wrong Answer ×4 → Accepted

## Approach

Each operation reduces one element by `k`; making every element `<= 0` takes `ops(k) = sum(ceil(x / k))` operations. Find the smallest `k` with `ops(k) <= k²`.

**Monotonicity**: as `k` grows, `ops(k)` stays the same or shrinks while `k²` grows. So if `k` works, every larger `k` works, and `k` can be binary searched.

**Upper bound**: every element needs at least one operation, so `ops(k) >= n` and `k² >= n` is required. When `k >= max(nums)`, each element takes exactly one operation, so `ops = n`. Hence `k = max(max(nums), n)` always works and serves as the upper bound.

## My Attempt: an upper bound that was too small

```python
left, right = 1, max(nums)
```

Take `nums = [1, 1, 1, 1, 1]`: `max(nums) = 1`, but `k = 1` needs 5 operations and `5 > 1²`, so it fails. The answer is 3 (`ops = 5 <= 9`), larger than `max(nums)`.

The next three attempts special-cased "only one possible value", e.g. computing from `n ** 0.5`, without addressing the real problem: **the upper bound was too small**. Changing it to `right = max(max(nums), n)` passed.

## Solution

```python
class Solution:
    def minimumK(self, nums: List[int]) -> int:
        def ops(k: int) -> int:
            return sum((x + k - 1) // k for x in nums)

        lo, hi = 1, max(max(nums), len(nums))
        while lo < hi:
            mid = (lo + hi) // 2
            if ops(mid) <= mid * mid:
                hi = mid
            else:
                lo = mid + 1
        return lo
```

`(x + k - 1) // k` is `ceil(x / k)`.

## Complexity

Time `O(n log(max(max(nums), n)))`, space `O(1)`.

## Mistakes to Avoid

- Using only `max(nums)` as the upper bound: the answer can be larger.
- Adding special cases while stuck instead of asking "is the upper bound always feasible?".
- Computing `ceil` with floats: use the integer formula.

## Interview Explanation

As `k` grows the operation count can only drop while `k²` grows, so the condition is monotonic in `k` and can be binary searched. The upper bound must be feasible: every element needs at least one operation, and with `k` at least the maximum it takes exactly `n`, so I use `max(max(nums), n)`, where `n <= k²` always holds. Each check is `O(n)`, `O(n log)` total.
