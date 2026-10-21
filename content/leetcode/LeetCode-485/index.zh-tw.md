---
title: "LeetCode 485: Max Consecutive Ones"
summary: "LeetCode 485 解題筆記：遇到 1 就把目前的長度加一，遇到 0 就歸零，過程中記錄最大值"
description: "2022-08-24 的 LeetCode 485 解題紀錄"
date: 2022-08-24
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-24
- 提交紀錄：Accepted ×4

## 解題思路

跟 LC 674 一樣是走過連續段（[Array]({{< relref "/algorithm/Array" >}}) 模板一）：遇到 1 就加一，遇到 0 歸零，每一步更新最大值。

## 我的解法

```python
class Solution:
    def findMaxConsecutiveOnes(self, nums: List[int]) -> int:
        best = cur = 0
        for x in nums:
            cur = cur + 1 if x == 1 else 0
            best = max(best, cur)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 每一步都更新最大值，最後一段才不會漏掉。

## 面試口說整理

我掃一次，遇到 1 就把長度加一、遇到 0 就歸零，每一步都更新最大值。時間 `O(n)`、空間 `O(1)`。
