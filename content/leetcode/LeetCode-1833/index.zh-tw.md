---
title: "LeetCode 1833: Maximum Ice Cream Bars"
summary: "LeetCode 1833 解題筆記：從最便宜的開始買；題目要求計數排序，值域只有 10^5，每個價格一次買 min(數量, 錢 // 價格) 個"
description: "2026-06-21 的 LeetCode 1833 解題紀錄"
date: 2026-06-21
tags: ["medium", "greedy", "sorting", "counting-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-21
- 提交紀錄：Accepted ×2（排序版、計數排序版）

## 解題思路

要買最多個，就從最便宜的開始買（交換論證：任何買法裡，把一個貴的換成沒買的便宜的，個數不變、花費不增）。

題目要求用計數排序：價格最多 `10^5`，數每個價格有幾個，由小到大走，每個價格買 `min(cnt, coins // price)` 個。錢不夠買目前價格時，後面更貴的也買不起，可以直接停。這是 [Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一。

## 我的解法

第一版用 `sort()` 一個一個買；第二版照題目要求改成計數排序：

```python
class Solution:
    def maxIceCream(self, costs: List[int], coins: int) -> int:
        cnt = [0] * (max(costs) + 1)
        for c in costs:
            cnt[c] += 1
        bought = 0
        for price in range(1, len(cnt)):
            if price > coins:
                break
            take = min(cnt[price], coins // price)
            coins -= take * price
            bought += take
        return bought
```

## 複雜度

時間 `O(n + M)`，`M` 是最高價格，空間 `O(M)`。

## 要特別避免的錯誤

- 同一個價格不一定能全部買下，要取 `min(cnt, coins // price)`。

## 面試口說整理

從最便宜的買起，個數一定最多。題目要求計數排序，所以我數每個價格的數量，由小到大每個價格能買多少就買多少，錢不夠目前價格就停。時間 `O(n + M)`。
