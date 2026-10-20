---
title: "LeetCode 212: Word Search II"
summary: "LeetCode 212 解題筆記：把所有單字建成 Trie，網格 DFS 時同步走 Trie，找到就移除、空節點就剪掉"
description: "2026-10-16 的 LeetCode 212 解題紀錄"
date: 2026-10-16
tags: ["hard", "trie", "backtracking", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-16
- 提交紀錄：Accepted（一次通過）

## 解題思路

LC 79 Word Search 是找一個單字。這題有最多 `3 * 10^4` 個單字，每個單字各做一次網格搜尋太慢。

做法是**把所有單字建成一棵 Trie**，在網格上 DFS 的同時在 Trie 上往下走：

- 下一格的字母不在 Trie 目前節點的子節點裡，就不用走。
- 走到有結尾標記的節點，就找到一個單字。

兩個剪枝讓它夠快：

1. **找到單字後把結尾標記移除**：同一個單字不會被加兩次。
2. **子樹空了就把節點從父節點刪掉**：之後的 DFS 不會再走進已經沒有單字的分支。

## 我的解法

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

`"#"` 不會是任何 Trie 節點的 key，所以 `board[nr][nc] in node` 也順便擋掉了走過的格子。

## 複雜度

時間最壞 `O(m n · 4 · 3^(L-1))`，`L` 是單字最長長度（10）：每個起點往下最多 `L` 層，除了第一步每步最多 3 個方向。剪枝讓實際上快很多。空間 `O(所有單字總長度)`。

## 要特別避免的錯誤

- 每個單字各自做一次 Word Search。
- 找到單字後沒有移除結尾標記，答案出現重複。
- DFS 回來時沒有把格子還原。

## 面試口說整理

單字很多，所以我先把它們建成 Trie，在網格上 DFS 時同步沿著 Trie 往下走，下一格的字母不在目前節點的子節點裡就不走。走到結尾標記就把單字加入答案並移除標記，避免重複；DFS 回來時如果節點已經空了，就從父節點刪掉，之後不會再走進沒有單字的分支。
