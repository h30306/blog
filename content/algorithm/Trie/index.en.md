---
title: "Trie"
summary: "Building a Trie from nested dicts, counting on nodes, pairing it with DFS, and when a Trie is not actually needed"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["trie", "string", "prefix", "bit-manipulation"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

A Trie (prefix tree) **merges the common prefixes** of many strings. Walking down from the root, each edge is a character and each node represents a prefix.

Signals:

- Many strings with repeated prefix queries: how many words start with a prefix, or whether any word does.
- Finding many words at once in a grid or string: one Trie matches all of them together instead of searching once per word.

## Template 1: A Trie of Nested dicts

The simplest Python version makes every node a dict:

```python
root = {}
for word in words:
    node = root
    for ch in word:
        node = node.setdefault(ch, {})
    node["$"] = word                  # end marker that also stores the word
```

### Key Parameters:

- `setdefault(ch, {})`: create the child if missing, then return it.
- `"$"`: the end marker. Storing the whole word means it need not be rebuilt from the path when found (LC 212).
- A `TrieNode` class with `children` and `is_end` is clearer in an interview, at the cost of more code.

## Template 2: Counting Passes on Each Node

To know how many words start with a prefix, keep a count on every node:

```python
trie = {}
for word in words:
    node = trie
    for ch in word:
        if ch not in node:
            node[ch] = [0, {}]        # [pass count, children]
        node[ch][0] += 1
        node = node[ch][1]
```

The total prefix score of a word (LC 2416) is the sum of the counts along its path.

## Template 3: Trie + Grid DFS

When searching a grid for many words, walk down the Trie during the DFS, and **skip any direction the Trie does not have**:

```python
def dfs(r, c, parent):
    ch = board[r][c]
    node = parent[ch]
    if "$" in node:
        res.append(node.pop("$"))     # remove once found to avoid duplicates
    board[r][c] = "#"
    for (nr, nc) in the four neighbors:
        if in_bounds and board[nr][nc] in node:
            dfs(nr, nc, node)
    board[r][c] = ch
    if not node:
        parent.pop(ch)                # no words left down this branch; prune it
```

Removing found words and their empty nodes keeps later searches out of dead ends.

## When a Trie Is Not Needed

LeetCode tags some problems as Trie when something simpler works:

| Problem | Simpler approach |
|---|---|
| LC 1023 Camelcase Matching | match each query against the pattern with **two pointers**; uppercase letters must line up |
| LC 1178 Number of Valid Words | only the set of letters matters, so use a **26-bit mask** and enumerate the submasks of each puzzle |

Rule of thumb: if a query only depends on the set of letters and not their order, a bitmask is usually better.

## Complexity

- Building: `O(total length of all words)`.
- Querying a string of length `L`: `O(L)`.
- Space: worst case `O(total length × alphabet size)`; dict nodes store only the children that exist, which is usually far smaller.

## Common Mistakes

- Giving every class-based node a 26-slot array: wasteful when words are few and letters are spread out.
- Not removing the end marker after a Trie + DFS hit: the same word gets added repeatedly.
- Using a Trie for its own sake: for problems about letter sets, bitmasks are faster.

## Related LeetCode

- `LC 212` Word Search II
- `LC 2416` Sum of Prefix Scores of Strings
- `LC 1023` Camelcase Matching
- `LC 1178` Number of Valid Words for Each Puzzle
