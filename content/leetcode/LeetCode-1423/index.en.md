---
title: "LeetCode 1423: Maximum Points You Can Obtain from Cards"
summary: "LeetCode 1423 note: taking k cards from the ends leaves a contiguous middle of n - k cards; find its minimum sum with a fixed-size window"
description: "LeetCode 1423 record from 2025-12-24"
date: 2025-12-24
tags: ["medium", "sliding-window", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-12-24
- Submissions: Accepted (first try)

## Approach

Cards come only from the front or back, so after taking `k`, **what remains is always a contiguous middle of `n - k` cards**.

So the maximum taken = total − the minimum sum of a contiguous subarray of length `n - k`, found with a fixed-size sliding window.

## My Solution

```python
class Solution:
    def maxScore(self, cardPoints: List[int], k: int) -> int:
        n = len(cardPoints)
        size = n - k                               # cards left behind
        window = sum(cardPoints[:size])
        smallest = window
        for right in range(size, n):
            window += cardPoints[right] - cardPoints[right - size]
            smallest = min(smallest, window)
        return sum(cardPoints) - smallest
```

With `k == n`, `size = 0`, the window stays 0, and the answer is the total.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Greedily taking the larger end each time: earlier picks change what is available later, so it is not always optimal.

## Interview Explanation

Taking `k` cards from the ends leaves a contiguous middle of `n - k` cards. So I find the minimum sum of a length-`n - k` subarray with a fixed sliding window, and the answer is the total minus that. Time `O(n)`.
