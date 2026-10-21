---
title: "LeetCode 541: Reverse String II"
summary: "LeetCode 541 note: in every block of 2k reverse the first k; when fewer than k remain reverse them all, which slicing handles automatically"
description: "LeetCode 541 record from 2022-08-25"
date: 2022-08-25
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-25
- Submissions: Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted → Runtime Error ×2 → Wrong Answer ×2 → Accepted

## Approach

Step from 0 by `2k` and reverse `[i, i + k)` ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1). When fewer than `k` characters remain, all of them are reversed, and the slice `a[i:i + k]` truncates at the end, which matches exactly.

## My Attempts

The 2022 versions reversed only **the first block**: `"cddebd"`, `k = 2` should be `"dcdedb"`; it returned `"dcdebd"`. In 2026 I reversed only when `i + k <= n`, **skipping a final block shorter than `k`**: `"cd"`, `k = 4` should be `"dc"`; it returned `"cd"`.

## Solution

```python
class Solution:
    def reverseStr(self, s: str, k: int) -> str:
        a = list(s)
        for i in range(0, len(a), 2 * k):
            a[i:i + k] = reversed(a[i:i + k])
        return "".join(a)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Not just the first block: every block of `2k`.
- Fewer than `k` remaining are reversed too.

## Interview Explanation

Stepping by `2k`, I reverse the first `k` of each block, and slicing automatically reverses only what remains at the end. Time `O(n)`.
