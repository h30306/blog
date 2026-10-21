---
title: "LeetCode 1160: Find Words That Can Be Formed by Characters"
summary: "LeetCode 1160 note: a word is formable when none of its character counts exceeds chars'; sum the lengths of such words"
description: "LeetCode 1160 record from 2022-10-18"
date: 2022-10-18
tags: ["easy", "array", "hash-table", "string", "counting"]
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
- Submissions: Accepted ×3

## Approach

Count `chars` once ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1) and each word; an empty `Counter(w) - C` means every character suffices (as in LC 383), so add the word's length.

## My Solution

```python
class Solution:
    def countCharacters(self, words: List[str], chars: str) -> int:
        have = Counter(chars)
        return sum(len(w) for w in words if not (Counter(w) - have))
```

## Complexity

Time `O(total characters)`, space `O(k)`.

## Mistakes to Avoid

- Count `chars` once outside the loop; each word may use all of `chars` independently.

## Interview Explanation

I count chars once, then check that each word's needs do not exceed it, adding the lengths of formable words. Time is linear in the total length.
