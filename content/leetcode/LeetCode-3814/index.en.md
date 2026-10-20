---
title: "LeetCode 3814: Maximum Capacity Within Budget"
summary: "LeetCode 3814 note: sort by cost with a prefix maximum of capacity, and bisect the most expensive partner for each machine"
description: "LeetCode 3814 record from 2026-01-18"
date: 2026-01-18
tags: ["medium", "binary-search", "sorting", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-18
- Submissions: Time Limit Exceeded → Accepted

## Approach

Pick at most two distinct machines whose total cost is **strictly less** than `budget`, maximizing total capacity.

One machine is easy: the largest capacity among machines with cost `< budget`.

For two machines, sort by cost and fix the more expensive one, `i`. Its partner comes from before `i` with cost `< budget - cost[i]`, and should have the largest capacity:

1. Sort by cost and build a prefix maximum of capacity: `best[j] = max(cap[0..j])`.
2. For each `i`, `bisect_left(costs, budget - cost[i])` gives the first index `idx` that is too expensive; valid partners are `[0, min(idx, i) - 1]`.
3. The candidate is `cap[i] + best[min(idx, i) - 1]`.

Restricting partners to before `i` keeps the two machines distinct and counts each pair once.

## My Attempt: a double loop

```python
for i in range(n):
    for j in range(i + 1, n):
        if first_cost + second_cost >= budget:
            break
        max_cap = max(max_cap, first_cap + second_cap)
```

After sorting, the inner loop can `break`, but when costs are all low it runs nearly to the end: worst case `O(n^2)`, TLE.

I also tried two pointers with a prefix maximum (left in comments, never submitted) before the bisect version passed.

## Solution

```python
import bisect

class Solution:
    def maxCapacity(self, costs: List[int], capacity: List[int], budget: int) -> int:
        machines = sorted(zip(costs, capacity))
        sorted_costs = [c for c, _ in machines]

        best_prefix = []
        cur = 0
        for _, cap in machines:
            cur = max(cur, cap)
            best_prefix.append(cur)

        ans = 0
        for i, (cost, cap) in enumerate(machines):
            if cost >= budget:
                break
            ans = max(ans, cap)                                      # one machine
            j = min(bisect.bisect_left(sorted_costs, budget - cost), i) - 1
            if j >= 0:
                ans = max(ans, cap + best_prefix[j])                 # two machines
        return ans
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Treating "strictly less" as `<=`: use `bisect_left(costs, budget - cost)`, which finds the first cost `>= budget - cost`.
- Not restricting partners to before `i`: the same machine could be picked twice.
- Forgetting the single-machine case.

## Interview Explanation

I sort machines by cost and build a prefix maximum of capacity. For one machine, take the largest capacity under budget; for two, fix the more expensive machine `i`, use `bisect_left` to find the partners costing less than `budget - cost[i]`, restrict them to before `i` to avoid repeats, and the prefix maximum gives the best partner. Time `O(n log n)`.
