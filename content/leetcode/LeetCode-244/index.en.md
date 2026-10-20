---
title: "LeetCode 244: Shortest Word Distance II"
summary: "LeetCode 244 note: precompute each word's positions (sorted by construction), then answer each query by merging the two position lists with two pointers, always advancing the smaller one"
description: "LeetCode 244 record from 2026-02-02"
date: 2026-02-02
tags: ["medium", "two-pointers", "design", "hash-table", "string", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-02
- Submissions: Accepted (first try)

## Approach

There are many queries, so at construction record every position of each word in a hash map. Building it in one pass over the array means **each list is already sorted**.

A query for `word1`, `word2` becomes: given sorted lists `a` and `b`, find the minimum `|a[i] - b[j]|`. With two pointers:

- Compare `a[i]` and `b[j]` and update the answer.
- **Advance the smaller one**: it only gets farther from the later elements of the other list.

## My Attempts

My accepted version compared the two position lists with a nested loop, `O(|a| · |b|)` per query, which is slow when a word appears many times and there are many queries. Two pointers make each query `O(|a| + |b|)`.

## Solution

```python
class WordDistance:
    def __init__(self, wordsDict: List[str]):
        self.pos = defaultdict(list)
        for i, word in enumerate(wordsDict):
            self.pos[word].append(i)               # appended in order, so sorted

    def shortest(self, word1: str, word2: str) -> int:
        a, b = self.pos[word1], self.pos[word2]
        i = j = 0
        best = float("inf")
        while i < len(a) and j < len(b):
            best = min(best, abs(a[i] - b[j]))
            if a[i] < b[j]:
                i += 1                             # a[i] only gets farther from the rest of b
            else:
                j += 1
        return best
```

## Complexity

Construction `O(n)`, each query `O(|a| + |b|)`, space `O(n)`.

## Mistakes to Avoid

- Rescanning the whole array per query: it ignores that there are many queries.
- Comparing every pair of positions with a nested loop: `O(|a| · |b|)`.

## Interview Explanation

At construction I record each word's positions in a hash map; since they are appended in order, each list is sorted. For a query I run two pointers over the two lists, update the minimum difference, and advance the pointer with the smaller value, because it only gets farther from the rest of the other list. Each query is `O(|a| + |b|)`.
