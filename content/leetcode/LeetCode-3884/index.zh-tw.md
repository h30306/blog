---
title: "LeetCode 3884: First Matching Character From Both Ends"
summary: "LeetCode 3884 解題筆記：從兩端往中間比，第一個相等的位置就是答案；長度是奇數時中間一定相等"
description: "2026-03-29 的 LeetCode 3884 解題紀錄"
date: 2026-03-29
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
第一次嘗試：2026-03-29
- 提交紀錄：Accepted（一次通過）

## 解題思路

找最小的 `i`，使得 `s[i] == s[n - 1 - i]`。從 `i = 0` 開始往中間檢查，第一個符合的就是答案。

只需要檢查到中間：`i` 超過中間之後，`(i, n - 1 - i)` 這一對已經在前面檢查過了。

觀察：**長度是奇數時，中間那個字元跟自己比，一定相等**，所以奇數長度一定有答案；只有偶數長度才可能回傳 `-1`。

## 我的解法

```python
class Solution:
    def firstMatchingIndex(self, s: str) -> int:
        n = len(s)
        for i in range((n + 1) // 2):
            if s[i] == s[n - 1 - i]:
                return i
        return -1
```

原本的版本迴圈跑到 `n`，結果一樣（找不到時後半段只是重複檢查同樣的 pair），這裡只跑到中間。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 迴圈只跑到 `n // 2`：奇數長度時會漏掉中間那個字元。

## 面試口說整理

我從 `i = 0` 往中間檢查 `s[i]` 和 `s[n - 1 - i]`，第一個相等的就是答案，只需要檢查到中間，因為後半段的 pair 前面都看過了。奇數長度時中間字元一定和自己相等，所以只有偶數長度可能找不到。時間 `O(n)`。
