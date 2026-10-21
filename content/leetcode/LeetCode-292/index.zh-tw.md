---
title: "LeetCode 292: Nim Game"
summary: "LeetCode 292 解題筆記：剩 4 的倍數顆石頭的人必輸，所以 n % 4 != 0 時先手贏"
description: "2022-08-23 的 LeetCode 292 解題紀錄"
date: 2022-08-23
tags: ["easy", "math", "brainteaser", "minimax-algorithm", "game-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

先觀察小的情況（[Math]({{< relref "/algorithm/Math" >}}) 模板四）：剩 1 到 3 顆可以一次拿完，贏；剩 4 顆不管拿幾顆，對手都剩 1 到 3 顆，輸。一般來說，面對 4 的倍數時，你拿 `x` 顆，對手就拿 `4 - x` 顆，讓你一直面對 4 的倍數；不是 4 的倍數時，你可以拿到讓對手面對 4 的倍數。

## 我的解法

```python
class Solution:
    def canWinNim(self, n: int) -> bool:
        return n % 4 != 0
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- `n` 到 `2^31`，DP 會超時也會超出記憶體，要找規律。

## 面試口說整理

我先看小的情況，發現剩 4 的倍數的人一定輸，因為對手每次都能拿成總和 4，所以 n 不是 4 的倍數時先手贏。時間 `O(1)`。
