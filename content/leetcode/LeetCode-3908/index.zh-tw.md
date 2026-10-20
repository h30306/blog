---
title: "LeetCode 3908: Valid Digit Number"
summary: "LeetCode 3908 解題筆記：轉成字串，檢查包含 x 而且不是以 x 開頭"
description: "2026-04-25 的 LeetCode 3908 解題紀錄"
date: 2026-04-25
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩個條件都是字串操作：

- 至少出現一次 `x`：`str(x) in s`。
- 不是以 `x` 開頭：`not s.startswith(str(x))`。

## 我的解法

```python
class Solution:
    def validDigit(self, n: int, x: int) -> bool:
        s = str(n)
        return str(x) in s and not s.startswith(str(x))
```

## 複雜度

時間 `O(d)`，空間 `O(d)`。

## 要特別避免的錯誤

- `x` 是整數，要先轉成字串才能跟字串比較。

## 面試口說整理

把 `n` 轉成字串，檢查裡面有 `x`，而且第一個字元不是 `x`。時間 `O(d)`。
