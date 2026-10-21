---
title: "LeetCode 2094: Finding 3-Digit Even Numbers"
summary: "LeetCode 2094 note: enumerate the even numbers 100 to 998 instead and check that each digit needed is available; Counter subtraction keeps only positives"
description: "LeetCode 2094 record from 2025-05-12"
date: 2025-05-12
tags: ["easy", "hash-table", "enumeration", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-05-12
- Submissions: Wrong Answer → Accepted

## Approach

There are only 450 three-digit even numbers (100 to 998), so **enumerating answers** is simpler ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1):

- Count the digits available: `have = Counter(digits)`.
- For each candidate `x`, count the digits it needs: `need = Counter(str(x))`.
- `need - have` keeps only "needed more than available"; empty means enough.

Enumerating in increasing order gives a sorted result with no duplicates.

## My Attempts

I originally nested three loops over the `counter` keys to build the digits, excluding cases with too few copies. Attempt 1's condition `(j == k and counter[i] < 2)` **used the wrong variable**; it should check `counter[j]`. For `[3, 2, 2]` the answer is `[232, 322]`; `322` ends in two 2s, and checking the count of 3 dropped it. Changing to `counter[j]` passed.

## Solution

```python
class Solution:
    def findEvenNumbers(self, digits: List[int]) -> List[int]:
        have = Counter(map(str, digits))
        return [x for x in range(100, 1000, 2) if not Counter(str(x)) - have]
```

## Complexity

Time `O(450 × 3 + n)`, i.e. `O(n)`, space `O(1)` (at most 10 digits).

## Mistakes to Avoid

- With three nested loops, check the repeat count with the matching position's variable.
- Keep `Counter` key types consistent: strings on both sides.

## Interview Explanation

There are only 450 three-digit even numbers, so I enumerate 100 to 998 by twos, count the digits each one needs, and compare with the digits on hand; an empty `Counter` difference means enough. Enumerating in order yields a sorted, duplicate-free result.
