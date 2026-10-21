---
title: "LeetCode 313: Super Ugly Number"
summary: "LeetCode 313 note: generalizing LC 264 with one pointer per prime; with a heap, avoid pushing the same number many times"
description: "LeetCode 313 record from 2022-11-16"
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
- Submissions: Wrong Answer ×2 → Output Limit Exceeded → Accepted → Wrong Answer → Accepted → Output Limit Exceeded → Wrong Answer → Output Limit Exceeded → Wrong Answer

## Approach

As in LC 264, each prime `p` has a pointer `idx[p]`; the next value is the minimum of `u[idx[p]] * p`, and every matching pointer advances, in `O(nk)`.

A heap version must handle duplicates: `6` is pushed both as `2 × 3` and `3 × 2`. One trick is, after popping `x`, to multiply only by primes **up to `x`'s smallest prime factor** (stop once `x % p == 0`), so each number is generated exactly once, as its smallest prime factor times the rest ([Heap]({{< relref "/algorithm/Heap" >}})).

## My Attempts

I wrote this with a heap and failed 8 times, all about duplicates:

- 2022-11-16: after popping `p` I pushed `p` times each prime, stopping only when `p == prime`, **which stops only if `p` is itself prime**; composites such as 6 still produced duplicates, the same number was popped twice, and the answers shifted.
- 2022-11-26: some versions dropped the stopping rule entirely, making more duplicates; changing it to `p % prime == 0` (stop at `p`'s smallest prime factor) passed. Three more were Output Limit Exceeded from `print`s.

## Solution

```python
class Solution:
    def nthSuperUglyNumber(self, n: int, primes: List[int]) -> int:
        u = [1]
        idx = [0] * len(primes)
        while len(u) < n:
            nxt = min(u[idx[k]] * p for k, p in enumerate(primes))
            u.append(nxt)
            for k, p in enumerate(primes):
                if u[idx[k]] * p == nxt:
                    idx[k] += 1
        return u[-1]
```

## Complexity

Time `O(nk)` for `k` primes, space `O(n + k)`.

## Mistakes to Avoid

- Without deduplication a heap pops the same number many times.
- The stopping rule is `x % p == 0` (`p` is `x`'s smallest prime factor), not `x == p`.

## Interview Explanation

Generalizing LC 264, each prime has a pointer to the next ugly number to multiply; I take the smallest product and advance every matching pointer, in `O(nk)`. A heap also works if duplicates are avoided.
