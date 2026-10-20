---
title: "LeetCode 51: N-Queens"
summary: "LeetCode 51 解題筆記：每列放一個皇后，用三個 set 記錄被佔用的欄和兩條對角線"
description: "2026-07-08 的 LeetCode 51 解題紀錄"
date: 2026-07-08
tags: ["hard", "backtracking"]
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
- 提交紀錄：Accepted → Accepted（重打一次）

## 解題思路

每一列剛好放一個皇后，所以逐列決定皇后放在哪一欄。放之前檢查三件事：

| 衝突 | 判斷方式 |
|---|---|
| 同一欄 | `col` 已經被用過 |
| 同一條「/」對角線 | `row + col` 相同 |
| 同一條「\」對角線 | `row - col` 相同 |

用三個 set 分別記錄，檢查都是 `O(1)`。

## 我的解法

```python
class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        res = []
        board = [["."] * n for _ in range(n)]
        cols, diag1, diag2 = set(), set(), set()

        def backtrack(row: int) -> None:
            if row == n:
                res.append(["".join(r) for r in board])
                return
            for col in range(n):
                if col in cols or row + col in diag1 or row - col in diag2:
                    continue
                board[row][col] = "Q"
                cols.add(col)
                diag1.add(row + col)
                diag2.add(row - col)

                backtrack(row + 1)

                board[row][col] = "."
                cols.remove(col)
                diag1.remove(row + col)
                diag2.remove(row - col)

        backtrack(0)
        return res
```

原本寫的是 `["".join(row) for row in board]`，推導式裡的 `row` 跟函式參數 `row` 同名。Python 3 的推導式有自己的作用域，所以沒出錯，但讀的時候容易搞混，這裡改成 `r`。

## 複雜度

時間 `O(n!)`：第一列有 `n` 種選擇，第二列最多 `n - 1` 種……加上剪枝，實際上少很多。空間 `O(n^2)`，存棋盤。

## 要特別避免的錯誤

- 對角線的判斷寫錯：「/」是 `row + col`、「\」是 `row - col`。
- 撤銷時漏掉其中一個 set。
- 存答案時直接存 `board`：要轉成字串，不然之後的修改會改到已經存的答案。

## 面試口說整理

每一列剛好一個皇后，所以我逐列回溯，決定皇后放在哪一欄。用三個 set 記錄被佔用的欄、`row + col` 和 `row - col` 兩種對角線，衝突就跳過。放下之後遞迴下一列，回來時把三個 set 和棋盤都還原。到第 `n` 列時把棋盤轉成字串存下來。
