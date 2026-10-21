---
title: "LeetCode 1461: Check If a String Contains All Binary Codes of Size K"
summary: "LeetCode 1461 note: put every length-k substring in a set and check that its size reaches 2^k; the last start is len(s) - k"
description: "LeetCode 1461 record from 2026-01-05"
date: 2026-01-05
tags: ["medium", "hash-table", "string", "bit-manipulation", "rolling-hash"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-05
- Submissions: Wrong Answer ×2 → Accepted

## Approach

There are `2^k` binary codes of length `k`. Put every length-`k` substring of `s` in a set ([String]({{< relref "/algorithm/String" >}}) Template 3); a size of `2^k` means all are present.

- There are only `len(s) - k + 1` substrings; fewer than `2^k` means it cannot work, so return early.
- With `k <= 20`, a rolling integer can replace substrings: `code = ((code << 1) | bit) & mask`, avoiding slices.

## My Attempts

1. **Attempt 1** added `s[right - k: right]`, which excludes `right`, so **the last window was never collected**. For `"10"`, `k = 1` it only collected `"1"` and returned `False`; the answer is `True`.
2. **Attempt 2** changed it to `s[right - k - 1: right]`, length `k + 1`, which is worse.
3. `s[right - k + 1: right + 1]` passed.

## Solution

```python
class Solution:
    def hasAllCodes(self, s: str, k: int) -> bool:
        need = 1 << k
        if len(s) - k + 1 < need:
            return False
        seen = {s[i:i + k] for i in range(len(s) - k + 1)}
        return len(seen) == need
```

## Complexity

Time `O(n · k)`, space `O(min(n, 2^k) · k)`. A rolling integer brings time down to `O(n)`.

## Mistakes to Avoid

- `s[a:b]` has length `b - a` and excludes `b`.
- With fewer than `2^k` substrings, return `False` immediately.

## Interview Explanation

I put every length-`k` substring in a set and check whether its size is `2^k`; if there are fewer substrings than `2^k` the answer is `False` right away. A rolling bitmask of the current `k` bits avoids slicing. Time `O(nk)`.
