---
title: "LeetCode 3069: Distribute Elements Into Two Arrays I"
summary: "LeetCode 3069 解題筆記：照規則模擬：前兩個各放一邊，之後比較兩個陣列的最後一個，放到最後一個比較大的那邊"
description: "2024-03-03 的 LeetCode 3069 解題紀錄"
date: 2024-03-03
tags: ["easy", "array", "two-pointers", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2024-03-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

直接照規則模擬（[Array]({{< relref "/algorithm/Array" >}}) 模板五）：`arr1 = [nums[0]]`、`arr2 = [nums[1]]`，之後每個數看 `arr1[-1] > arr2[-1]` 決定放哪邊，最後接起來。

## 我的解法

```python
class Solution:
    def resultArray(self, nums: List[int]) -> List[int]:
        a, b = [nums[0]], [nums[1]]
        for x in nums[2:]:
            (a if a[-1] > b[-1] else b).append(x)
        return a + b
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 比的是兩個陣列的**最後一個**元素，不是總和。

## 面試口說整理

我照題目的規則模擬，每個數放到最後一個元素比較大的那個陣列，最後把兩個陣列接起來。時間 `O(n)`。
