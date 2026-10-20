---
title: "LeetCode 3919: Minimum Cost to Move Between Indices"
summary: "LeetCode 3919 note: walk one step at a time, each costing 1 (when the next index is the closest) or the gap; jumping is never cheaper, so answer queries with prefix sums"
description: "LeetCode 3919 record from 2026-05-03"
date: 2026-05-03
tags: ["medium", "greedy", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-03
- Submissions: Accepted ×2

## Approach

`nums` is strictly increasing, so jumping from `l` to `r` costs `|nums[l] - nums[r]|`, the sum of every gap in between. Walking one step `i → i + 1` costs:

- 1 if `closest(i) == i + 1`;
- otherwise the gap `nums[i + 1] - nums[i]` (at least 1).

No step costs more than its gap, so **walking step by step is never worse than jumping**, and detours the other way only add cost. Build one prefix sum for walking right and one for walking left, answering each query in `O(1)` ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 5).

## My Solution

```python
class Solution:
    def minCost(self, nums: List[int], queries: List[List[int]]) -> List[int]:
        n = len(nums)
        closest = [0] * n
        closest[0], closest[-1] = 1, n - 2  # the ends have one neighbor
        for i in range(1, n - 1):
            closest[i] = i - 1 if nums[i] - nums[i - 1] <= nums[i + 1] - nums[i] else i + 1
        right = [0] * n                        # right[i]: cost from 0 to i
        for i in range(1, n):
            right[i] = right[i - 1] + (1 if closest[i - 1] == i else nums[i] - nums[i - 1])
        left = [0] * n                         # left[i]: cost from n-1 to i
        for i in range(n - 2, -1, -1):
            left[i] = left[i + 1] + (1 if closest[i + 1] == i else nums[i + 1] - nums[i])
        return [right[r] - right[l] if l <= r else left[r] - left[l] for l, r in queries]
```

## Complexity

Time `O(n + q)`, space `O(n)`.

## Mistakes to Avoid

- Rightward and leftward costs differ (`closest` is not symmetric), so build two prefix sums.
- On a tie `closest` picks the smaller index, so compare with `<=`.

## Interview Explanation

The array is strictly increasing, so a direct jump costs the sum of the gaps, while each single step costs at most its gap and only 1 toward the closest neighbor; walking is best. I build rightward and leftward prefix sums and answer each query by subtraction. Time `O(n + q)`.
