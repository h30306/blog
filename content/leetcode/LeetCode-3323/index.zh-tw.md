---
title: "LeetCode 3323: Minimize Connected Groups by Inserting Interval"
summary: "LeetCode 3323 解題筆記：先合併區間；新區間能把第 l 到 r 組連起來 ⇔ 第 r 組的起點 − 第 l 組的終點 <= k；滑動視窗找一次能連起來最多組"
description: "2026-01-28 的 LeetCode 3323 解題紀錄"
date: 2026-01-28
tags: ["medium", "sliding-window", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-28
- 提交紀錄：Accepted（一次通過）

## 解題思路

1. **先合併**：排序後把重疊或相接的區間合併，得到 `m` 個互不相連的組。
2. 新區間長度最多 `k`。要把第 `l` 組到第 `r` 組連成一組，新區間要從第 `l` 組的終點蓋到第 `r` 組的起點：**`merged[r].start - merged[l].end <= k`**。
3. 用滑動視窗找一次能連起來最多幾組 `cnt`，答案是 `m - (cnt - 1)`。

`r` 往右時起點變大，能連到的 `l` 只會往右，條件單調。

## 我的解法

```python
class Solution:
    def minConnectedGroups(self, intervals: List[List[int]], k: int) -> int:
        intervals.sort()
        merged = []
        for start, end in intervals:
            if merged and start <= merged[-1][1]:
                merged[-1][1] = max(merged[-1][1], end)
            else:
                merged.append([start, end])

        best = left = 0
        for right in range(len(merged)):
            while merged[right][0] - merged[left][1] > k:
                left += 1                          # 新區間蓋不到
            best = max(best, right - left + 1)
        return len(merged) - (best - 1)
```

`right == left` 時 `merged[right][0] - merged[left][1]` 是負的，所以 `left` 不會超過 `right`，`best` 至少是 1。

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 沒先合併就在原區間上滑動：重疊的區間會被算成好幾組。
- 連起 `cnt` 組，組數減少的是 `cnt - 1`，不是 `cnt`。

## 面試口說整理

我先把區間排序合併成互不相連的組。新區間長度最多 `k`，要把第 `l` 到第 `r` 組連起來，需要第 `r` 組的起點減第 `l` 組的終點不超過 `k`。這個條件隨 `r` 單調，用滑動視窗找一次最多能連幾組，組數就少掉那個數量減一。時間 `O(n log n)`。
