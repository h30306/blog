---
title: "LeetCode 212: Word Search II"
summary: "LeetCode 212 note: build a Trie of all words, walk it during the grid DFS, remove words once found, and prune empty nodes"
description: "LeetCode 212 record from 2026-10-16"
date: 2026-10-16
tags: ["hard", "trie", "backtracking", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-16
- Submissions: Accepted (first try)

## Approach

LC 79 Word Search looks for one word. This problem has up to `3 * 10^4` words, so one grid search per word is too slow.

Instead, **build one Trie from all the words** and walk down it while running the grid DFS:

- If the next cell's letter is not a child of the current Trie node, do not go there.
- Reaching a node with an end marker means a word was found.

Two prunings make it fast enough:

1. **Remove the end marker once a word is found**: no word is added twice.
2. **Delete a node from its parent once its subtree is empty**: later DFS runs never enter branches with no words left.

## My Solution

```python
class Solution:
    def findWords(self, board: List[List[str]], words: List[str]) -> List[str]:
        root = {}
        for w in words:
            node = root
            for ch in w:
                node = node.setdefault(ch, {})
            node["$"] = w

        m, n = len(board), len(board[0])
        res = []

        def dfs(r: int, c: int, parent: dict) -> None:
            ch = board[r][c]
            node = parent[ch]
            if "$" in node:
                res.append(node.pop("$"))
            board[r][c] = "#"
            for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and board[nr][nc] in node:
                    dfs(nr, nc, node)
            board[r][c] = ch
            if not node:
                parent.pop(ch)

        for r in range(m):
            for c in range(n):
                if board[r][c] in root:
                    dfs(r, c, root)
        return res
```

`"#"` is never a key of a Trie node, so `board[nr][nc] in node` also blocks visited cells.

## Complexity

Worst-case time `O(m n · 4 · 3^(L-1))`, where `L` is the longest word length (10): each start goes at most `L` deep with at most 3 directions after the first step. Pruning makes it much faster in practice. Space `O(total length of all words)`.

## Mistakes to Avoid

- Running Word Search separately for every word.
- Not removing the end marker once found, which duplicates answers.
- Not restoring the cell after the DFS returns.

## Interview Explanation

There are many words, so I build them into a Trie and walk down it during the grid DFS, skipping any neighbor whose letter is not a child of the current node. At an end marker I add the word and remove the marker to avoid duplicates; on the way back, if a node is empty I delete it from its parent so later searches skip branches with no words.
