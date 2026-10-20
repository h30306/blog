---
title: "LeetCode 1023: Camelcase Matching"
summary: "LeetCode 1023 note: two pointers character by character; anything beyond the pattern must be lowercase"
description: "LeetCode 1023 record from 2026-03-19"
date: 2026-03-19
tags: ["medium", "two-pointers", "string", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-03-19
- Submissions: Accepted (first try)

## Approach

A query matches if **lowercase letters** can be inserted into the pattern to form it. In other words:

1. The pattern is a subsequence of the query.
2. Every query character outside that subsequence is **lowercase**.

Compare with two pointers:

- Same character: advance both.
- Different and the query character is uppercase: uppercase cannot be inserted, so fail.
- Different and lowercase: treat it as inserted and advance only the query pointer.

At the end the pattern must be used up, and anything left in the query must be lowercase.

LeetCode tags this as Trie, but each query is compared with one pattern, so two pointers are enough.

## My Solution

```python
class Solution:
    def camelMatch(self, queries: List[str], pattern: str) -> List[bool]:
        def match(q: str) -> bool:
            j = 0
            for ch in q:
                if j < len(pattern) and ch == pattern[j]:
                    j += 1
                elif ch.isupper():
                    return False
            return j == len(pattern)

        return [match(q) for q in queries]
```

My original version ran the two pointers in a `while` loop and then checked separately that `query[r:]` was all lowercase. Scanning the whole query with `for` folds "the rest must be lowercase" into the loop.

## Complexity

Time `O(total length of all queries)`, space `O(1)` excluding the output.

## Mistakes to Avoid

- Checking only that the pattern is a subsequence and forgetting that extra characters cannot be uppercase.
- Not checking the rest of the query after the pattern is used up.

## Interview Explanation

A query matches when the pattern is a subsequence of it and every extra character is lowercase. For each query I scan once: on a match with the pattern's current character I advance the pattern pointer, and on a mismatch with an uppercase character I fail immediately. The pattern must be fully used at the end. Each query is linear, and no Trie is needed.
