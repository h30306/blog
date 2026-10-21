---
title: "LeetCode 338: Counting Bits"
summary: "LeetCode 338 note: dp[i] = dp[i >> 1] + (i & 1), or dp[i] = dp[i - highest power of two] + 1"
description: "LeetCode 338 record from 2022-11-15"
date: 2022-11-15
tags: ["easy", "dynamic-programming", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-15
- Submissions: Wrong Answer ×4 → Runtime Error → Accepted → Wrong Answer ×2 → Accepted

## Approach

Shifting `i` right drops its lowest bit, so `bits(i) = bits(i >> 1) + (i & 1)`, and `i >> 1 < i` is already known ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}) Template 1 with [Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})). Alternatively drop the highest bit: with `offset` the largest power of two not above `i`, `bits(i) = bits(i - offset) + 1`, updating `offset` when `i` is a power of two (`i & (i - 1) == 0`).

## My Attempts

On 2022-11-15 I used the "drop the highest bit" form:

- The first four updated the offset at **every even number** (`if i % 2 == 0: count = i`), although it should be the highest power of two: `6` got offset 6, so `dp[6] = dp[0] + 1 = 1` instead of 2.
- Testing powers of two with `i & (i - 1) == 0` then hit `ans[1]` out of range for `n = 0`; a special case passed.
- On 2022-11-27 another counting variant failed twice before passing.

## Solution

```python
class Solution:
    def countBits(self, n: int) -> List[int]:
        dp = [0] * (n + 1)
        for i in range(1, n + 1):
            dp[i] = dp[i >> 1] + (i & 1)
        return dp
```

## Complexity

Time `O(n)`, space `O(n)` (output).

## Mistakes to Avoid

- The highest-bit offset changes only at powers of two, not at every even number.
- For `n = 0` the array has one cell, so `dp[1]` cannot be set.

## Interview Explanation

Shifting i right drops its lowest bit, giving a smaller, already computed number, so dp[i] is dp[i >> 1] plus i's lowest bit. Time `O(n)`.
