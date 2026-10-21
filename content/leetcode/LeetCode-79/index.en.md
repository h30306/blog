---
title: "LeetCode 79: Word Search"
summary: "LeetCode 79 note: backtrack from every cell, matching the next character in four directions with visited cells marked temporarily and restored; prune early with character counts"
description: "LeetCode 79 record from 2022-10-26"
date: 2022-10-26
tags: ["medium", "array", "string", "backtracking", "depth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-26
- Submissions: Wrong Answer ×4 → Time Limit Exceeded → Accepted → Runtime Error ×2 → Wrong Answer → Runtime Error → Time Limit Exceeded ×2 → Accepted → Time Limit Exceeded → Runtime Error → Time Limit Exceeded → Runtime Error → Time Limit Exceeded → Runtime Error → Time Limit Exceeded → Accepted → Runtime Error ×2 → Time Limit Exceeded ×2 → Accepted → Runtime Error ×2 → Time Limit Exceeded → Runtime Error → Accepted → Time Limit Exceeded ×3 → Accepted ×2 → Time Limit Exceeded ×3 → Accepted ×3

## Approach

Grid backtracking ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) Variation 3): `dfs(i, j, k)` checks `board[i][j] == word[k]` and succeeds at the last character; otherwise it marks the cell `#` to prevent reuse, searches the four directions for `k + 1`, and **restores** the cell afterward. Every cell must be tried as a start.

Pruning matters, or large tests time out:

- If `word` needs a character more often than the board has it, return `False`.
- Compare how often the first and last characters of `word` occur in the board and search from the rarer end (reverse `word`), which cuts branches dramatically.

## My Attempts

This took 42 submissions, the most of anything in this backfill:

- The first 2022-10-26 version **started only at `(0, 0)`**, listed `i + 1` twice instead of `j + 1`, and never restored marked cells: searching `'a'` in `[['c', 'a']]` returned `False`.
- After fixing the directions and starts it kept timing out. Over twenty more tries in 2022-10 and 2022-11 changed the style (passing `word[1:]` slices, a `visited` set, index arithmetic), mostly stuck on Python being too slow, with a few acceptances in between.
- In a 2026-10 rewrite, the final version added the "not enough characters, return `False`" pruning.

## Solution

```python
class Solution:
    def exist(self, board: List[List[str]], word: str) -> bool:
        m, n = len(board), len(board[0])
        have = Counter(c for row in board for c in row)
        need = Counter(word)
        if any(have[c] < k for c, k in need.items()):
            return False
        if have[word[0]] > have[word[-1]]:
            word = word[::-1]
        def dfs(i, j, k):
            if board[i][j] != word[k]:
                return False
            if k == len(word) - 1:
                return True
            board[i][j] = "#"
            found = any(0 <= x < m and 0 <= y < n and dfs(x, y, k + 1)
                        for x, y in ((i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)))
            board[i][j] = word[k]
            return found
        return any(dfs(i, j, 0) for i in range(m) for j in range(n))
```

## Complexity

Time `O(mn · 3^L)`, space `O(L)` for recursion depth.

## Mistakes to Avoid

- Try every cell as a start, not just `(0, 0)`.
- Write the four directions correctly without repeating one.
- Restore marked cells, or other starts are affected.
- Python without pruning times out easily.

## Interview Explanation

I backtrack from every cell, marking a matched cell temporarily, searching four directions for the next character and restoring afterward; character counts prune hopeless inputs, and I start from whichever end of the word is rarer. Worst case `O(mn · 3^L)`.
