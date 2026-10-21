---
title: "LeetCode 2273: Find Resultant Array After Removing Anagrams"
summary: "LeetCode 2273 note: repeatedly deleting a word that is an anagram of the previous one keeps exactly the words that are not anagrams of the last kept word; compare sorted strings"
description: "LeetCode 2273 record from 2026-01-29"
date: 2026-01-29
tags: ["easy", "hash-table", "string", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-29
- Submissions: Accepted (first try)

## Approach

After deleting `words[i]`, the next word's "previous" becomes `words[i - 1]`. The deleted word was an anagram of `words[i - 1]`, and anagrams are transitive, so comparing with either gives the same result.

So scan left to right and **compare only with the last kept word**: keep it if not an anagram. Check anagrams with sorted strings ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 5).

## My Solution

I originally went right to left, comparing neighbors with `Counter` and `pop`ping when equal. Here it builds a new list left to right:

```python
class Solution:
    def removeAnagrams(self, words: List[str]) -> List[str]:
        res = []
        for w in words:
            if not res or sorted(res[-1]) != sorted(w):
                res.append(w)
        return res
```

## Complexity

Time `O(n · L log L)` for word length `L`, space `O(n · L)`.

## Mistakes to Avoid

- `pop` inside a loop shifts indices; it is only safe right to left, and building a new list is simpler.

## Interview Explanation

After a deletion the next word compares with the one before the deleted word; anagrams are transitive, so that equals comparing with the last kept word. I scan left to right and keep a word when its sorted form differs from the last kept one. Time `O(n L log L)`.
