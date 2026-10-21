---
title: "LeetCode 134: Gas Station"
summary: "LeetCode 134 note: if total gas is short there is no answer; otherwise scan, and whenever the tank goes negative move the start to the next station"
description: "LeetCode 134 record from 2022-11-11"
date: 2022-11-11
tags: ["medium", "array", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-11
- Submissions: Accepted ×2

## Approach

Two observations ([Greedy]({{< relref "/algorithm/Greedy" >}})):

1. If `sum(gas) < sum(cost)`, no full loop exists.
2. If starting at `s` the tank first goes negative at `i`, no station between `s` and `i` can reach `i + 1` either: arriving at it from `s` you had a non-negative tank, and starting there fresh only has less. So jump the start to `i + 1` and reset the tank.

When the total suffices, the final start is the answer (unique by the problem's guarantee).

## My Attempts

Both submissions passed on the first try with this greedy.

## Solution

```python
class Solution:
    def canCompleteCircuit(self, gas: List[int], cost: List[int]) -> int:
        if sum(gas) < sum(cost):
            return -1
        start = tank = 0
        for i in range(len(gas)):
            tank += gas[i] - cost[i]
            if tank < 0:
                start, tank = i + 1, 0
        return start
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Check the total first, or the final `start` might not complete the loop.
- On a negative tank, jump the start to `i + 1`, not `start + 1`.

## Interview Explanation

If total gas is below total cost there is no answer. Otherwise I accumulate gas minus cost, and whenever it goes negative no station since the current start can work, so I restart at the next station; the final start is the answer. Time `O(n)`.
