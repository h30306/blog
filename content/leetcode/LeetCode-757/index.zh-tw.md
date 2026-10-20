---
title: "LeetCode 757: Set Intersection Size At Least Two"
summary: "LeetCode 757 解題筆記：按右端點排序（同右端點時左端點大的先），只記最右邊兩個點；沒蓋到就放右端兩點，只蓋到一個就補右端點"
description: "2026-07-08 的 LeetCode 757 解題紀錄"
date: 2026-07-08
tags: ["hard", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-08
- 提交紀錄：Accepted ×2

## 解題思路

按右端點由小到大處理（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板二）。要放點時，**放在目前區間的最右邊**：後面的區間右端點只會更大，放右邊最有機會被它們共用。

所以只要記住目前放的最右邊兩個點 `p1 < p2`：

- `s > p2`：一個都沒蓋到，放 `e - 1` 和 `e` 兩個點。
- `p1 < s <= p2`：只蓋到 `p2`，再放 `e`，新的兩點是 `p2, e`。
- `s <= p1`：兩個都蓋到，不用放。

**同一個右端點時，左端點大的（短的）先處理**。不然「只蓋到一個」時補的 `e` 可能就是已經放的 `p2`，等於同一個點算了兩次。如果第二個 key 換成 `x[0]`（長的先）就會錯，例如 `[[0, 1], [1, 3], [2, 3], [3, 4]]`，答案是 5（例如 0, 1, 2, 3, 4）。長的先處理時，`[1, 3]` 補了 3，接著 `[2, 3]` 又「補」一次 3，兩個點都記成 3，`[3, 4]` 就以為已經蓋到兩個，結果回傳 4。

## 我的解法

```python
class Solution:
    def intersectionSizeTwo(self, intervals: List[List[int]]) -> int:
        intervals.sort(key=lambda x: (x[1], -x[0]))
        p1 = p2 = -1                       # start >= 0，所以 -1 不會被蓋到
        res = 0
        for s, e in intervals:
            if s > p2:
                res += 2
                p1, p2 = e - 1, e
            elif s > p1:
                res += 1
                p1, p2 = p2, e
        return res
```

我當時用第一個區間初始化 `p1, p2`；用 -1 當初始值可以讓第一個區間也走同一個分支。

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 點要放在右端，不是左端。
- 排序要有第二個 key：同右端點時左端點大的先。

## 面試口說整理

我按右端點排序，只記住最右邊的兩個點。新區間一個都沒蓋到就放它最右邊的兩個點，只蓋到一個就補它的右端點。點放越右邊，後面右端點更大的區間越可能共用。同右端點時短的先處理，避免要補的點跟已經放的重複。時間 `O(n log n)`。
