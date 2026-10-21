---
title: "LeetCode 78: Subsets"
summary: "LeetCode 78 note: each element is either taken or not; iteratively, each new number copies every existing subset with the number appended"
description: "LeetCode 78 record from 2022-10-26"
date: 2022-10-26
tags: ["medium", "array", "backtracking", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-26
- Submissions: Wrong Answer ×3 → Accepted → Memory Limit Exceeded → Accepted ×3

## Approach

Subsets come from taking or skipping each element ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) Variation 1), `2^n` in all. Iteratively, start from `[[]]` and for each number `x` copy every current subset with `x` appended. With backtracking, `dfs(start, path)` records `path` and then picks the next element from `start` on.

## My Attempts

The first three used the wrong variable, `c + [nums]`, **appending the whole array** instead of the current number: `[5]` returned `[[], [[5]]]`. Using `num` passed. Another approach on 2022-10-30 hit Memory Limit Exceeded.

## Solution

```python
class Solution:
    def subsets(self, nums: List[int]) -> List[List[int]]:
        res = [[]]
        for x in nums:
            res += [s + [x] for s in res]
        return res
```

## Complexity

Time `O(n · 2^n)`, space `O(n · 2^n)` (output).

## Mistakes to Avoid

- Append the current number `x`, not the whole `nums`.

## Interview Explanation

Each element is taken or skipped, so starting from the empty set I copy every existing subset with each new number appended, giving 2^n subsets in `O(n · 2^n)`.
