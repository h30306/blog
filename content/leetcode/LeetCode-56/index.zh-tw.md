---
title: "LeetCode 56: Merge Intervals"
summary: "LeetCode 56 解題筆記：按起點排序，新區間的起點 <= 結果最後一個的終點就合併（終點取 max），否則另開一個"
description: "2022-10-22 的 LeetCode 56 解題紀錄"
date: 2022-10-22
tags: ["medium", "array", "sorting", "quicksort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-22
- 提交紀錄：Wrong Answer ×3 → Accepted → Runtime Error → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted ×3 → Runtime Error ×2 → Accepted ×3

## 解題思路

按起點排序後，能合併的區間一定相鄰（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板二）。維護結果的最後一個區間：新區間 `start <= res[-1][1]` 就合併，終點取 **`max`**（新的可能被包在裡面）；否則另開一個。要跟**已經合併好的**最後一個比，不是跟原本的前一個區間比。

## 我的嘗試

這題從 2022 年寫到 2026 年，錯了 9 次，每次錯在一個條件：

- 跟**原本的前一個區間**比，不是跟合併好的結果比：`[[2, 2], [1, 5], [4, 7]]` 排序後是 `[1, 5], [2, 2], [4, 7]`，`4` 跟 `[2, 2]` 比沒有重疊，回傳 `[[1, 5], [4, 7]]`。
- 用 `<` 而不是 `<=`：`[[0, 2], [2, 3]]` 沒合併。
- 迴圈從 1 開始，第一個區間沒放進結果：`[[5, 5]]` 回傳 `[]`；`append(intervals)` 把整個 list 放進去。
- 2022-10-31 重寫時合併的終點直接用新區間的終點，**被包住的區間把終點縮短了**：`[[6, 9], [7, 8]]` 回傳 `[[6, 8]]`。

## 正確解法

```python
class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals.sort()
        res = []
        for s, e in intervals:
            if res and s <= res[-1][1]:
                res[-1][1] = max(res[-1][1], e)
            else:
                res.append([s, e])
        return res
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 碰到端點也要合併：`[0, 2]` 和 `[2, 3]` 用 `<=`。
- 終點取 `max`，被包住的區間不能把終點縮短。
- 比較的對象是結果的最後一個，不是原本陣列的前一個。

## 面試口說整理

我按起點排序，能合併的區間一定相鄰，所以維護結果的最後一個區間，新的起點不超過它的終點就合併、終點取較大值，否則另開一個。時間 `O(n log n)`。
