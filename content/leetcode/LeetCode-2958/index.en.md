---
title: "LeetCode 2958: Length of Longest Subarray With at Most K Frequency"
summary: "LeetCode 2958 note: a longest-window slide that shrinks the left whenever the newly added number appears more than k times"
description: "LeetCode 2958 record from 2026-01-10"
date: 2026-01-10
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-10
- Submissions: Accepted (first try)

## Approach

The same template as [LeetCode 3090]({{< relref "/leetcode/LeetCode-3090" >}}), with the limit `k` instead of 2 and integers instead of characters.

After adding `x` on the right, only `x` can exceed `k`, so shrink the left until it is back to `k`.

## My Solution

```python
class Solution:
    def maxSubarrayLength(self, nums: List[int], k: int) -> int:
        cnt = Counter()
        left = best = 0
        for right, x in enumerate(nums):
            cnt[x] += 1
            while cnt[x] > k:
                cnt[nums[left]] -= 1
                left += 1
            best = max(best, right - left + 1)
        return best
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Writing the shrink condition on the left element: check the newly added `x`.

## Interview Explanation

A longest-window slide where each number appears at most `k` times. After adding `x` on the right only `x` can exceed, so I shrink the left until `x` is back to `k` and track the longest length. Time `O(n)`.
