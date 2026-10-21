---
title: "LeetCode 344: Reverse String"
summary: "LeetCode 344 解題筆記：左右指針交換後往中間走，原地反轉"
description: "2022-08-23 的 LeetCode 344 解題紀錄"
date: 2022-08-23
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Accepted ×2 → Runtime Error → Accepted

## 解題思路

左右指針交換、往中間走，直到相遇（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。

## 我的嘗試

2026 年重寫時一版右指針從 `len(s)` 開始，超出範圍。

## 正確解法

```python
class Solution:
    def reverseString(self, s: List[str]) -> None:
        l, r = 0, len(s) - 1
        while l < r:
            s[l], s[r] = s[r], s[l]
            l, r = l + 1, r - 1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 右指針從 `len(s) - 1` 開始。

## 面試口說整理

我用左右指針交換兩端再往中間走，原地反轉。時間 `O(n)`、空間 `O(1)`。
