---
title: "LeetCode 3839: Number of Prefix Connected Groups"
summary: "LeetCode 3839 note: words sharing the first k characters are connected, so count by word[:k]; exclude words shorter than k"
description: "LeetCode 3839 record from 2026-02-14"
date: 2026-02-14
tags: ["medium", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-14
- Submissions: Wrong Answer → Accepted

## Approach

"Same first `k` characters" is an equivalence relation, so words sharing a prefix form one group, no Union-Find needed. Count by `word[:k]`; each key with at least two words is a group ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1).

## My Attempts

Attempt 1 did not exclude words **shorter than `k`**: Python's `word[:k]` does not fail, it returns the whole word. For `["b", "b"]`, `k = 2` both words are too short, so the answer is 0; it grouped the two `"b"`s and returned 1. Adding `len(g) == k` passed.

## Solution

```python
class Solution:
    def prefixConnected(self, words: List[str], k: int) -> int:
        cnt = Counter(w[:k] for w in words if len(w) >= k)
        return sum(v >= 2 for v in cnt.values())
```

## Complexity

Time `O(n · k)`, space `O(n · k)`.

## Mistakes to Avoid

- Slicing past the end does not raise; exclude short words yourself.

## Interview Explanation

Sharing the first `k` characters connects words, and it is an equivalence relation, so each prefix is a group. I count by `word[:k]`, skip words that are too short, and count prefixes appearing at least twice. Time `O(nk)`.
