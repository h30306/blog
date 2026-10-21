---
title: "LeetCode 1103: Distribute Candies to People"
summary: "LeetCode 1103 note: simulate the rounds, giving i + 1 candies on the i-th turn, and hand all the rest to the current person when short"
description: "LeetCode 1103 record from 2022-10-18"
date: 2022-10-18
tags: ["easy", "math", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-10-18
- Submissions: Wrong Answer ×3 → Accepted ×3

## Approach

Simulate: turn `i` (from 0) gives person `i % n` `min(i + 1, remaining)` candies. There are only `O(√candies)` turns, since `1 + 2 + ... + k ≈ k² / 2`.

## My Attempts

The first three did `gave += 1` **before `candies -= gave`**, subtracting the next turn's amount and losing one candy each time: `candies = 3` with one person should be `[3]`; they returned `[2]`. Swapping the two lines passed.

## Solution

```python
class Solution:
    def distributeCandies(self, candies: int, num_people: int) -> List[int]:
        res = [0] * num_people
        i = 0
        while candies > 0:
            give = min(i + 1, candies)
            res[i % num_people] += give
            candies -= give
            i += 1
        return res
```

## Complexity

Time `O(√candies + n)`, space `O(n)`.

## Mistakes to Avoid

- Subtract this turn's amount before incrementing the next one; reversing the order over-subtracts.

## Interview Explanation

I simulate: turn i gives i + 1 candies to person i mod n, or everything left if that is less. There are about √candies turns.
