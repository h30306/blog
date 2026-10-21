---
title: "Interval DP 區間 DP"
summary: "區間 DP（枚舉最後一步 / 兩端合併）、切成 k 段的分割 DP、回文表 + 分割，以及狀態太複雜時直接記憶化搜尋整個狀態"
description: "演算法學習"
date: 2026-10-20
tags: ["dynamic-programming", "interval-dp", "memoization", "binary-search"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

區間 DP 的狀態是一段區間 `dp[i][j]`，答案由**更短的區間**組合出來，所以要**依長度由短到長**填表（或用記憶化遞迴）。

常見的轉移方式：

| 形式 | 轉移 | 例子 |
|---|---|---|
| 枚舉最後一步 | `dp[i][j] = max(dp[i][k] + dp[k][j] + cost(i, k, j))` | 戳氣球 |
| 兩端相同可以合併 | `arr[i] == arr[k]` 時一起處理 | 刪除回文子陣列 |
| 切成 k 段 | `dp[i][k] = min(cost(i..j) + dp[j+1][k-1])` | 工作排程、分割陣列 |

複雜度通常是 `O(n^3)`（`n^2` 個區間 × 每個枚舉一個切點），所以 `n` 大多在 500 以內。

## 模板一：枚舉最後一步

**想「最後一個」而不是「第一個」**：先做的那一步會改變左右的鄰居，子問題就不獨立了；最後一步發生時，左右兩邊已經處理完，鄰居是固定的。

```python
val = [1] + nums + [1]                   # 兩端補 1
n = len(val)
dp = [[0] * n for _ in range(n)]         # dp[i][j]：開區間 (i, j) 全部處理完
for length in range(2, n):
    for i in range(n - length):
        j = i + length
        dp[i][j] = max(dp[i][k] + dp[k][j] + val[i] * val[k] * val[j]
                       for k in range(i + 1, j))   # k 是 (i, j) 裡最後一個戳破的
return dp[0][n - 1]
```

（LC 312）

## 模板二：兩端相同可以合併

刪除回文子陣列：`arr[i]` 要嘛自己刪掉，要嘛跟後面某個相同的 `arr[k]` 一起刪（中間先刪完，兩端就能湊成回文的頭尾）：

```python
dp[i][j] = 1 + dp[i + 1][j]                       # arr[i] 自己刪
if arr[i] == arr[j]:
    dp[i][j] = min(dp[i][j], dp[i + 1][j - 1] if j - i > 1 else 1)
for k in range(i, j):
    dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j])   # 切成兩段
```

（LC 1246）。回文子序列、插入次數這類題目見 [String DP]({{< relref "/algorithm/String-DP" >}}) 的 Interval Palindrome DP。

## 模板三：切成 k 段

把陣列依序切成 `k` 段，每段有個成本，求總成本最小（或最大段最小）：

```python
@cache
def dp(i, k):                            # 從 i 開始，切成 k 段
    if k == 1:
        return cost(i, n - 1)
    best = inf
    for j in range(i, n - k + 1):        # 這段是 i..j，後面至少留 k - 1 個
        best = min(best, cost(i, j) + dp(j + 1, k - 1))
    return best
```

- **每天的難度是當天最難的工作**（LC 1335）：`cost` 是區間最大值，邊枚舉邊更新，不用每次重算。
- **最大段最小化**（LC 410）：可以用 DP，但答案有單調性（上限越大越容易切），用**對答案二分搜尋**更快。
- **切成 3 段回文**（LC 1745）：先用區間 DP 建好 `is_pal[i][j]`，再枚舉兩個切點，`O(n^2)`。

## 狀態太複雜時：記憶化搜尋整個狀態

祖瑪遊戲（LC 488）插入球之後會連鎖消除，沒辦法拆成獨立的區間。但 board 和 hand 都很短，可以把 `(board, hand)` 整個當成狀態做 DFS + 記憶化，再加上剪枝：只在「同色球旁邊」或「兩顆同色球中間」插入。

## 不用 DP：貪心

**最長分段回文**（LC 1147）：從兩端同時往內，左右的字串一相等就切，越早切越好，`O(n^2)` 甚至 `O(n)`（用滾動雜湊比較）。

## 主要參數說明

- 填表順序：依長度由短到長，或 `i` 從大到小、`j` 從小到大，確保 `dp[i + 1][...]`、`dp[...][j - 1]` 已經算好。
- 開區間 / 閉區間要一開始決定好。戳氣球用開區間 `(i, j)`，兩端補 1 會比較好寫。
- 切段時後面要留夠：`j` 最多到 `n - k`。

## 複雜度

區間 DP `O(n^3)`；切 `k` 段 `O(k · n^2)`；對答案二分搜尋 `O(n log(sum))`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **取最小值的那一行寫在迴圈外面**：只比較到最後一個切點（LC 1335）。
- **遞迴沒有記憶化**：同樣的 `(i, k)` 被重算很多次，TLE（LC 1335）。
- **變數名稱打錯**：`max_coin` 和 `max_coins` 混用，UnboundLocalError（LC 312）。
- **切點範圍錯**：中間那段可以是空的，或排除了最後一段只有一個字元的情況（LC 1745）。
- **剪枝剪太多**：祖瑪遊戲只在同色球旁邊插入會漏掉「把兩顆同色球拆開」的走法；加上之後插入的位置又錯了一格（LC 488）。
- **區間 DP 的 `i` 從小到大**：`dp[i][j]` 依賴 `dp[i + 1][j - 1]`，`i` 要倒著算（LC 5）。

## 相關 LeetCode

- `LC 312` Burst Balloons
- `LC 1246` Palindrome Removal
- `LC 1335` Minimum Difficulty of a Job Schedule
- `LC 410` Split Array Largest Sum
- `LC 1745` Palindrome Partitioning IV
- `LC 488` Zuma Game
- `LC 1147` Longest Chunked Palindrome Decomposition
- `LC 5` Longest Palindromic Substring
- `LC 647` Palindromic Substrings
