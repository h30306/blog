---
title: "LeetCode 3794: Reverse String Prefix"
summary: "LeetCode 3794 解題筆記：切片一行解決；手寫雙指針時要先把字串轉成 list"
description: "2026-01-03 的 LeetCode 3794 解題紀錄"
date: 2026-01-03
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
第一次嘗試：2026-01-03
- 提交紀錄：Accepted（切片）→ Runtime Error ×2 → Accepted（雙指針，2026-01-24）

## 解題思路

把前 `k` 個字元反轉。Python 切片一行就能解決：`s[:k][::-1] + s[k:]`。

## 我的嘗試：改用雙指針練習

一月底回來用雙指針重寫，連續兩次 Runtime Error：

1. `right = len(k) - 1`：`k` 是整數，不能取 `len`，應該是 `k - 1`。
2. 修好之後，`s[left], s[right] = s[right], s[left]` 又出錯：**Python 的字串不能修改**，要先 `list(s)`，最後再 `"".join(...)`。

## 正確解法

```python
class Solution:
    def reversePrefix(self, s: str, k: int) -> str:
        chars = list(s)
        left, right = 0, k - 1
        while left < right:
            chars[left], chars[right] = chars[right], chars[left]
            left += 1
            right -= 1
        return "".join(chars)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（字串不可變，一定要建新的）。

## 要特別避免的錯誤

- 直接修改字串的字元：Python 字串不可變。
- 對整數呼叫 `len`。

## 面試口說整理

Python 的字串不可變，所以我先轉成 list，用兩個指針從第 0 個和第 `k - 1` 個往中間交換，最後再接回字串。也可以直接用切片 `s[:k][::-1] + s[k:]`，兩種都是 `O(n)`。
