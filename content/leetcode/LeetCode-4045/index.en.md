---
title: "LeetCode 4045: Count Robot Groups"
summary: "LeetCode 4045 note: merge robots already close at t = 0, then go right to left like car fleets, where anything faster than the fleet ahead eventually joins it"
description: "LeetCode 4045 record from 2026-09-17"
date: 2026-09-17
tags: ["medium", "stack", "monotonic-stack", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-09-17
- Submissions: Wrong Answer ×3 → Accepted

## Approach

All robots move right and merge once they are within `distance`; a merged group takes the position and speed of its **rightmost** robot.

Two phases:

**1. Merge robots already close at `t = 0`.** Scan left to right; if a robot is within `distance` of the previous group's rightmost robot, it joins, and the group takes this robot's position and speed.

**2. Later merges work like LC 853 Car Fleet.** Looking right to left, each group can only catch the "fleet" directly ahead:

- **Faster than the fleet ahead**: the gap keeps shrinking, so it eventually comes within `distance` and merges. The merged group keeps the fleet's speed, so the fleet speed does not change.
- **Slower or equal**: it never catches up and forms a new fleet.

So keep a stack of fleet speeds going right to left: skip (merge) anything faster than the top, otherwise push. The stack size is the answer.

## My Attempts

1. **First version**: the `t = 0` merge ran right to left and kept the left robot, the opposite of the rule (the group takes the rightmost robot's state). After that it compared only adjacent groups' speeds.
2. **Second and third versions**: flipped the comparison and made the `t = 0` merge go left to right, but still **compared only adjacent groups**.

The problem: a group catches the whole fleet ahead, and that fleet moves at the speed of its front, not at the adjacent group's original speed. Comparing only neighbors mishandles catching a group that has already been absorbed. Keeping fleet speeds on a stack passed.

## Solution

```python
class Solution:
    def countGroups(self, position: List[int], speed: List[int], distance: int) -> int:
        groups = []                                  # (rightmost position, speed)
        for p, v in zip(position, speed):
            if groups and groups[-1][0] + distance >= p:
                groups[-1] = (p, v)                  # merged at t = 0; take this robot's state
            else:
                groups.append((p, v))

        fleets = []                                  # fleet speeds from right to left
        for _, v in reversed(groups):
            if fleets and v > fleets[-1]:
                continue                             # it will catch the fleet ahead
            fleets.append(v)
        return len(fleets)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Keeping the left robot's state in the `t = 0` merge: use the rightmost robot.
- Comparing only adjacent groups: compare against the speed of the whole fleet ahead.
- Treating equal speed as catching up: with equal speeds the gap never changes, so they never merge.

## Interview Explanation

First I merge, left to right, robots already within `distance` at `t = 0`, with each group taking its rightmost robot's position and speed. Then, like Car Fleet, I go right to left: a group faster than the fleet ahead eventually closes within `distance` and joins without changing the fleet's speed, and anything not faster starts a new fleet. A stack of fleet speeds gives the count in `O(n)`.
