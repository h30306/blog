---
title: "LeetCode 884: Uncommon Words from Two Sentences"
summary: "LeetCode 884 note: count words across both sentences together; those appearing exactly once are the answer"
description: "LeetCode 884 record from 2022-09-21"
date: 2022-09-21
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
First Attempt: 2022-09-21
- Submissions: Wrong Answer → Accepted ×2

## Approach

"Exactly once in one sentence and absent from the other" equals "exactly once across both". Join, `split()`, count, and keep words with count 1 ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1).

## My Attempts

Attempt 1 forgot to `split` and looped over the string, counting **characters**: `"b"`, `"b"` returned the separating space `[" "]`.

## Solution

```python
class Solution:
    def uncommonFromSentences(self, s1: str, s2: str) -> List[str]:
        cnt = Counter((s1 + " " + s2).split())
        return [w for w, c in cnt.items() if c == 1]
```

## Complexity

Time `O(n + m)`, space `O(n + m)`.

## Mistakes to Avoid

- `split()` into words first; iterating a string yields characters.

## Interview Explanation

I join both sentences, split into words, count, and return the words seen exactly once. Time `O(n + m)`.
