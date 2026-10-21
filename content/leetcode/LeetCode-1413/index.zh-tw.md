---
title: "LeetCode 1413: Minimum Value to Get Positive Step by Step Sum"
summary: "LeetCode 1413 解題筆記：起始值加上每個前綴和都要 >= 1，所以起始值是 max(1, 1 - 最小前綴和)"
description: "2022-11-23 的 LeetCode 1413 解題紀錄"
date: 2022-11-23
tags: ["easy", "array", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

過程中的值是 `start + prefix[i]`（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})），全部都要 `>= 1`，最難滿足的是**最小的前綴和**：`start >= 1 - min(prefix)`。起始值本身也要是正數，所以再跟 1 取最大值。

## 我的解法

```python
class Solution:
    def minStartValue(self, nums: List[int]) -> int:
        cur = low = 0
        for x in nums:
            cur += x
            low = min(low, cur)
        return 1 - low
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `low` 從 0 開始，等於把「起始值本身要 `>= 1`」也算進去了。

## 面試口說整理

每一步的值是起始值加上前綴和，我找出最小的前綴和，起始值就是 1 減掉它；最小值從 0 開始算，所以答案至少是 1。時間 `O(n)`。
