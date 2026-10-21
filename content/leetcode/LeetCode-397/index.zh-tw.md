---
title: "LeetCode 397: Integer Replacement"
summary: "LeetCode 397 解題筆記：偶數一定除以 2；奇數選 +1 或 -1，用記憶化遞迴；n 很大不能開 n 大小的陣列"
description: "2022-11-16 的 LeetCode 397 解題紀錄"
date: 2022-11-16
tags: ["medium", "dynamic-programming", "greedy", "bit-manipulation", "memoization"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-16
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

偶數只能除以 2。奇數有 `n + 1`、`n - 1` 兩種選擇，都會變成偶數，所以 `f(n) = 2 + min(f((n + 1) / 2), f((n - 1) / 2))`。用記憶化遞迴，每層 `n` 大約減半，狀態只有 `O(log n)` 個。`n` 可以到 `2^31 - 1`，**由下往上開大小 `n` 的陣列會超出記憶體**，而且 `dp[i + 1]` 在算 `dp[i]` 時還沒算出來。

貪心也可以：奇數時看二進位，`n = 3` 或結尾是 `01` 就減 1，否則（結尾 `11`）加 1。

## 我的嘗試

第一版寫了由下往上的 DP，但奇數 `i` 要用到 `dp[i + 1]`，**從小往大算時它還沒算出來**，那個分支等於沒用到，有些奇數會算錯。之後改成遞迴（第一次用 `n / 2` 是浮點數，後來改成 `//`）才 AC。

## 正確解法

```python
class Solution:
    def integerReplacement(self, n: int) -> int:
        @cache
        def f(x):
            if x == 1:
                return 0
            if x % 2 == 0:
                return 1 + f(x // 2)
            return 2 + min(f((x + 1) // 2), f((x - 1) // 2))
        return f(n)
```

## 複雜度

時間 `O(log n)`，空間 `O(log n)`。

## 要特別避免的錯誤

- 由下往上的 DP 在算奇數 `i` 時，`dp[i + 1]` 還沒算。
- `n` 太大，不能開大小 `n` 的陣列。
- `n / 2` 是浮點數，用 `//`。

## 面試口說整理

偶數一定除以 2，奇數試加一和減一兩種，都會變成偶數再除以 2。我用記憶化遞迴，每層 n 大約減半，狀態只有 `O(log n)` 個；n 很大，不能開 n 大小的陣列。
