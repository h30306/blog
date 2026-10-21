---
title: "LeetCode 501: Find Mode in Binary Search Tree"
summary: "LeetCode 501 note: a BST's in-order is sorted, so equal values are contiguous; count the current run during in-order, resetting the answer on a new maximum and appending on a tie"
description: "LeetCode 501 record from 2022-08-25"
date: 2022-08-25
tags: ["easy", "tree", "depth-first-search", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-25
- Submissions: Accepted ×2 → Runtime Error → Accepted ×3 → Runtime Error → Accepted → Runtime Error → Accepted ×7 → Runtime Error ×10 → Wrong Answer ×3 → Accepted ×2

## Approach

This BST allows duplicates (left `<=` root `<=` right), so its in-order traversal is sorted and **equal values are contiguous** ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). Track the previous value and the current run length during in-order:

- Same as the previous: extend the run; otherwise reset it to 1.
- A run above the maximum: reset the answer to just this value.
- A run equal to the maximum: append this value.

No hash map is needed beyond the answer and the recursion.

## My Attempts

This took 31 submissions. The first dozen were assorted errors writing "in-order + counting" (undefined variables, reading `None`, recursion without a base case); a version that counted with `Counter` and then picked the maximum passed. Practicing the hash-map-free version afterward, I got the initialization wrong a few times, e.g. a single node `[4]` returned `[0]`.

## Solution

```python
class Solution:
    def findMode(self, root: Optional[TreeNode]) -> List[int]:
        res, best, run, prev = [], 0, 0, None
        stack, cur = [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            run = run + 1 if cur.val == prev else 1
            prev = cur.val
            if run > best:
                best, res = run, [cur.val]
            elif run == best:
                res.append(cur.val)
            cur = cur.right
        return res
```

## Complexity

Time `O(n)`, space `O(h)` besides the output.

## Mistakes to Avoid

- Start the previous value at `None`; with 0, a first node of value 0 would count as a repeat.

## Interview Explanation

The in-order of a BST is sorted with equal values together, so I count the current run during the in-order walk, resetting the answer on a longer run and appending on a tie. One pass, time `O(n)`.
