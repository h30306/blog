---
title: "LeetCode 2134: Minimum Swaps to Group All 1's Together II"
summary: "LeetCode 2134 note: the 1s end up in a circular window as long as their count, and the swaps needed equal the 0s in that window; slide around the circle for the minimum"
description: "LeetCode 2134 record from 2025-12-27"
date: 2025-12-27
tags: ["medium", "sliding-window", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-12-27
- Submissions: Accepted (first try)

## Approach

Let `ones` be the number of 1s. Once grouped, the 1s occupy `ones` consecutive positions on the circle.

For a given window, each 0 inside must swap with a 1 outside, one per swap, so **swaps = the number of 0s in the window**.

Slide a window of length `ones` around the circle (indices `% n`) and find the one with the fewest 0s.

## My Solution

My accepted version avoided the circle with another view: on a circle "the 1s are together" looks like one of two things on a line:

- The 1s are contiguous on the line: count 0s in length-`ones` windows.
- The 1s wrap around the ends: then the 0s are contiguous on the line, so count 1s in length-`zeros` windows.

One fixed window each, taking the minimum. Here it is tidied into a direct circular slide:

```python
class Solution:
    def minSwaps(self, nums: List[int]) -> int:
        n = len(nums)
        ones = sum(nums)
        zeros_in = ones - sum(nums[:ones])         # 0s in window [0, ones)
        best = zeros_in
        for right in range(ones, n + ones - 1):    # window starts 1..n-1
            zeros_in += (nums[right % n] == 0) - (nums[(right - ones) % n] == 0)
            best = min(best, zeros_in)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Forgetting the circle: the 1s may wrap around the ends.
- Swaps are not "distance moved": any two positions can be swapped, so one swap removes one 0.

## Interview Explanation

Once grouped, the 1s take a stretch as long as their count, and every 0 inside must swap once with a 1 outside, so the swaps equal the 0s in the window. I slide a fixed window around the circle using indices mod `n` and take the fewest 0s. Without the circle: when the 1s wrap around, the 0s are contiguous on the line, so look for the length-`zeros` window with the fewest 1s. Time `O(n)`.
