---
title: "LeetCode 47: Permutations II"
summary: "LeetCode 47 note: sort first, and within a level skip a value equal to the previous one when the previous one is unused"
description: "LeetCode 47 record from 2022-10-22"
date: 2022-10-22
tags: ["medium", "array", "backtracking", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-22
- Submissions: Wrong Answer → Accepted

## Approach

Permutations with duplicates need deduplication ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) Variation 4). After sorting, if `nums[i] == nums[i - 1]` and `nums[i - 1]` is **currently unused**, this level already tried that value, so skip. Equal numbers then appear only in their original order, and each permutation is generated once.

## My Attempts

Attempt 1 had the right skip condition but **forgot to sort**, so equal numbers were not adjacent and the skip never fired: `[0, 1, 0]` returned duplicate permutations. Adding `nums.sort()` passed.

## Solution

```python
class Solution:
    def permuteUnique(self, nums: List[int]) -> List[List[int]]:
        nums.sort()
        res, path = [], []
        used = [False] * len(nums)
        def dfs():
            if len(path) == len(nums):
                res.append(path[:])
                return
            for i in range(len(nums)):
                if used[i] or (i > 0 and nums[i] == nums[i - 1] and not used[i - 1]):
                    continue
                used[i] = True
                path.append(nums[i])
                dfs()
                path.pop()
                used[i] = False
        dfs()
        return res
```

## Complexity

Time `O(n · n!)`, space `O(n)` excluding output.

## Mistakes to Avoid

- Sort before deduplicating so equal values are adjacent.

## Interview Explanation

With duplicates I sort and, while backtracking, skip a number equal to the previous one when the previous is unused, since that value was already tried at this level. Time `O(n · n!)`.
