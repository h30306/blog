---
title: "LeetCode 2831: Find the Longest Equal Subarray"
summary: "LeetCode 2831 note: list the positions of each value and slide a window over that list; the deletions needed are the span of positions minus the number of copies"
description: "LeetCode 2831 record from 2026-01-11"
date: 2026-01-11
tags: ["medium", "sliding-window", "hash-table", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-11
- Submissions: Wrong Answer → Time Limit Exceeded ×2 → Accepted

## Approach

What remains is copies of one value `v`. **Handle each value separately**:

- List the positions where `v` appears, `pos = [p0, p1, ...]`.
- Keeping the copies at `pos[l..r]` means deleting everything between them: `(pos[r] - pos[l] + 1) - (r - l + 1)` deletions.
- Slide a window over `pos`: shrink the left while deletions exceed `k`; the answer is the largest `r - l + 1`.

All the position lists together have length `n`, so this is `O(n)`.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1, WA | Slid over the original array, checking `length - most frequent count > k`, and returned `longest window - k`. But a window does not necessarily delete exactly `k`. For `nums = [2]`, `k = 2`, the answer is 1; this returned `1 - 2 = -1` |
| Attempts 2–3, TLE | Returned `max(freq.values())` instead, which is correct, but took `max` over the whole count table every step: `O(n · distinct values)` |
| AC | Slid separately over each value's position list |

## Solution

```python
class Solution:
    def longestEqualSubarray(self, nums: List[int], k: int) -> int:
        positions = defaultdict(list)
        for i, v in enumerate(nums):
            positions[v].append(i)

        best = 0
        for pos in positions.values():
            left = 0
            for right in range(len(pos)):
                while (pos[right] - pos[left] + 1) - (right - left + 1) > k:
                    left += 1                      # too many deletions in between
                best = max(best, right - left + 1)
        return best
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Using `window length - k` as the answer: the window does not necessarily delete exactly `k`.
- Taking `max` over the count table every step: `O(n · distinct)`.

## Interview Explanation

What remains is one value, so I handle each value separately: list its positions, and keeping a consecutive run of them requires deleting the span of positions minus the count. A sliding window over the position list shrinks when deletions exceed `k`, and the number of copies in the window is a candidate answer. All lists total `n`, so time is `O(n)`.
