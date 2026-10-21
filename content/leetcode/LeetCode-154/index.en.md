---
title: "LeetCode 154: Find Minimum in Rotated Sorted Array II"
summary: "LeetCode 154 note: compare with the right end as in LC 153; on equality the break could be on either side, so r -= 1, worst case O(n)"
description: "LeetCode 154 record from 2022-11-28"
date: 2022-11-28
tags: ["hard", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2022-11-28
- Submissions: Accepted (first try)

## Approach

LC 153 plus duplicates ([Binary Search]({{< relref "/algorithm/Binary-Search" >}})). When `nums[mid] == nums[r]`, as in `[3, 3, 1, 3]` and `[3, 1, 3, 3]`, the break could be on either side, but dropping `nums[r]` cannot lose the minimum (`nums[mid]` equals it), so `r -= 1`.

## My Solution

```python
class Solution:
    def findMin(self, nums: List[int]) -> int:
        l, r = 0, len(nums) - 1
        while l < r:
            mid = (l + r) // 2
            if nums[mid] > nums[r]:
                l = mid + 1
            elif nums[mid] < nums[r]:
                r = mid
            else:
                r -= 1                               # 相等時只能縮一格
        return nums[l]
```

## Complexity

Average `O(log n)`, worst case `O(n)`, space `O(1)`.

## Mistakes to Avoid

- On equality `r = mid` is wrong; the minimum may lie between `mid` and `r`.

## Interview Explanation

As before I compare the middle with the right end, but on equality the break could be anywhere; since the right end equals the middle, removing it loses nothing, so the right bound decreases by one. Worst case `O(n)`.
