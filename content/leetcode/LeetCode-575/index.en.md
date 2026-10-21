---
title: "LeetCode 575: Distribute Candies"
summary: "LeetCode 575 note: at most n / 2 candies can be eaten and at most len(set) kinds exist; the answer is the smaller of the two"
description: "LeetCode 575 record from 2022-08-27"
date: 2022-08-27
tags: ["easy", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-27
- Submissions: Runtime Error ×2 → Wrong Answer ×2 → Accepted ×3

## Approach

Two limits: only `n / 2` candies may be eaten, so at most `n / 2` kinds; and only `len(set(candyType))` kinds exist. Both are achievable, so the answer is their `min` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})).

## My Attempts

The first two had syntax errors, and the next two used `max`, **keeping only the looser limit**: `[4, 0]` returned 2, although only one candy may be eaten. `min` passed.

## Solution

```python
class Solution:
    def distributeCandies(self, candyType: List[int]) -> int:
        return min(len(candyType) // 2, len(set(candyType)))
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Both limits apply, so take the `min`.

## Interview Explanation

The number of kinds is limited both by eating only half and by how many kinds exist, so the answer is the smaller. Time `O(n)`.
