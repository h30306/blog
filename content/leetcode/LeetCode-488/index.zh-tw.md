---
title: "LeetCode 488: Zuma Game"
summary: "LeetCode 488 解題筆記：board 最多 16 顆、hand 最多 5 顆，把 (board, hand) 整個當狀態做 DFS + 記憶化；只在「同色球前面」和「拆開兩顆同色球」兩種位置插入"
description: "2026-07-08 的 LeetCode 488 解題紀錄"
date: 2026-07-08
tags: ["hard", "dynamic-programming", "memoization", "breadth-first-search", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-08
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

插入一顆球之後會連鎖消除，沒辦法拆成獨立的區間。但 board 最多 16 顆、hand 最多 5 顆，可以把 `(board, hand)` 整個當成狀態，DFS + 記憶化：

- `board` 空了：0 步。
- 對 hand 裡每一種球（排序後跳過相同的）、board 的每個插入位置，插入後消除，遞迴，取最小值 + 1。

**剪枝**：只在兩種位置插入，其他位置不會更好：

1. **插在同色球的前面**：湊成一組。
2. **把兩顆相同、但跟手上這顆不同色的球拆開**：例如 `RR` 中間插 `W` 變成 `RWR`，之後兩邊的 `R` 可以跟其他 `R` 湊。

消除用一個迴圈：找到長度 `>= 3` 的連續同色就刪掉，從頭重新檢查，直到沒有可以刪的。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 | 只在同色球旁邊插入，漏掉「拆開兩顆同色球」的走法 |
| 第二版 | 加上拆開的條件，但插入的位置寫成 `b[:j + 1] + h[i] + b[j + 1:]`，插在 `b[j]` 的**後面**；拆開兩顆同色球要插在 `b[j - 1]` 和 `b[j]` 之間，結果還是沒拆開 |
| AC | 改成 `b[:j] + h[i] + b[j:]` |

兩版都在 `board = "RRWWRRBBRR"`、`hand = "WB"` 失敗：答案是 2（先在 `RR` 中間插 `W` 拆開，觸發連鎖消除），兩版都回傳 -1。

## 正確解法

```python
from functools import cache

class Solution:
    def findMinStep(self, board: str, hand: str) -> int:
        def clean(s: str) -> str:
            i = 0
            while i < len(s):
                j = i
                while j < len(s) and s[j] == s[i]:
                    j += 1
                if j - i >= 3:
                    s = s[:i] + s[j:]              # 刪掉之後從頭再檢查（連鎖消除）
                    i = 0
                else:
                    i = j
            return s

        @cache
        def dfs(b: str, h: str) -> float:
            if not b:
                return 0
            best = float("inf")
            for i in range(len(h)):
                if i > 0 and h[i] == h[i - 1]:
                    continue                       # 同一種球只試一次
                for j in range(len(b) + 1):
                    same = j < len(b) and b[j] == h[i]
                    split = 0 < j < len(b) and b[j - 1] == b[j] != h[i]
                    if same or split:
                        nb = clean(b[:j] + h[i] + b[j:])
                        best = min(best, 1 + dfs(nb, h[:i] + h[i + 1:]))
            return best

        res = dfs(board, "".join(sorted(hand)))
        return -1 if res == float("inf") else res
```

## 複雜度

狀態數是 board 經過若干次插入消除的結果 × hand 的子集，最壞是指數級，但 board 和 hand 都很短，加上記憶化和剪枝可以過。

## 要特別避免的錯誤

- 只在同色球旁邊插入：「拆開兩顆同色球」有時候是唯一的解法。
- 插入位置差一格。
- hand 要先排序，才能跳過相同的球。

## 面試口說整理

插入之後會連鎖消除，沒辦法拆成子問題，但 board 和 hand 都很短，所以我把整個 `(board, hand)` 當狀態做記憶化 DFS。每一步試 hand 裡每種球、每個插入位置，只在同色球前面或拆開兩顆同色球的地方插入，插入後模擬消除再遞迴，取最小步數。
