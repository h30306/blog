---
title: "LeetCode 3989: Maximum Consistent Columns in a Grid"
summary: "LeetCode 3989 解題筆記：保留的欄位是一個子序列，只要相鄰的兩欄相容；LIS 型 DP，dp[j] = 以第 j 欄結尾的最長合法序列"
description: "2026-07-13 的 LeetCode 3989 解題紀錄"
date: 2026-07-13
tags: ["hard", "dynamic-programming", "matrix", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-13
- 提交紀錄：Accepted ×2（記憶化 → LIS 型迴圈）

## 解題思路

保留下來的欄位維持原本順序，是欄位的**子序列**。條件只看**相鄰的兩欄**：每一列的差都 `<= limit`。

這跟 LIS 一樣：`dp[j]` = 以第 `j` 欄結尾、最多能保留幾欄。

```text
dp[j] = 1 + max(dp[i])，i < j 而且第 i 欄和第 j 欄相容
```

檢查兩欄是否相容要看 `m` 列，所以總共 `O(n^2 · m)`。

## 我的解法

```python
class Solution:
    def maxConsistentColumns(self, grid: List[List[int]], limit: int) -> int:
        m, n = len(grid), len(grid[0])

        def compatible(a: int, b: int) -> bool:
            return all(abs(grid[r][b] - grid[r][a]) <= limit for r in range(m))

        dp = [1] * n                               # dp[j]：以第 j 欄結尾
        for j in range(n):
            for i in range(j):
                if dp[i] + 1 > dp[j] and compatible(i, j):
                    dp[j] = dp[i] + 1
        return max(dp)
```

先比較 `dp[i] + 1 > dp[j]` 再檢查相容，可以省掉一些不會更新答案的檢查。

我第一次 AC 用的是 `dp(cur, prev)` 的記憶化（目前看到第 `cur` 欄、上一個保留的是 `prev`），狀態數也是 `O(n^2)`，但多了遞迴的開銷。

## 複雜度

時間 `O(n^2 · m)`，空間 `O(n)`。

## 要特別避免的錯誤

- 至少要保留一欄，`dp` 初始值是 1。
- 條件只看保留下來後相鄰的兩欄，不是原本相鄰的兩欄。

## 面試口說整理

保留的欄位是一個子序列，而條件只看保留後相鄰的兩欄，所以跟 LIS 一樣：`dp[j]` 是以第 `j` 欄結尾最多能保留幾欄，枚舉前一個保留的欄位 `i`，兩欄每一列的差都不超過 `limit` 就能接上。時間 `O(n^2 · m)`。
