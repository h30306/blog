---
title: "LeetCode 3834: Merge Adjacent Equal Elements"
summary: "LeetCode 3834 note: a stack simulation where a new element merges with an equal top, possibly again with the new top"
description: "LeetCode 3834 record from 2026-02-08"
date: 2026-02-08
tags: ["medium", "stack", "simulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-08
- Submissions: Accepted (first try)

## Approach

The rule: repeatedly take the **leftmost** pair of equal adjacent elements and replace it with their sum, until no adjacent pair is equal.

Following the rule literally means searching from the start each time, `O(n^2)`.

Process left to right with a stack holding "the finished part with no equal neighbors". When a new element equals the top, merge them into double; the merged value may equal the new top, so keep merging with a `while`.

Why this matches "merge the leftmost pair each time": the stack never contains equal neighbors, so the only possible equal pair is the new element and the one to its left, which is the leftmost pair.

## My Solution

```python
class Solution:
    def mergeAdjacent(self, nums: List[int]) -> List[int]:
        stack = []
        for x in nums:
            while stack and stack[-1] == x:
                x += stack.pop()
            stack.append(x)
        return stack
```

My original code pushed first and then checked `while len(stack) > 1 and stack[-1] == stack[-2]`, which is equivalent. Merging before pushing saves a pop and a push.

## Complexity

Time `O(n)`: each merge removes one element, so there are at most `n` merges. Space `O(n)`.

## Mistakes to Avoid

- Stopping after one merge: the merged value may equal the previous element, so use `while`.
- Following the rule literally and searching from the start each time: `O(n^2)`.

## Interview Explanation

I process the array left to right with a stack that never holds equal neighbors. If a new element equals the top, I merge them into double, and keep merging while it equals the new top, then push it. Since the stack has no equal neighbors, each merge is the leftmost pair, matching the rule. Every merge removes an element, so the total is `O(n)`.
