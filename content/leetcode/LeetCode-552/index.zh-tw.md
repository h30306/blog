---
title: "LeetCode 552: Student Attendance Record II"
summary: "LeetCode 552 解題筆記：狀態機 DP，狀態是「A 用了幾次 × 結尾連續幾個 L」共 6 種；每天選 P、A、L 決定下一個狀態"
description: "2026-07-08 的 LeetCode 552 解題紀錄"
date: 2026-07-08
tags: ["hard", "dynamic-programming", "state-machine"]
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
- 提交紀錄：Accepted ×3（同一天用三種寫法）

## 解題思路

合法的條件只跟兩件事有關：**A 總共出現幾次**（只能 0 或 1）、**結尾連續幾個 L**（只能 0、1、2）。所以狀態是 `(a, l)`，共 6 種，`dp[a][l]` = 目前長度、處於這個狀態的紀錄數。

每天選一個字元：

- **P**：A 不變，L 歸零 → `(a, 0)`。
- **A**：只能從 `a = 0` 來，L 歸零 → `(1, 0)`。
- **L**：A 不變，`l + 1`，只能從 `l < 2` 來 → `(a, l + 1)`。

初始只有 `(0, 0)` 是 1，跑 `n` 天後把 6 個狀態加起來。

## 我的解法

```python
class Solution:
    def checkRecord(self, n: int) -> int:
        MOD = 10 ** 9 + 7
        dp = [[0] * 3 for _ in range(2)]           # dp[a][l]
        dp[0][0] = 1
        for _ in range(n):
            ndp = [[0] * 3 for _ in range(2)]
            for a in range(2):
                for l in range(3):
                    cur = dp[a][l]
                    if not cur:
                        continue
                    ndp[a][0] = (ndp[a][0] + cur) % MOD            # P
                    if a == 0:
                        ndp[1][0] = (ndp[1][0] + cur) % MOD        # A
                    if l < 2:
                        ndp[a][l + 1] = (ndp[a][l + 1] + cur) % MOD   # L
            dp = ndp
        return sum(map(sum, dp)) % MOD
```

我第一個 AC 的版本把 6 個狀態寫成 6 個變數，直接列出每個狀態從哪裡來（例如 `(0, 0)` 來自 `(0, 0)`、`(0, 1)`、`(0, 2)` 選 P），比較快（475ms vs 2 秒多）；上面這種「每個狀態往外推」的寫法比較不容易漏掉轉移。

## 複雜度

時間 `O(6n)`，空間 `O(1)`。（還可以用矩陣快速冪做到 `O(log n)`。）

## 要特別避免的錯誤

- 選 A 時 L 要歸零，因為 A 打斷了連續的 L。
- 每一輪要用新的 `ndp`，不能直接改 `dp`。

## 面試口說整理

合法與否只看兩件事：A 出現幾次、結尾連續幾個 L，所以狀態是 2 × 3 = 6 種。每天選 P 會讓 L 歸零，選 A 只能在還沒用過 A 時選，也讓 L 歸零，選 L 讓連續 L 加一但不能到 3。從初始狀態跑 `n` 天，最後把所有狀態加起來。時間 `O(n)`。
