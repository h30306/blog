---
title: "LeetCode 902: Numbers At Most N Given Digit Set"
summary: "LeetCode 902 解題筆記：數位 DP，狀態是 (pos, tight, started)；還沒開始時可以跳過這一位，代表位數比 n 少的數"
description: "2026-07-27 的 LeetCode 902 解題紀錄"
date: 2026-07-27
tags: ["hard", "dynamic-programming", "digit-dp", "math", "binary-search", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-27
- 提交紀錄：Accepted（一次通過）

## 解題思路

只能用給定的數字（沒有 0），數 `<= n` 的正整數。數位 DP，狀態 `(pos, tight, started)`：

- `tight`：前綴是否還貼著 `n`。貼著的時候，這一位只能選 `<= n[pos]` 的數字。
- `started`：數字是否已經開始。**還沒開始時可以跳過這一位**，代表這個數的位數比 `n` 少；跳過之後一定比 `n` 小，所以 `tight` 變成 `False`。
- 走完所有位數時，`started` 才算一個數（不算空的）。

## 我的解法

```python
from functools import cache

class Solution:
    def atMostNGivenDigitSet(self, digits: List[str], n: int) -> int:
        s = str(n)

        @cache
        def dfs(i: int, tight: bool, started: bool) -> int:
            if i == len(s):
                return 1 if started else 0
            res = 0
            if not started:
                res += dfs(i + 1, False, False)    # 跳過這一位：位數更少的數
            for d in digits:                       # digits 已經排序
                if tight and d > s[i]:
                    break
                res += dfs(i + 1, tight and d == s[i], True)
            return res

        return dfs(0, True, False)
```

我 AC 的版本沒有在最後檢查 `started`，而是在倒數第一位之前才允許跳過（`index != len - 1`），一樣可以避免算到空的數字。

另一種做法是直接數：位數比 `n` 少的有 `Σ |D|^k` 個，位數一樣的逐位比較。

## 複雜度

時間 `O(len(n) · |digits|)`，空間 `O(len(n))`。

## 要特別避免的錯誤

- 跳過的那一位之後 `tight` 要變 `False`。
- 不能把「全部都跳過」當成一個數。

## 面試口說整理

數位 DP，狀態是位置、是否貼著 `n`、是否已經開始。還沒開始時可以跳過這一位，代表位數比較少的數，這時一定比 `n` 小；開始之後每一位從給定的數字裡選，貼著 `n` 時不能超過 `n` 的這一位。走完時已經開始才算一個數。時間 `O(len(n) · |digits|)`。
