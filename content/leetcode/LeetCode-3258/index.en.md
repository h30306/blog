---
title: "LeetCode 3258: Count Substrings That Satisfy K-Constraint I"
summary: "LeetCode 3258 note: valid means zeros <= k or ones <= k; it is invalid only when both exceed k, and after shrinking there are right - left + 1 valid substrings ending at right"
description: "LeetCode 3258 record from 2026-01-18"
date: 2026-01-18
tags: ["easy", "sliding-window", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-18
- Submissions: Accepted (first try)

## Approach

Valid ⇔ the count of `0` is `<= k` **or** the count of `1` is `<= k`. Conversely, invalid ⇔ both are `> k`.

Neither count decreases as the window grows, so "invalid" is monotonic:

- Add on the right; shrink the left while both counts exceed `k`.
- There are `right - left + 1` valid substrings ending at `right` (any left end in `[left, right]`).

## My Solution

```python
class Solution:
    def countKConstraintSubstrings(self, s: str, k: int) -> int:
        cnt = Counter()
        left = count = 0
        for right, c in enumerate(s):
            cnt[c] += 1
            while cnt["0"] > k and cnt["1"] > k:
                cnt[s[left]] -= 1
                left += 1
            count += right - left + 1
        return count
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Writing the shrink condition with `or`: one count `<= k` is enough to be valid, so shrink only when both exceed `k`.

## Interview Explanation

A substring is valid when either the zeros or the ones are at most `k`, so it is invalid only when both exceed `k`, which is monotonic. I slide a window that shrinks while both exceed `k`, and add `right - left + 1` valid substrings ending at each right end. Time `O(n)`.
