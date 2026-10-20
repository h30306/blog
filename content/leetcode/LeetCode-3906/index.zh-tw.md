---
title: "LeetCode 3906: Count Good Integers on a Grid Path"
summary: "LeetCode 3906 解題筆記：範圍到 9 × 10^15，不能逐一檢查；數位 DP 同時帶上下界兩個 tight，路徑上的格子要非遞減，狀態多記「路徑上前一個數字」"
description: "2026-04-19 的 LeetCode 3906 解題紀錄"
date: 2026-04-19
tags: ["hard", "dynamic-programming", "digit-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-04-19
- 提交紀錄：Time Limit Exceeded → Accepted（2026-07-29）

## 解題思路

每個數補到 16 位放進 4 × 4 格子，照 `directions` 從左上走到右下，經過的 7 個數字要**非遞減**。

先把路徑經過的格子 index 算出來（`D` 是 `+4`、`R` 是 `+1`），變成一個集合 `path`。題目變成：數 `[l, r]` 裡有幾個 16 位數（含前導零），在 `path` 這些位置上的數字非遞減。

**數位 DP**，狀態是 `(pos, tight_low, tight_high, prev)`：

- `tight_low` / `tight_high`：目前前綴是否還貼著 `l` / `r`，決定這一位的下限和上限。
- `prev`：路徑上前一個數字。如果 `pos` 在路徑上，這一位至少要是 `prev`，選完之後更新 `prev`。

因為固定補成 16 位，前導零就是普通的數字 0，不需要 `started` 狀態。

## 我的嘗試

第一版直接從 `l` 到 `r` 逐一檢查，範圍到 `9 × 10^15`，TLE。三個月後改成數位 DP 就 AC 了。

## 正確解法

```python
from functools import cache

class Solution:
    def countGoodIntegersOnPath(self, l: int, r: int, directions: str) -> int:
        low = list(map(int, str(l).zfill(16)))
        high = list(map(int, str(r).zfill(16)))
        path = {0}
        idx = 0
        for d in directions:
            idx += 4 if d == "D" else 1
            path.add(idx)

        @cache
        def dfs(pos: int, tight_low: bool, tight_high: bool, prev: int) -> int:
            if pos == 16:
                return 1
            lo = low[pos] if tight_low else 0
            hi = high[pos] if tight_high else 9
            if pos in path:
                lo = max(lo, prev)                 # 路徑上要非遞減
            total = 0
            for d in range(lo, hi + 1):
                total += dfs(pos + 1,
                             tight_low and d == low[pos],
                             tight_high and d == high[pos],
                             d if pos in path else prev)
            return total

        return dfs(0, True, True, 0)
```

## 複雜度

狀態數 `16 × 2 × 2 × 10`，每個枚舉 10 個數字，常數時間。

## 要特別避免的錯誤

- 逐一檢查範圍內的數。
- 下界的 tight 要跟 `low[pos]` 比，上界跟 `high[pos]` 比，不能共用。
- 不在路徑上的位置不更新 `prev`。

## 面試口說整理

範圍太大，所以用數位 DP。我先算出路徑經過哪些位置，狀態是位置、上下界兩個 tight 旗標和路徑上的前一個數字。在路徑上的位置，下限要提高到前一個數字。數字固定補成 16 位，前導零就是普通的 0。狀態數是常數。
