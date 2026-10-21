---
title: "LeetCode 448: Find All Numbers Disappeared in an Array"
summary: "LeetCode 448 note: use the array itself as the hash table, marking nums[x - 1] negative for each x; positions still positive are the missing numbers"
description: "LeetCode 448 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Accepted ×2

## Approach

Values lie in `1..n`, so the array can serve as its own hash table ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 2): for each `x`, make `nums[abs(x) - 1]` negative to mark `x` as seen, using `abs` since the cell may already be negative. Afterward every `i` with `nums[i] > 0` means `i + 1` is missing, with `O(1)` extra space.

## My Attempts

Both submissions passed on the first try, the first already using this negative-marking approach.

## Solution

```python
class Solution:
    def findDisappearedNumbers(self, nums: List[int]) -> List[int]:
        for x in nums:
            i = abs(x) - 1
            nums[i] = -abs(nums[i])
        return [i + 1 for i, x in enumerate(nums) if x > 0]
```

## Complexity

Time `O(n)`, space `O(1)` excluding output.

## Mistakes to Avoid

- Take `abs` when reading; the cell may already be negative.
- Mark with `-abs(...)` so a value seen twice does not flip back to positive.

## Interview Explanation

With values in 1 to n, I use the array as its own hash table, negating cell x - 1 for each x; positions still positive, plus one, are the missing numbers. Extra space `O(1)`.
