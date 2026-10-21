---
title: "LeetCode 771: Jewels and Stones"
summary: "LeetCode 771 note: put jewels in a set and count how many stones are in it"
description: "LeetCode 771 record from 2022-09-06"
date: 2022-09-06
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-06
- Submissions: Accepted → Runtime Error ×2 → Accepted

## Approach

Turn `jewels` into a set and check each stone in `O(1)` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). Case matters.

## My Attempts

The two REs used the old parameter names `J` and `S` (NameError); renaming to `jewels` and `stones` fixed it.

## Solution

```python
class Solution:
    def numJewelsInStones(self, jewels: str, stones: str) -> int:
        jewel_set = set(jewels)
        return sum(s in jewel_set for s in stones)
```

## Complexity

Time `O(n + m)`, space `O(m)`.

## Mistakes to Avoid

- Uppercase and lowercase are different stones.

## Interview Explanation

I put jewels in a set and count the stones that appear in it, in `O(n + m)`.
