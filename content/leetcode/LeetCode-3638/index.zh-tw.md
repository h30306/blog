---
title: "LeetCode 3638: Maximum Balanced Shipments"
summary: "LeetCode 3638 解題筆記：貪心，一段一旦出現比這段最大值小的數就馬上切；因為切之前的那段是非遞減的，最大值就是前一個數"
description: "2025-08-03 的 LeetCode 3638 解題紀錄"
date: 2025-08-03
tags: ["medium", "dynamic-programming", "greedy", "monotonic-stack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-03
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

一段合法 ⇔ 最後一個數 **嚴格小於** 這段的最大值。

**貪心：能切就切**。從左往右，一旦目前的數比這段的最大值小，就結束這段、開始新的一段。早一點結束不會讓後面能切的段變少（後面的元素一個都沒用掉）。

還沒切之前，這段一定是**非遞減**的（不然早就切了），所以這段的最大值就是**前一個數**。只要比較 `weight[i] < weight[i - 1]` 就好。

## 我的嘗試

第一版記住的是這段的**第一個數**，一直跟它比，而不是跟最大值比。例如 `weight = [1, 5, 2]`：`[1, 5, 2]` 的最大值是 5，`2 < 5`，可以組成一段，答案是 1；但 `2` 不小於第一個數 `1`，這版回傳 0。

在不切的時候把記錄的值更新成目前的數（也就是最大值）就 AC 了。

## 正確解法

```python
class Solution:
    def maxBalancedShipments(self, weight: List[int]) -> int:
        count = 0
        prev = None                                # 這段到目前為止的最大值（= 前一個數）
        for w in weight:
            if prev is not None and w < prev:
                count += 1                         # 能切就切
                prev = None                        # 下一段重新開始
            else:
                prev = w
        return count
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 跟這段的第一個數比：要比的是最大值。
- 切完要重新開始，下一個數是新一段的第一個數。

## 面試口說整理

一段合法的條件是最後一個數比這段的最大值小。我用貪心，能切就切，因為早點結束不會浪費後面的元素。還沒切之前這段一定是非遞減的，所以最大值就是前一個數，只要比較相鄰的兩個數。時間 `O(n)`。
