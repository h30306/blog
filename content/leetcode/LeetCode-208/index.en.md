---
title: "LeetCode 208: Implement Trie (Prefix Tree)"
summary: "LeetCode 208 note: each node is a children dict plus an is_end flag; insert, search and startsWith all walk down character by character"
description: "LeetCode 208 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "hash-table", "string", "design", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-29
- Submissions: Wrong Answer → Accepted

## Approach

Each trie node holds `children` (character → child) and `is_end` (whether a word ends here) ([Trie]({{< relref "/algorithm/Trie" >}})). `insert` walks down, creating missing nodes, and sets `is_end`. `search` must also check `is_end` at the last node, while `startsWith` succeeds whenever the walk completes. Each operation is `O(L)`, independent of how many words are stored.

## My Attempts

What I wrote **was not a trie at all**: a list of every word, `search` via `in` and `startsWith` calling `startswith` on each word, `O(N · L)` per call.

- Attempt 1's `startsWith` **returned `False` as soon as the first word failed**, never checking the rest: after inserting `a` and `aba`, `startsWith("ab")` returned `False`.
- `search`'s `else` branch wrote `False` without `return`, yielding `None` on a miss.

## Solution

```python
class Trie:
    def __init__(self):
        self.root = {}

    def insert(self, word: str) -> None:
        node = self.root
        for c in word:
            node = node.setdefault(c, {})
        node["#"] = True

    def _walk(self, s):
        node = self.root
        for c in s:
            if c not in node:
                return None
            node = node[c]
        return node

    def search(self, word: str) -> bool:
        node = self._walk(word)
        return node is not None and "#" in node

    def startsWith(self, prefix: str) -> bool:
        return self._walk(prefix) is not None
```

## Complexity

Each operation is `O(L)`; space is the total length of all words.

## Mistakes to Avoid

- `search` must check the end marker; `app` is a prefix of `apple` but not necessarily a word.
- Using `"#"` as the end marker is safe only because words contain lowercase letters alone.

## Interview Explanation

Each trie node is a dict of children plus an end marker. Insert walks down creating nodes and marks the end; search walks and checks the marker; startsWith succeeds if the walk completes. Each operation is `O(L)`.
