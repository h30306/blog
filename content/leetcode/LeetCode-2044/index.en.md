---
title: "LeetCode 2044: Count Number of Maximum Bitwise-OR Subsets"
summary: "LeetCode 2044 note: the maximum OR is the OR of everything; once backtracking reaches it, count the rest as 2^k"
description: "LeetCode 2044 record from 2025-07-29"
date: 2025-07-29
tags: ["medium", "backtracking", "bit-manipulation", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-29
- Submissions: Accepted → Accepted (bitmask version) → Accepted (backtracking rewrite)

## Approach

1. **The maximum OR is the OR of all elements**: OR only adds bits, so taking more never makes it smaller.
2. Then count the non-empty subsets whose OR equals that maximum.

With `n <= 16`, there are at most `2^16 = 65536` subsets, so full enumeration also works.

## Solution 1: backtracking with pruning

Take or skip each element. **Once the current OR equals the maximum, the remaining elements cannot change it**, so the remaining `n - i` elements contribute `2^(n - i)` choices at once.

```python
class Solution:
    def countMaxOrSubsets(self, nums: List[int]) -> int:
        n = len(nums)
        max_or = 0
        for x in nums:
            max_or |= x

        def backtrack(i: int, cur: int) -> int:
            if cur == max_or:
                return 1 << (n - i)               # the rest is free
            if i == n:
                return 0
            return backtrack(i + 1, cur | nums[i]) + backtrack(i + 1, cur)

        return backtrack(0, 0)
```

`cur` starts at 0, the OR of the empty set. As long as `max_or > 0`, the empty set is never counted; since `nums[i] >= 1`, `max_or` is always positive.

## Solution 2: bitmask enumeration

```python
class Solution:
    def countMaxOrSubsets(self, nums: List[int]) -> int:
        n = len(nums)
        max_or = 0
        for x in nums:
            max_or |= x
        res = 0
        for mask in range(1, 1 << n):
            cur = 0
            for i in range(n):
                if mask >> i & 1:
                    cur |= nums[i]
            res += cur == max_or
        return res
```

This is `O(n · 2^n)`; my submission took 1320ms, much slower than the backtracking version.

## Complexity

| Approach | Time |
|---|---|
| Backtracking with pruning | worst `O(2^n)`, pruning helps a lot in practice |
| Bitmask | `O(n · 2^n)` |

## Mistakes to Avoid

- Searching for the maximum OR separately: it is simply the OR of everything.
- Counting the empty subset.
- Bit operator precedence: `mask & 1 << i` means `mask & (1 << i)`. It works but is easy to misread; add parentheses or write `mask >> i & 1`.

## Interview Explanation

OR only adds bits, so the maximum OR is the OR of all elements. I backtrack over taking or skipping each element, and as soon as the current OR equals the maximum, the remaining elements cannot change it, so I add `2^(remaining count)` directly. With `n` at most 16, the worst case is `O(2^n)`.
