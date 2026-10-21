---
title: "LeetCode 804: Unique Morse Code Words"
summary: "LeetCode 804 note: translate each word into a Morse string and count the distinct results with a set"
description: "LeetCode 804 record from 2022-09-07"
date: 2022-09-07
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
First Attempt: 2022-09-07
- Submissions: Accepted (first try)

## Approach

Translate each letter by the table, join into one string, and add it to a set; the answer is the set's size ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). Letter `c` maps to `table[ord(c) - ord("a")]`.

## My Solution

```python
class Solution:
    def uniqueMorseRepresentations(self, words: List[str]) -> int:
        table = [".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---",
                 "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-",
                 "..-", "...-", ".--", "-..-", "-.--", "--.."]
        return len({"".join(table[ord(c) - ord("a")] for c in w) for w in words})
```

## Complexity

Time `O(total characters)`, space `O(total characters)`.

## Mistakes to Avoid

- Different words may share a Morse code; that is exactly what is being counted.

## Interview Explanation

I translate each word into its Morse string and return the number of distinct strings. Time is linear in the total length.
