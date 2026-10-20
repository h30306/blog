---
title: "LeetCode 1335: Minimum Difficulty of a Job Schedule"
summary: "LeetCode 1335 解題筆記：切成 d 段的分割 DP；dp(i, k) = 從第 i 個工作開始、剩 k 天的最小難度，枚舉今天做到哪裡，邊枚舉邊更新今天的最大難度"
description: "2026-07-02 的 LeetCode 1335 解題紀錄"
date: 2026-07-02
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
第一次嘗試：2026-07-02
- 提交紀錄：WA → TLE → AC（記憶化）→ AC ×4（迴圈版本，07-03、07-04）

## 解題思路

工作要依序做，每天至少一個，一天的難度是當天最難的工作。就是把陣列**切成 `d` 段**，每段成本是區間最大值，總和最小。

`dp(i, k)` = 從第 `i` 個工作開始、還剩 `k` 天的最小總難度：

- `k == 1`：今天要做完剩下的全部，`max(jobs[i:])`。
- 否則枚舉今天做 `i..j`，後面至少要留 `k - 1` 個工作給 `k - 1` 天，所以 `j <= n - k`。今天的難度邊枚舉邊更新 `cur = max(cur, jobs[j])`。

工作數 `< d` 時無解，回傳 -1。

## 我的嘗試

1. **WA**：取 `min` 的那一行縮排錯了，寫在 `for` 迴圈外面，只有最後一個切點被比較。例如 `jobs = [1, 2, 4]`、`d = 2`：`[1, 2] + [4]` 是 6，`[1] + [2, 4]` 是 5，答案是 5，回傳 6。
2. **TLE**：修好縮排，但遞迴沒有記憶化。
3. **AC**：加上 `@cache`。之後又寫了幾次由下往上的迴圈版本，從 2 秒降到 0.3 秒左右。

## 正確解法

```python
from functools import cache

class Solution:
    def minDifficulty(self, jobDifficulty: List[int], d: int) -> int:
        n = len(jobDifficulty)
        if n < d:
            return -1

        @cache
        def dp(i: int, k: int) -> int:             # 從 i 開始，還剩 k 天
            if k == 1:
                return max(jobDifficulty[i:])
            best = float("inf")
            cur = 0
            for j in range(i, n - k + 1):          # 今天做 i..j
                cur = max(cur, jobDifficulty[j])
                best = min(best, cur + dp(j + 1, k - 1))
            return best

        return dp(0, d)
```

## 複雜度

時間 `O(d · n^2)`，空間 `O(d · n)`。（用單調堆疊可以優化到 `O(d · n)`。）

## 要特別避免的錯誤

- 更新最小值的那一行要在迴圈裡面。
- 遞迴要記憶化。
- 今天最多做到 `n - k`，後面要留夠工作給剩下的天數。

## 面試口說整理

這是把陣列切成 `d` 段、每段成本是區間最大值的分割 DP。`dp(i, k)` 是從第 `i` 個工作開始、剩 `k` 天的最小難度，枚舉今天做到哪裡，今天的難度邊走邊取最大值，加上後面的 `dp`。後面要留夠工作給剩下的天數。時間 `O(d · n^2)`。
