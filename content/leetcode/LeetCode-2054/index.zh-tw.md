---
title: "LeetCode 2054: Two Best Non-Overlapping Events"
summary: "LeetCode 2054 解題筆記：只能選兩個，所以對每個活動，加上「在它開始前就結束的活動裡價值最大的」；依結束時間排序，前綴最大值 + 二分搜尋"
description: "2026-02-04 的 LeetCode 2054 解題紀錄"
date: 2026-02-04
tags: ["medium", "dynamic-programming", "binary-search", "sorting", "heap"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-04
- 提交紀錄：Accepted（一次通過）

## 解題思路

跟 [LeetCode 1235]({{< relref "/leetcode/LeetCode-1235" >}}) 同一類，但只能選**最多兩個**，所以不需要完整的 DP：

- 把活動依結束時間排序，算前綴最大值 `prefix_best[j]` = 前 `j` 個活動裡的最大價值。
- 對每個活動 `(s, e, v)` 當作「第二個」，用二分搜尋找最後一個 `end < s` 的活動（題目的時間是包含兩端的，所以要嚴格小於），答案是 `v + prefix_best`。
- 也要考慮只選一個。

另一種做法是掃描線：把每個活動拆成「開始」和「結束 + 1」兩個事件排序，掃過去時維護已結束活動的最大價值，遇到開始事件就更新答案。我當時 AC 的是掃描線版本。

## 我的解法

```python
from bisect import bisect_left

class Solution:
    def maxTwoEvents(self, events: List[List[int]]) -> int:
        events.sort(key=lambda e: e[1])            # 依結束時間
        ends = [e for _, e, _ in events]
        prefix_best = []
        m = 0
        for _, _, v in events:
            m = max(m, v)
            prefix_best.append(m)

        ans = 0
        for s, _, v in events:
            i = bisect_left(ends, s) - 1           # 最後一個 end < s
            ans = max(ans, v + (prefix_best[i] if i >= 0 else 0))
        return ans
```

掃描線版本：

```python
class Solution:
    def maxTwoEvents(self, events: List[List[int]]) -> int:
        points = []
        for s, e, v in events:
            points.append((s, 1, v))               # 1：開始
            points.append((e + 1, 0, v))           # 0：結束（e + 1 才能接新的）
        points.sort()                              # 同一時間先處理結束
        ans = ended_best = 0
        for _, kind, v in points:
            if kind == 1:
                ans = max(ans, v + ended_best)
            else:
                ended_best = max(ended_best, v)
        return ans
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 時間是閉區間：一個在 `t` 結束、另一個在 `t` 開始算重疊，所以是 `end < start`。
- 掃描線同一時間要先處理結束事件，`(time, 0)` 會排在 `(time, 1)` 前面。

## 面試口說整理

最多選兩個，所以對每個活動，我只要知道在它開始之前就結束的活動裡價值最大的是多少。把活動依結束時間排序、算前綴最大值，再對每個活動二分搜尋最後一個結束時間小於它開始時間的位置，加起來取最大。也可以用掃描線做。時間 `O(n log n)`。
