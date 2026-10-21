---
title: "LeetCode 3719: Longest Balanced Subarray I"
summary: "LeetCode 3719 note: n is only 1500, so fix the left end and extend right, maintaining distinct odds and evens in two sets"
description: "LeetCode 3719 record from 2026-02-10"
date: 2026-02-10
tags: ["medium", "hash-table", "prefix-sum", "segment-tree", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-10
- Submissions: Accepted (first try)

## Approach

The condition is "number of distinct evens = number of distinct odds". Distinct counts cannot be subtracted like prefix sums, but `n <= 1500`, so `O(n²)` is enough:

- Fix the left end `i` and extend the right end `j`.
- Two sets hold the odds and evens seen; each new number updates one set in `O(1)`.
- When the sets have equal size, update the answer.

With a much larger `n` (version II of this problem), `O(n²)` is too slow and a more advanced data structure is needed.

## My Solution

```python
class Solution:
    def longestBalanced(self, nums: List[int]) -> int:
        n, best = len(nums), 0
        for i in range(n):
            odd, even = set(), set()
            for j in range(i, n):
                (odd if nums[j] % 2 else even).add(nums[j])
                if len(odd) == len(even):
                    best = max(best, j - i + 1)
        return best
```

## Complexity

Time `O(n²)`, space `O(n)`.

## Mistakes to Avoid

- Count **distinct** values; repeats must not count twice, hence sets.
- Update incrementally while extending; do not recompute the whole subarray.

## Interview Explanation

With `n` only 1500, I fix the left end and extend right, keeping the distinct odds and evens seen in two sets with `O(1)` updates, and record the length whenever their sizes match. Time `O(n²)`.
