---
title: "LeetCode 3833: Count Dominant Indices"
summary: "LeetCode 3833 note: keep a suffix sum from the right and compare nums[i] × count > sum on the right, with no floats and without counting itself"
description: "LeetCode 3833 record from 2026-02-08"
date: 2026-02-08
tags: ["easy", "array", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-02-08
- Submissions: Wrong Answer → Accepted

## Approach

`nums[i]` must exceed the average of the elements to its **right** (excluding itself). Scan right to left keeping their sum and count ([Array]({{< relref "/algorithm/Array" >}}) Template 3). Compare averages by multiplying: `nums[i] > s / c` is `nums[i] * c > s`, avoiding floats and integer division. The last element has nothing to its right and does not count.

## My Attempts

Attempt 1 had two problems: the average used `//` integer division, and position `i`'s average **included itself**. For `[4, 3, 5, 4]` only `5 > 4` holds, so the answer is 1; it returned 2. Switching to `/` and comparing with the suffix average from `i + 1` passed.

## Solution

```python
class Solution:
    def dominantIndices(self, nums: List[int]) -> int:
        n, suffix, res = len(nums), 0, 0
        for i in range(n - 1, -1, -1):
            cnt = n - 1 - i
            if cnt and nums[i] * cnt > suffix:
                res += 1
            suffix += nums[i]
        return res
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The average excludes the element itself.
- Integer division rounds the average down and breaks the comparison; multiplying is safest.

## Interview Explanation

Scanning right to left with the sum of the right side, I check whether the element times the count on its right exceeds that sum, which is the same as beating the average without floats. Time `O(n)`.
