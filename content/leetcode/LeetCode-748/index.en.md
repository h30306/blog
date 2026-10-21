---
title: "LeetCode 748: Shortest Completing Word"
summary: "LeetCode 748 note: count the plate's letters in lowercase, then find the shortest word covering every count, taking the earliest on ties"
description: "LeetCode 748 record from 2022-09-03"
date: 2022-09-03
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
First Attempt: 2022-09-03
- Submissions: Wrong Answer → Runtime Error ×2 → Wrong Answer ×6 → Accepted

## Approach

Keep only the plate's letters, lowercase, and count ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1). A word completes it when it covers every needed count (as in LC 383); among those take the shortest, and since ties go to **the earliest**, update only when strictly shorter.

## My Attempts

This took 10 submissions, one bug after another:

- Attempt 1's inner loop used the outer loop's leftover `i`, so it never checked the word's characters (and raised KeyError when the plate ended in a non-letter); the next two were KeyError REs.
- Then `d[i] = d.get(i.lower(), 0) + 1` **stored the original case but read lowercase**: `"B"` was stored as `B`, so the word `"b"` never matched and it returned `None`.
- With lowercase keys, `for word in set(words)` scrambled the order and returned the first match: `"a"`, `["a", "bda"]` returned `"bda"`. Without `set` it still returned the first match rather than the shortest: `"B"`, `["ccb", "b"]` returned `"ccb"`.
- Searching for the shortest started from `""`, so **`len(word) < 0` was never true** and it returned an empty string. Adding a `res == ""` check passed.

## Solution

```python
class Solution:
    def shortestCompletingWord(self, licensePlate: str, words: List[str]) -> str:
        need = Counter(c.lower() for c in licensePlate if c.isalpha())
        best = None
        for w in words:
            if not (need - Counter(w)) and (best is None or len(w) < len(best)):
                best = w
        return best
```

## Complexity

Time `O(total characters)`, space `O(k)`.

## Mistakes to Avoid

- Lowercase the counting keys.
- Do not turn `words` into a `set`: it loses order, which decides ties.
- The first match is not necessarily the shortest; scan everything.
- With `""` as the initial answer, `len(w) < len("")` is never true.

## Interview Explanation

I count the plate's letters in lowercase, check each word's coverage, and keep a match only when strictly shorter, so ties keep the earliest word. Time is linear in the total length.
