---
title: "LeetCode 953: Verifying an Alien Dictionary"
summary: "LeetCode 953 note: map letters to their alien index and compare each adjacent pair at the first differing character; with no difference, the shorter must come first"
description: "LeetCode 953 record from 2022-09-26"
date: 2022-09-26
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
First Attempt: 2022-09-26
- Submissions: Wrong Answer → Runtime Error ×4 → Wrong Answer → Runtime Error ×3 → Accepted ×3

## Approach

Build `rank[c]`, each letter's position in `order` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). Lexicographic order only needs **adjacent** pairs: the first differing character decides by `rank`, and if one word is a prefix of the other, the shorter must come first. In Python, comparing lists of ranks does exactly this, since list comparison is lexicographic.

## My Attempts

This took 12 submissions:

- Attempt 1 compared column by column with `zip(*words)`, **requiring every column to be non-decreasing**, although only the first differing character matters; `zip` also truncates, so prefixes went unchecked: `["ll", "l"]` returned `True`.
- Switching to adjacent-pair comparison, the outer loop first ran to the last word and `words[i + 1]` went out of range (IndexError).
- One version used `range(len(words[i]) - 1)` and **skipped the last character**: `["r", "p"]` compared nothing and returned `True`.
- After that, a shorter next word still made `words[i + 1][j]` raise IndexError. Returning `False` once the next word runs out passed.

## Solution

```python
class Solution:
    def isAlienSorted(self, words: List[str], order: str) -> bool:
        rank = {c: i for i, c in enumerate(order)}
        keys = [[rank[c] for c in w] for w in words]
        return all(keys[i] <= keys[i + 1] for i in range(len(keys) - 1))
```

## Complexity

Time `O(total characters)`, space `O(total characters)`.

## Mistakes to Avoid

- Only the first differing character matters.
- The prefix case: `["ll", "l"]` is not sorted.
- Check the next word's length before reading its characters.

## Interview Explanation

I map letters to their alien positions, convert words into lists of positions, and check each adjacent pair is non-decreasing; list comparison is lexicographic and handles prefixes. Time is linear in the total length.
