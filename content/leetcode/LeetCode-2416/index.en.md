---
title: "LeetCode 2416: Sum of Prefix Scores of Strings"
summary: "LeetCode 2416 note: each Trie node counts the words passing through it, and a word's answer is the sum of counts along its path"
description: "LeetCode 2416 record from 2026-09-13"
date: 2026-09-13
tags: ["hard", "trie", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-13
- Submissions: Accepted (first try)

## Approach

A prefix's score is the number of words that start with it. Each word's answer is the sum of the scores of all its prefixes.

In a Trie, **each node represents a prefix**, and "words starting with it" means "words passing through this node". So:

1. While building the Trie, increment the count of every node a word passes through.
2. Walk each word through the Trie again and add up the counts along the way.

## My Solution

```python
class Solution:
    def sumPrefixScores(self, words: List[str]) -> List[int]:
        trie = {}                          # char -> [pass count, children]
        for word in words:
            node = trie
            for ch in word:
                if ch not in node:
                    node[ch] = [0, {}]
                node[ch][0] += 1
                node = node[ch][1]

        res = []
        for word in words:
            total, node = 0, trie
            for ch in word:
                total += node[ch][0]
                node = node[ch][1]
            res.append(total)
        return res
```

## Complexity

Time `O(total length)`: one pass to build and one to query. Space `O(total length)`.

My submission used 293MB of memory: every node is `[count, dict]`, and small Python dicts carry a fixed overhead. A class with `__slots__` would save some.

## Mistakes to Avoid

- Rescanning all words for every prefix: `O(n · L^2)` or worse, too slow.
- Incrementing only when a child node is created instead of on every pass: repeated prefixes get undercounted.

## Interview Explanation

Each Trie node represents a prefix, and the number of words starting with that prefix is the number of words passing through the node. So while building the Trie I increment the count on every node a word passes, and then each word walks the Trie again and sums the counts along its path. Building and querying are both linear in the total length.
