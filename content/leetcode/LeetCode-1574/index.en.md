---
title: "LeetCode 1574: Shortest Subarray to be Removed to Make Array Sorted"
summary: "LeetCode 1574 note: what remains is a non-decreasing prefix plus a non-decreasing suffix; find the longest of each, then join them with two pointers"
description: "LeetCode 1574 record from 2026-01-25"
date: 2026-01-25
tags: ["medium", "two-pointers", "binary-search", "array", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-25
- Submissions: Accepted (first try)

## Approach

After removing one contiguous subarray, what remains is **a prefix plus a suffix**; both must be non-decreasing, and so must the join.

1. Find the longest non-decreasing prefix `arr[0..left]` from the left. If it is the whole array, the answer is 0.
2. Find the longest non-decreasing suffix `arr[right..n-1]` from the right.
3. Three ways to keep elements:
   - Keep only the prefix: remove `n - left - 1`.
   - Keep only the suffix: remove `right`.
   - Keep the prefix up to `i` and the suffix from `j`, which needs `arr[i] <= arr[j]`: remove `j - i - 1`.

The third case uses same-direction pointers: `i` goes from 0 to `left`, `j` starts at `right`. If `arr[i] <= arr[j]`, update the answer and advance `i` (try a longer prefix); otherwise advance `j` (larger suffix values). Since `arr[i]` only grows, the matching `j` only moves right, and neither pointer moves back.

## My Solution

```python
class Solution:
    def findLengthOfShortestSubarray(self, arr: List[int]) -> int:
        n = len(arr)
        left = 0
        while left + 1 < n and arr[left] <= arr[left + 1]:
            left += 1
        if left == n - 1:
            return 0                               # already sorted

        right = n - 1
        while right > 0 and arr[right - 1] <= arr[right]:
            right -= 1

        ans = min(n - left - 1, right)             # keep only the prefix / only the suffix
        i, j = 0, right
        while i <= left and j < n:
            if arr[i] <= arr[j]:
                ans = min(ans, j - i - 1)          # prefix up to i, suffix from j
                i += 1
            else:
                j += 1
        return ans
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Forgetting the "only prefix" and "only suffix" cases.
- The join condition is `arr[i] <= arr[j]` (non-decreasing), not `<`.

## Interview Explanation

After removing one block, what remains is a prefix plus a suffix, so I find the longest non-decreasing prefix and suffix. I start with the better of keeping only the prefix or only the suffix, then use two same-direction pointers to join prefix index `i` with suffix index `j`: if `arr[i] <= arr[j]`, update the answer and advance `i`, otherwise advance `j`. Neither pointer moves back, so time is `O(n)`.
