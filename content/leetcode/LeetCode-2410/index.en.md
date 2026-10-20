---
title: "LeetCode 2410: Maximum Matching of Players With Trainers"
summary: "LeetCode 2410 note: sort both sides, then same-direction pointers match the weakest player with the smallest trainer that is good enough"
description: "LeetCode 2410 record from 2025-07-13"
date: 2025-07-13
tags: ["medium", "two-pointers", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-13
- Submissions: Accepted (first try)

## Approach

Greedy: **the weakest player should take the smallest trainer that is just enough.** Saving larger trainers for stronger players never reduces the number of matches.

Sort `players` and `trainers` and move two pointers in the same direction:

- `trainers[j] < players[i]`: this trainer cannot handle even the weakest remaining player, and later players are stronger, so skip the trainer.
- Otherwise match them and advance both pointers.

The number of matched players is the answer.

## My Solution

```python
class Solution:
    def matchPlayersAndTrainers(self, players: List[int], trainers: List[int]) -> int:
        players.sort()
        trainers.sort()
        i = j = 0
        while i < len(players) and j < len(trainers):
            if trainers[j] >= players[i]:
                i += 1                     # matched
            j += 1                         # trainer used or skipped
        return i
```

## Complexity

Time `O(n log n + m log m)` for sorting, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Matching a player with the largest trainer: it wastes a trainer that could serve a stronger player.

## Interview Explanation

I sort both arrays and give the weakest player the smallest trainer that is strong enough. A trainer that is too weak is skipped, since later players are only stronger; otherwise they match and both pointers advance. Each element is visited once, so sorting dominates at `O(n log n)`.
