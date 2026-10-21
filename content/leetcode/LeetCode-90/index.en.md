---
title: "LeetCode 90: Subsets II"
summary: "LeetCode 90 note: sort first; for a number equal to the previous one, extend only the subsets created in the previous step"
description: "LeetCode 90 record from 2022-10-26"
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
- Submissions: Accepted ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error ×3 → Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer ×2 → Accepted

## Approach

Duplicates require deduplication ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) Variation 4). Sort so equal values are adjacent. Iteratively, a new value extends every subset, but a value equal to the previous one extends **only the subsets created in the previous step** (those already contain the previous copy); anything else repeats an existing subset. With backtracking, skip equal choices within the same level: `if i > start and nums[i] == nums[i - 1]: continue`.

## My Attempts

This took 15 submissions:

- The first acceptance deduplicated with `if c + [num] not in combs`, scanning every subset on each check, which is slow.
- Then I switched to "a repeated value extends only the subsets from the previous step", and several times **forgot to sort**, so equal values were not adjacent: `[1, 2, 1]` returned `[1]` twice and `[1, 2]` twice.
- The rest misused the variable recording how many subsets the previous step created or inverted the condition (updating only when `nums[i] == nums[i - 1]`); sorting and using `!=` made it pass reliably.

## Solution

```python
class Solution:
    def subsetsWithDup(self, nums: List[int]) -> List[List[int]]:
        nums.sort()
        res = []
        def dfs(start, path):
            res.append(path[:])
            for i in range(start, len(nums)):
                if i > start and nums[i] == nums[i - 1]:
                    continue
                path.append(nums[i])
                dfs(i + 1, path)
                path.pop()
        dfs(0, [])
        return res
```

## Complexity

Time `O(n · 2^n)`, space `O(n)` excluding output.

## Mistakes to Avoid

- Sort before deduplicating.
- The skip condition is `i > start` (same level), not `i > 0`, or subsets like `[1, 1]` are lost.
- Deduplicating with `not in res` costs `O(2^n)` per check and is slow.

## Interview Explanation

I sort so equal values are adjacent and, while backtracking, skip a choice equal to the previous one at the same level, so each subset appears once. Time `O(n · 2^n)`.
