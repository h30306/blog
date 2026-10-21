---
title: "LeetCode 500: Keyboard Row"
summary: "LeetCode 500 note: make a set for each keyboard row and keep words whose lowercase character set is a subset of one row"
description: "LeetCode 500 record from 2022-08-25"
date: 2022-08-25
tags: ["easy", "array", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-25
- Submissions: Accepted (first try)

## Approach

Make each keyboard row a set ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})); a word whose lowercase character set is a **subset** (`<=`) of one row can be typed on that row. Case does not matter.

## My Solution

```python
class Solution:
    def findWords(self, words: List[str]) -> List[str]:
        rows = [set("qwertyuiop"), set("asdfghjkl"), set("zxcvbnm")]
        return [w for w in words if any(set(w.lower()) <= r for r in rows)]
```

## Complexity

Time `O(total characters)`, space `O(1)`.

## Mistakes to Avoid

- Lowercase before comparing.
- Keep the original case and order in the output.

## Interview Explanation

I make each keyboard row a set and keep words whose lowercase characters form a subset of one row, in time linear in the total length.
