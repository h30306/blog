---
title: "LeetCode 1235: Maximum Profit in Job Scheduling"
summary: "LeetCode 1235 解題筆記：工作依結束時間排序，best[j] = 只用前 j 個工作的最大收益；選第 j 個時二分搜尋最後一個結束時間 <= 開始時間的工作"
description: "2026-07-31 的 LeetCode 1235 解題紀錄"
date: 2026-07-31
tags: ["hard", "dynamic-programming", "binary-search", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-31
- 提交紀錄：WA ×3 → MLE ×2 → TLE → AC

## 解題思路

工作依**結束時間**排序，`best[j]` = 只考慮前 `j` 個工作的最大收益（`best[0] = 0`）。第 `j` 個工作：

- **不選**：`best[j - 1]`。
- **選**：它開始前結束的工作才能一起選。用二分搜尋找最後一個 `end <= start` 的工作 `i`，`best[i] + profit`。

`best` 是非遞減的，所以「最後一個 `end <= start`」就是那些工作裡最好的。

## 我的嘗試

這題我一開始想用**時間**當 DP 的 index：`dp[t]` = 時間 `t` 之前的最大收益。

| 版本 | 問題 |
|---|---|
| 第一版 WA | 每個時間點只處理了一個在那時結束的工作。例如兩個工作都在時間 7 結束，收益分別是 1 和 9，只處理到收益 1 的那個，回傳 1，答案是 9 |
| 第二、三版 WA | 改成 `while` 處理同時結束的所有工作，但每個都寫 `dp[i] = max(dp[i - 1], ...)`，後面的工作把前面的結果**蓋掉**了。例如 `startTime = [4, 1, 1]`、`endTime = [5, 3, 5]`、`profit = [1, 9, 4]`：選 `[1, 3]` 和 `[4, 5]` 是 10，回傳 9 |
| 兩次 MLE | 修好覆蓋的問題，但 `dp` 陣列的長度是最大的結束時間，到 `10^9` |
| TLE | 改用字典存，但還是一個時間點一個時間點跑迴圈 |
| AC | 改成以工作為單位，排序後二分搜尋 |

## 正確解法

```python
from bisect import bisect_right

class Solution:
    def jobScheduling(self, startTime: List[int], endTime: List[int], profit: List[int]) -> int:
        jobs = sorted(zip(endTime, startTime, profit))
        ends, best = [0], [0]                      # best[j]：只用前 j 個工作
        for e, s, p in jobs:
            i = bisect_right(ends, s) - 1          # 最後一個 end <= s
            best.append(max(best[-1], best[i] + p))
            ends.append(e)
        return best[-1]
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 用時間當 index：時間到 `10^9`。
- 同時結束的工作，更新時要跟**目前的值**取 max，不能直接覆蓋。
- 題目允許「結束在 X、下一個在 X 開始」，所以是 `end <= start`，用 `bisect_right`。

## 面試口說整理

我把工作依結束時間排序，`best[j]` 是只用前 `j` 個工作的最大收益。第 `j` 個工作不選就是 `best[j - 1]`，選的話用二分搜尋找最後一個在它開始前結束的工作，加上它的收益。`best` 是非遞減的，所以那個位置就是最好的。時間 `O(n log n)`。
