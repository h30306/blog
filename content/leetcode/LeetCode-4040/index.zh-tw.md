---
title: "LeetCode 4040: Minimum Operations to Form Subset Sum I"
summary: "LeetCode 4040 解題筆記：先乘後除時，最佳的做法只會是「只乘」或「只除」；列出每個數能變成的值和步數，再做分組 0/1 背包"
description: "2026-08-30 的 LeetCode 4040 解題紀錄"
date: 2026-08-30
tags: ["medium", "dynamic-programming", "knapsack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-30
- 提交紀錄：Accepted ×2

## 解題思路

一個數 `x` 先乘 `a` 次再除 `b` 次：

- `a >= b`：結果是 `x × 2^(a - b)`，只乘 `a - b` 次就能得到，步數更少。
- `a < b`：結果是 `x // 2^(b - a)`，只除 `b - a` 次就能得到，步數更少。

所以每個數的選項只有「只乘」和「只除」兩類：

- `x, 2x, 4x, ...`（不超過 `sum`），步數 `0, 1, 2, ...`。
- `x // 2, x // 4, ...`（大於 0），步數 `1, 2, ...`。

接著是**分組 0/1 背包**：每個數選一個選項或不選，`dp[s]` = 子集和剛好是 `s` 的最少步數。

## 我的解法

```python
class Solution:
    def minOperations(self, nums: List[int], sum: int) -> int:
        INF = float("inf")
        dp = [0] + [INF] * sum                     # dp[s]：子集和為 s 的最少步數
        for x in nums:
            options = []
            v, cost = x, 0
            while v <= sum:                        # 只乘
                options.append((v, cost))
                v, cost = v * 2, cost + 1
            v, cost = x // 2, 1
            while v > 0:                           # 只除
                if v <= sum:
                    options.append((v, cost))
                v, cost = v // 2, cost + 1

            for s in range(sum, -1, -1):           # 倒著走：每個數最多用一次
                if dp[s] == INF:
                    continue
                for v, cost in options:
                    if s + v <= sum:
                        dp[s + v] = min(dp[s + v], dp[s] + cost)
        return dp[sum] if dp[sum] < INF else -1
```

這裡是「從 `dp[s]` 往 `dp[s + v]` 推」，`s` 倒著走時 `dp[s]` 一定還是上一個數處理完的值。

## 複雜度

時間 `O(n · sum · log(sum))`，空間 `O(sum)`。

## 要特別避免的錯誤

- 以為要枚舉所有乘除的組合：先乘後除的組合都不會比單純的乘或除好。
- 除到 0 的值沒有用，不用放進選項。

## 面試口說整理

先乘後除時，乘和除會互相抵銷，所以最佳做法只會是只乘或只除。我列出每個數能變成的值和步數，每個數最多選一個，做分組 0/1 背包，`dp[s]` 是子集和為 `s` 的最少步數，容量倒著走。時間 `O(n · sum · log(sum))`。
