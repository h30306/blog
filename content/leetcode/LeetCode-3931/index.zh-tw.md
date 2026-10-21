---
title: "LeetCode 3931: Check Adjacent Digit Differences"
summary: "LeetCode 3931 解題筆記：檢查每一對相鄰數字的差的絕對值都不超過 2"
description: "2026-05-17 的 LeetCode 3931 解題紀錄"
date: 2026-05-17
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-05-17
- 提交紀錄：Accepted（一次通過）

## 解題思路

把字元轉成數字，相鄰兩個比較一次（[String]({{< relref "/algorithm/String" >}}) 模板四）。只要有一對差超過 2 就是 `False`。

## 我的解法

```python
class Solution:
    def isAdjacentDiffAtMostTwo(self, s: str) -> bool:
        return all(abs(int(a) - int(b)) <= 2 for a, b in zip(s, s[1:]))
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（`s[1:]` 的複製）。

## 要特別避免的錯誤

- 字元要先轉成數字再相減。

## 面試口說整理

我把字串跟它自己錯開一位配對，每一對相鄰數字的差都不超過 2 就回傳 `True`。時間 `O(n)`。
