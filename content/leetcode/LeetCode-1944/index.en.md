---
title: "LeetCode 1944: Number of Visible People in a Queue"
summary: "LeetCode 1944 note: a decreasing monotonic stack from right to left; everyone popped is visible, and so is the person left on top"
description: "LeetCode 1944 record from 2026-09-04"
date: 2026-09-04
tags: ["hard", "stack", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-04
- Submissions: Accepted → Accepted (retyped the next day)

## Approach

Person `i` sees person `j` to the right when everyone between them is shorter than both.

Process right to left, keeping the stack **increasing from top to bottom** (taller further down). For person `i`:

1. Everyone on top who is shorter is visible to them, and is now hidden behind them for anyone further left, so pop them and count each.
2. If the stack is still non-empty, that taller person is visible too, but nobody behind them is, so count one more.
3. Push person `i`.

## My Solution

```python
class Solution:
    def canSeePersonsCount(self, heights: List[int]) -> List[int]:
        n = len(heights)
        res = [0] * n
        stack = []
        for i in range(n - 1, -1, -1):
            count = 0
            while stack and stack[-1] < heights[i]:
                stack.pop()
                count += 1
            if stack:
                count += 1
            res[i] = count
            stack.append(heights[i])
        return res
```

Heights are guaranteed distinct, so equal heights need no handling.

## Complexity

Time `O(n)`: each person is pushed and popped at most once. Space `O(n)`.

## Mistakes to Avoid

- Forgetting to count the taller person who blocks the view after popping.
- Going left to right: the right side is unknown at that point, so go right to left.
- Scanning right from every person: `O(n^2)`.

## Interview Explanation

I keep a monotonic stack from right to left. For each person, everyone on top who is shorter is visible and will be hidden behind them from now on, so I pop and count them; if someone remains, that taller person is visible too, so I add 1. Then I push the current person. Each person enters and leaves once, so time is `O(n)`.
