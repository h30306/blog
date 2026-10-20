---
title: "Backtracking 回溯"
summary: "選擇、遞迴、撤銷的模板，子集合、排列、限制條件、網格搜尋與剪枝"
description: "演算法學習"
date: 2026-10-20
tags: ["backtracking", "recursion", "dfs", "pruning"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

回溯就是**有系統地試遍所有可能**：每一步做一個選擇，遞迴下去，回來之後撤銷這個選擇，再試下一個。

辨識訊號：

- 題目要「所有」組合、排列、子集合、擺法。
- 輸入很小，例如 `n <= 15`、棋盤 `<= 9 × 9`、網格格子 `<= 20`。指數級的時間可以接受。
- 需要「每個元素用一次」、「每格走一次」之類的限制。

## 模板：選擇 → 遞迴 → 撤銷

```python
def backtrack(state):
    if 到達終點(state):
        記錄答案
        return
    for choice in 可以做的選擇(state):
        if 不合法(choice):
            continue
        做選擇(choice)          # 修改 state
        backtrack(state)
        撤銷選擇(choice)        # 把 state 改回來
```

### 主要參數說明：

- **撤銷要跟做選擇完全對稱**：加進 set 的要移除，改成 `#` 的要改回原字元。
- **記錄答案時要複製**：`res.append(path[:])`，不然之後撤銷會改到已經存進去的答案。
- **剪枝越早越好**：在遞迴之前就判斷不合法，而不是走到終點才檢查。

## 變化一：子集合（每個元素選或不選）

```python
def backtrack(i, current):
    if i == n:
        記錄(current)
        return
    backtrack(i + 1, current | nums[i])   # 選
    backtrack(i + 1, current)             # 不選
```

共 `2^n` 種。LC 2044 的剪枝：一旦目前的 OR 已經是最大值，剩下的元素選不選都一樣，直接回傳 `2^(剩下的個數)`。

`n <= 16` 時也可以用位元遮罩直接枚舉 `range(1 << n)`。

## 變化二：放置問題，用 set 記錄被佔用的資源

N-Queens（LC 51）每一列放一個皇后，用三個 set 記錄被佔用的欄和兩條對角線：

```python
cols, diag1, diag2 = set(), set(), set()

def backtrack(row):
    if row == n:
        記錄棋盤
        return
    for col in range(n):
        if col in cols or row + col in diag1 or row - col in diag2:
            continue
        cols.add(col); diag1.add(row + col); diag2.add(row - col)
        backtrack(row + 1)
        cols.remove(col); diag1.remove(row + col); diag2.remove(row - col)
```

同一條「/」對角線上 `row + col` 相同，同一條「\」對角線上 `row - col` 相同。

## 變化三：網格搜尋，原地標記走過的格子

```python
def dfs(r, c):
    原本的值 = grid[r][c]
    grid[r][c] = "#"                       # 標記走過
    for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        nr, nc = r + dr, c + dc
        if 在範圍內 and grid[nr][nc] != "#" and ...:
            dfs(nr, nc)
    grid[r][c] = 原本的值                   # 撤銷
```

- LC 980：要走過每個空格剛好一次，到達終點時檢查步數是否等於空格數。
- LC 212：搭配 Trie，只往「還可能組成單字」的方向走。

## 剪枝技巧

| 技巧 | 例子 |
|---|---|
| 先算出必要的數量，超過就停 | LC 301：先算出最少要刪幾個 `(`、幾個 `)`，刪除額度用完就不能再刪 |
| 剩下的結果可以直接算出來 | LC 2044：OR 已經是最大值，剩下的直接回傳 `2^k` |
| 依照限制條件提早排除 | LC 3799：先比對首字母，不符合就不往下一層 |
| 找到後從資料結構移除 | LC 212：找到的單字從 Trie 移除，空的節點也一起刪掉 |

## 什麼時候用 BFS 取代回溯

題目問「**最少**」操作次數的所有結果時，BFS 一層一層展開，找到第一個合法的層就停下來，通常比回溯簡單。LC 301 的 BFS 版本：每層把每個括號各刪一個，第一個出現合法字串的層就是答案。

## 複雜度

回溯的時間通常是「解的數量 × 每個解的成本」，例如子集合 `O(2^n)`、排列 `O(n!)`。剪枝不會改變最壞情況，但實際上能省很多。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **沒有先算出必要的刪除數就全部試**：LC 301 第一版每個字元都試刪與不刪，TLE。
- **AC 的程式碼裡留著 `print`**：LC 3799，大量輸出會拖慢速度。
- **列表推導式裡的變數跟外層同名**：LC 51 的 `for row in board` 裡面又用 `row`，Python 3 的推導式有自己的作用域所以沒出錯，但讀起來容易誤會。
- **走到終點但步數不對時沒有停**：LC 980 會繼續從終點往外走，不會算錯，但浪費時間。

## 相關 LeetCode

- `LC 2044` Count Number of Maximum Bitwise-OR Subsets
- `LC 3799` Word Squares II
- `LC 51` N-Queens
- `LC 980` Unique Paths III
- `LC 301` Remove Invalid Parentheses
- `LC 212` Word Search II
