---
title: "LeetCode 2376: Count Special Integers"
summary: "LeetCode 2376 解題筆記：數位 DP，狀態 (pos, tight, started, mask)；mask 記錄用過的數字，前導零不能算成用過 0"
description: "2026-09-05 的 LeetCode 2376 解題紀錄"
date: 2026-09-05
tags: ["hard", "dynamic-programming", "digit-dp", "math", "bitmask"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-05
- 提交紀錄：Accepted ×2

## 解題思路

數 `[1, n]` 裡每一位都不重複的數。數位 DP，狀態 `(pos, tight, started, mask)`：

- `mask`：10 bit，記錄哪些數字已經用過。這一位不能選 `mask` 裡的數字。
- `started`：**前導零不算用過 0**。還沒開始時放 0，`mask` 不變；第一個非 0 的數字出現之後才開始記。
- 走完時 `started` 才算一個正整數。

## 我的解法

```python
from functools import cache

class Solution:
    def countSpecialNumbers(self, n: int) -> int:
        s = str(n)

        @cache
        def dfs(i: int, tight: bool, started: bool, mask: int) -> int:
            if i == len(s):
                return 1 if started else 0
            hi = int(s[i]) if tight else 9
            count = 0
            for d in range(hi + 1):
                if mask >> d & 1:
                    continue                       # 這個數字用過了
                now_started = started or d != 0
                new_mask = mask | (1 << d) if now_started else mask   # 前導零不記
                count += dfs(i + 1, tight and d == hi, now_started, new_mask)
            return count

        return dfs(0, True, False, 0)
```

## 複雜度

狀態數最多 `10 × 2 × 2 × 2^10`，每個枚舉 10 個數字，大約 `4 × 10^5`。

## 要特別避免的錯誤

- 前導零記成用過 0：像 `10` 這種數會被誤判。
- `mask` 和 `started` 都要放進 cache 的 key。

## 面試口說整理

數位 DP，狀態是位置、是否貼著 `n`、是否已經開始、用過哪些數字的 mask。這一位不能選 mask 裡的數字；還沒開始時放 0 不記進 mask，因為前導零不是真的數字。走完時已經開始才算。狀態數是 `10 × 4 × 1024`，很小。
