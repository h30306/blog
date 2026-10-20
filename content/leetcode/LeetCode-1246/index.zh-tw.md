---
title: "LeetCode 1246: Palindrome Removal"
summary: "LeetCode 1246 解題筆記：區間 DP；arr[i] 自己刪、兩端相同時跟裡面一起刪，或切成兩段，三種取最小"
description: "2026-09-12 的 LeetCode 1246 解題紀錄"
date: 2026-09-12
tags: ["hard", "dynamic-programming", "interval-dp", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-12
- 提交紀錄：Accepted（一次通過）

## 解題思路

`dp[i][j]` = 把 `arr[i..j]` 全部刪掉的最少次數。三種情況：

1. **`arr[i]` 自己刪**：`1 + dp[i + 1][j]`。
2. **兩端相同**（`arr[i] == arr[j]`）：先把中間刪到剩一個回文，最後一次連同兩端一起刪，次數跟只刪中間一樣：`dp[i + 1][j - 1]`（中間是空的時候是 1）。
3. **切成兩段**：`dp[i][k] + dp[k + 1][j]`。

依長度由短到長填表。

## 我的解法

```python
class Solution:
    def minimumMoves(self, arr: List[int]) -> int:
        n = len(arr)
        dp = [[0] * n for _ in range(n)]           # dp[i][j]：刪完 arr[i..j] 的最少次數
        for i in range(n):
            dp[i][i] = 1
        for length in range(2, n + 1):
            for i in range(n - length + 1):
                j = i + length - 1
                dp[i][j] = 1 + dp[i + 1][j]        # arr[i] 自己刪
                if arr[i] == arr[j]:               # 兩端跟中間最後一次一起刪
                    dp[i][j] = min(dp[i][j], dp[i + 1][j - 1] if length > 2 else 1)
                for k in range(i, j):              # 切成兩段
                    dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j])
        return dp[0][n - 1]
```

## 複雜度

時間 `O(n^3)`，`n <= 100`。空間 `O(n^2)`。

## 要特別避免的錯誤

- 兩端相同時，次數是 `dp[i + 1][j - 1]`，不用再加 1：兩端可以搭中間最後一次刪除的順風車。
- 長度 2 的時候中間是空的，次數是 1。

## 面試口說整理

`dp[i][j]` 是刪完這段的最少次數。左端可以自己刪；如果兩端相同，就先把中間刪到剩一個回文，最後一次連兩端一起刪，次數跟中間一樣；或者在某個位置切成兩段分開刪。三種取最小，依長度由短到長填表，時間 `O(n^3)`。
