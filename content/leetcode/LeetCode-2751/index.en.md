---
title: "LeetCode 2751: Robot Collisions"
summary: "LeetCode 2751 note: sort by position, push right-moving robots, and let each left-moving robot collide until one side is gone"
description: "LeetCode 2751 record from 2026-10-13"
date: 2026-10-13
tags: ["hard", "stack", "simulation", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-13
- Submissions: Accepted (first try)

## Approach

Only a right-moving robot on the left and a left-moving robot on the right can collide. So **sort by position** and scan left to right:

- A right-moving robot: push it and let it wait for a left-moving robot from the right.
- A left-moving robot: collide with the right-moving robot on top of the stack:
    - The top has less health: the top is removed, this robot loses 1, and it keeps colliding with the new top.
    - Equal health: both are removed.
    - The top has more: this robot is removed and the top loses 1.
- If the top moves left (or the stack is empty), this left-moving robot will never hit anything.

The robots left on the stack survive; output their health in the original order.

It is the same model as LC 735 Asteroid Collision, except the winner loses 1 health here.

## My Solution

```python
class Solution:
    def survivedRobotsHealths(self, positions: List[int], healths: List[int], directions: str) -> List[int]:
        order = sorted(range(len(positions)), key=lambda i: positions[i])
        health = healths[:]
        stack = []                                     # indices
        for i in order:
            if directions[i] == "R":
                stack.append(i)
                continue
            while stack and directions[stack[-1]] == "R" and health[i] > 0:
                j = stack[-1]
                if health[j] < health[i]:
                    stack.pop()
                    health[j] = 0
                    health[i] -= 1
                elif health[j] == health[i]:
                    stack.pop()
                    health[j] = health[i] = 0
                else:
                    health[j] -= 1
                    health[i] = 0
            if health[i] > 0:
                stack.append(i)
        return [h for h in health if h > 0]
```

My original code put `(position, health, direction, original index)` tuples on the stack and sorted by original index at the end. Storing only indices with health in a separate array lets the output be filtered **in the original order** directly, without another sort.

## Complexity

Time `O(n log n)`, dominated by sorting; each robot is pushed and popped at most once. Space `O(n)`.

## Mistakes to Avoid

- Not sorting by position first: positions are not guaranteed to be sorted.
- Stopping after one winning collision: a left-moving robot keeps colliding until it is gone or no right-moving robot remains ahead.
- Outputting in position order instead of the original order.

## Interview Explanation

Only a right-moving robot on the left can meet a left-moving robot on the right, so I sort by position, scan left to right, and push right-moving robots. Each left-moving robot keeps colliding with the right-moving robot on top: the weaker one is removed and the winner loses 1, ties remove both, until it is gone or nothing right-moving remains ahead. Finally I output the surviving health values in the original order. Sorting is `O(n log n)`, and all collisions together are `O(n)`.
