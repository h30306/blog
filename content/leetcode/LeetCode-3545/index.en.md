---
title: "LeetCode 3545: Minimum Deletions for At Most K Distinct Characters"
summary: "LeetCode 3545 note: reducing the number of kinds means deleting whole kinds, starting from the least frequent"
description: "LeetCode 3545 record from 2025-05-11"
date: 2025-05-11
tags: ["easy", "greedy", "hash-table", "string", "sorting", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-05-11
- Submissions: Accepted (first try)

## Approach

Deleting only part of a character's occurrences does not reduce the number of kinds, so **delete whole kinds**. With `m` kinds and at most `k` allowed, delete `m - k` kinds, choosing the least frequent ones to minimize deleted characters.

## My Solution

```python
class Solution:
    def minDeletion(self, s: str, k: int) -> int:
        freq = sorted(Counter(s).values())
        drop = max(0, len(freq) - k)
        return sum(freq[:drop])
```

I originally sorted the `Counter` into a dict by count and counted up to `len - k` entries; sorting `values()` is enough.

## Complexity

Time `O(n + σ log σ)` with `σ` kinds (at most 26), space `O(σ)`.

## Mistakes to Avoid

- When there are already `<= k` kinds, `len(freq) - k` is negative, and `freq[:negative]` slices from the end; clamp with `max(0, ...)`.

## Interview Explanation

Partial deletion never reduces the kinds, so only whole kinds can go. I count each character, sort the counts ascending, and delete the `m - k` smallest kinds, summing their counts. Time `O(n)`.
