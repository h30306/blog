---
title: "LeetCode 108: Convert Sorted Array to Binary Search Tree"
summary: "LeetCode 108 note: the middle element becomes the root and each half recurses; the halves differ by at most one, so the tree is balanced"
description: "LeetCode 108 record from 2022-08-16"
date: 2022-08-16
tags: ["easy", "array", "divide-and-conquer", "tree", "binary-search-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-16
- Submissions: Runtime Error ×5 → Accepted → Runtime Error ×2 → Accepted → Runtime Error → Accepted ×2

## Approach

The array is sorted, so the middle element has smaller values on its left and larger on its right, making it the root ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). Recurse on both halves; splitting at the middle every time keeps their sizes within one, so the height is balanced. Pass index ranges to avoid copying slices.

## My Attempts

Several early versions sliced the right half as `nums[mid:]`, **including the middle element**, so a single element kept producing the same slice and recursed forever (RecursionError); others read attributes of `None`.

## Solution

```python
class Solution:
    def sortedArrayToBST(self, nums: List[int]) -> Optional[TreeNode]:
        def build(lo, hi):
            if lo > hi:
                return None
            mid = (lo + hi) // 2
            return TreeNode(nums[mid], build(lo, mid - 1), build(mid + 1, hi))
        return build(0, len(nums) - 1)
```

## Complexity

Time `O(n)`, space `O(log n)`.

## Mistakes to Avoid

- Exclude `mid` from the recursive ranges, or the recursion never ends.

## Interview Explanation

The sorted array's middle element is the root and each half builds a subtree; the sizes differ by at most one, so it is balanced. With index ranges, time `O(n)`.
