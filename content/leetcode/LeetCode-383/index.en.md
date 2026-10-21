---
title: "LeetCode 383: Ransom Note"
summary: "LeetCode 383 note: every character's demand in ransomNote must not exceed its supply in magazine; an empty Counter difference means yes"
description: "LeetCode 383 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "hash-table", "string", "counting"]
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
- Submissions: Wrong Answer → Accepted ×3

## Approach

Count `magazine`'s characters ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1) and subtract what `ransomNote` needs; any shortfall fails. Python's `Counter(a) - Counter(b)` keeps only positive counts, so an empty result means every character suffices.

## My Attempts

Attempt 1 returned `bool(Counter(ransomNote) - Counter(magazine))`, **the exact opposite**: a non-empty difference means a shortfall, so `"a"`, `"c"` returned `True`. Using `not` passed.

## Solution

```python
class Solution:
    def canConstruct(self, ransomNote: str, magazine: str) -> bool:
        return not (Counter(ransomNote) - Counter(magazine))
```

## Complexity

Time `O(n + m)`, space `O(k)`.

## Mistakes to Avoid

- A non-empty difference means a **shortfall**, so return `not ...`, not `bool(...)`.

## Interview Explanation

I subtract magazine's counts from ransomNote's; Counter subtraction keeps only positives, so an empty result means everything is covered. Time `O(n + m)`.
