---
title: "LeetCode 3731: Find Missing Elements"
summary: "LeetCode 3731 解題筆記：最小和最大值一定還在，枚舉中間的每個整數，用集合檢查有沒有出現"
description: "2025-11-02 的 LeetCode 3731 解題紀錄"
date: 2025-11-02
tags: ["easy", "hash-table", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-11-02
- 提交紀錄：Accepted（一次通過）

## 解題思路

原本的範圍是 `[min, max]`，而且兩端還在陣列裡。枚舉範圍內的每個整數，不在陣列裡的就是缺少的；由小到大枚舉，結果自然排好。

查詢要用集合（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。

## 我的解法

我當時直接用 `i not in nums`，在 list 上查詢每次 `O(n)`；題目範圍很小所以也過了。改成集合：

```python
class Solution:
    def findMissingElements(self, nums: List[int]) -> List[int]:
        seen = set(nums)
        return [x for x in range(min(nums), max(nums)) if x not in seen]
```

`max` 一定在陣列裡，所以 `range` 不包含它也沒關係。

## 複雜度

時間 `O(n + R)`，`R` 是 `max - min`，空間 `O(n)`。

## 要特別避免的錯誤

- 在 list 上用 `in` 是線性搜尋，範圍大時要換成集合。

## 面試口說整理

最小值和最大值一定還在，所以我把陣列轉成集合，枚舉兩者之間的每個整數，不在集合裡的就是缺少的。時間 `O(n + R)`。
