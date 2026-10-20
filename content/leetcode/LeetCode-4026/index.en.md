---
title: "LeetCode 4026: Maximum Gap Between Stations"
summary: "LeetCode 4026 note: greedily match from the left for each worker's earliest station and from the right for the latest; splitting between workers i and i+1, the largest gap is latest[i+1] - earliest[i]"
description: "LeetCode 4026 record from 2026-08-26"
date: 2026-08-26
tags: ["medium", "two-pointers", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-26
- Submissions: Wrong Answer → Accepted

## Approach

Workers must take stations in increasing index order with `skill[i] == station[j]`, which means matching `skill` as a subsequence of `station`.

To maximize the gap between workers `i` and `i + 1`:

- Push workers `0..i` as far **left** as possible: a greedy left-to-right match gives each worker's **earliest** station `earliest[i]`.
- Push workers `i + 1..n - 1` as far **right** as possible: a greedy right-to-left match gives the **latest** station `latest[i + 1]`.

The two sides do not interfere (`earliest[i] < latest[i + 1]`, since a valid assignment is guaranteed), so the gap `latest[i + 1] - earliest[i]` is achievable. The answer is its maximum over all `i`.

Both greedy matches walk two same-direction pointers over `skill` and `station`, like a subsequence check.

## My Attempts

Attempt 1 built the right-side list by appending from the last worker backwards, so `latest` was **reversed**, but it used `latest[i + 1]` directly. For `skill = "ab"`, `station = "aabb"`, the earliest `a` is at 0 and the latest `b` at 3, so the answer is 3; this returned 1.

Adding `right.reverse()` passed.

## Solution

```python
class Solution:
    def maximumGap(self, skill: str, station: str) -> int:
        n, m = len(skill), len(station)
        earliest = [0] * n
        j = 0
        for i in range(n):
            while station[j] != skill[i]:
                j += 1
            earliest[i] = j                        # earliest station for worker i
            j += 1

        latest = [0] * n
        j = m - 1
        for i in range(n - 1, -1, -1):
            while station[j] != skill[i]:
                j -= 1
            latest[i] = j                          # latest station for worker i
            j -= 1

        return max((latest[i + 1] - earliest[i] for i in range(n - 1)), default=0)
```

Writing `latest[i]` by index avoids the reversal. With one worker, `default=0`.

## Complexity

Time `O(n + m)`, space `O(n)`.

## Mistakes to Avoid

- A list appended from right to left is reversed.
- With one worker the answer is 0.

## Interview Explanation

Assigning stations is matching `skill` as a subsequence of `station`. To maximize the gap between two neighboring workers, the earlier workers go as far left and the later ones as far right as possible. I greedily match from the left for each worker's earliest station and from the right for the latest, then take the maximum of `latest[i + 1] - earliest[i]` over the split points. Both passes are same-direction pointers, `O(n + m)`.
