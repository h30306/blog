---
title: "LeetCode 3917: Count Indices With Opposite Parity"
summary: "LeetCode 3917 note: scan right to left counting odds and evens seen; each position's answer is the count of opposite parity to its right"
description: "LeetCode 3917 record from 2026-05-03"
date: 2026-05-03
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-05-03
- Submissions: Accepted (first try)

## Approach

For each `i`, count the `j` to its right with parity opposite to `nums[i]`. Scan right to left keeping "how many evens and odds are to the right" ([Array]({{< relref "/algorithm/Array" >}}) Template 3); each position reads the opposite count directly, then adds itself.

## My Solution

```python
class Solution:
    def countOppositeParity(self, nums: List[int]) -> List[int]:
        seen = [0, 0]                          # 右邊的偶數、奇數個數
        res = [0] * len(nums)
        for i in range(len(nums) - 1, -1, -1):
            p = nums[i] % 2
            res[i] = seen[1 - p]
            seen[p] += 1
        return res
```

I originally rescanned to the right for every `i`, `O(n²)`; the small range let it pass.

## Complexity

Time `O(n)`, space `O(n)` for the output.

## Mistakes to Avoid

- The count is of elements to the **right**, so scan right to left, reading the answer before adding the element itself.

## Interview Explanation

Scanning right to left, I keep how many evens and odds are to the right; each position's answer is the opposite-parity count, then it adds itself. Time `O(n)`.
