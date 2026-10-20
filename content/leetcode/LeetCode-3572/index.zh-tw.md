---
title: "LeetCode 3572: Maximize Y‑Sum by Picking a Triplet of Distinct X‑Values"
summary: "LeetCode 3572 解題筆記：每個 x 只留最大的 y，再取最大的三個"
description: "2025-06-07 的 LeetCode 3572 解題紀錄"
date: 2025-06-07
tags: ["medium", "greedy", "hash-map", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-06-07
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

要挑三個 index，它們的 `x` 互不相同，讓 `y` 的和最大。

貪心：同一個 `x` 最多只能挑一個，那當然挑 `y` 最大的。所以：

1. 對每個 `x` 值，只留最大的 `y`。
2. 不同的 `x` 少於三種，回傳 `-1`。
3. 否則取最大的三個 `y` 相加。

## 我的嘗試：排序後取錯邊

```python
max_number_of_groups.sort()
return sum(max_number_of_groups[:3])     # 升冪排序，[:3] 是最小的三個
```

升冪排序後前三個是最小的，要取 `[-3:]`。

## 正確解法

```python
import heapq

class Solution:
    def maxSumDistinctTriplet(self, x: List[int], y: List[int]) -> int:
        best = {}
        for xi, yi in zip(x, y):
            if yi > best.get(xi, 0):
                best[xi] = yi
        if len(best) < 3:
            return -1
        return sum(heapq.nlargest(3, best.values()))
```

`heapq.nlargest(3, ...)` 是 `O(m)`，比排序整個 list 的 `O(m log m)` 快一點，也比較不會取錯邊。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 升冪排序後取 `[:3]`。
- 同一個 `x` 挑了兩次。

## 面試口說整理

同一個 `x` 只能選一次，所以每個 `x` 只留下最大的 `y`。如果不同的 `x` 少於三種就回傳 `-1`，否則取最大的三個 `y` 相加。用 dict 掃一次，再用 `nlargest` 取前三，時間 `O(n)`。
