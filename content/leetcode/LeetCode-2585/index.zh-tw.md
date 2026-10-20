---
title: "LeetCode 2585: Number of Ways to Earn Points"
summary: "LeetCode 2585 解題筆記：有數量上限的背包（分組背包）；每種題目選 0 到 count 題，容量倒著走，在裡面枚舉選幾題"
description: "2026-08-27 的 LeetCode 2585 解題紀錄"
date: 2026-08-27
tags: ["hard", "dynamic-programming", "knapsack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-27
- 提交紀錄：Accepted ×2

## 解題思路

同一種題目的題目沒有差別，所以每種題目要決定的是**選幾題**（`0` 到 `count`）。這是有數量上限的背包，也可以看成分組背包：每一組（每一種題目）選一個選項。

`dp[s]` = 拿到剛好 `s` 分的方法數，`dp[0] = 1`。對每一種題目，容量**倒著走**，對每個 `s` 加上「這種選 `k` 題」的方法：`dp[s] += dp[s - k × marks]`。

倒著走保證 `dp[s - k × marks]` 還是上一種題目處理完的值，同一種題目不會被重複計算。

## 我的解法

```python
class Solution:
    def waysToReachTarget(self, target: int, types: List[List[int]]) -> int:
        MOD = 10 ** 9 + 7
        dp = [1] + [0] * target                    # dp[s]：剛好 s 分的方法數
        for count, marks in types:
            for s in range(target, 0, -1):         # 倒著走
                for k in range(1, count + 1):      # 這種題目選 k 題
                    if s - k * marks < 0:
                        break
                    dp[s] = (dp[s] + dp[s - k * marks]) % MOD
        return dp[target]
```

`s - k × marks` 變成負的就可以 `break`，後面的 `k` 更大。

## 複雜度

時間 `O(target · Σ count)`，空間 `O(target)`。

## 要特別避免的錯誤

- 容量正著走：會變成同一種題目可以無限選。
- 把同種的題目當成不同的：題目說它們沒有差別，所以只看選幾題。

## 面試口說整理

同一種題目沒有差別，所以每種題目只決定選幾題，從 0 到 `count`。這是有數量上限的背包，我用一維 `dp`，每種題目把容量倒著走，在裡面枚舉選幾題，把對應的方法數加上來。倒著走保證同一種題目不會被重複使用。時間 `O(target · Σ count)`。
