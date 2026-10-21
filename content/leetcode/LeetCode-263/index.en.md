---
title: "LeetCode 263: Ugly Number"
summary: "LeetCode 263 note: only positive numbers can be ugly; divide out every factor 2, 3 and 5 and check whether 1 remains"
description: "LeetCode 263 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Accepted (first try)

## Approach

`n <= 0` never qualifies. Otherwise divide out 2, 3 and 5 as long as possible; if 1 remains there are no other prime factors ([Number Theory]({{< relref "/algorithm/Number-Theory" >}})).

## My Solution

```python
class Solution:
    def isUgly(self, n: int) -> bool:
        if n <= 0:
            return False
        for p in (2, 3, 5):
            while n % p == 0:
                n //= p
        return n == 1
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- Rule out `0` and negatives first; `0 % p == 0` would loop forever.

## Interview Explanation

I rule out non-positive numbers, divide out 2, 3 and 5, and check that 1 remains. Time `O(log n)`.
