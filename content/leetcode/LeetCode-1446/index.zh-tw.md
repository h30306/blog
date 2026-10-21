---
title: "LeetCode 1446: Consecutive Characters"
summary: "LeetCode 1446 解題筆記：掃一次記錄目前連續相同字元的長度，遇到不同就重設成 1"
description: "2022-08-24 的 LeetCode 1446 解題紀錄"
date: 2022-08-24
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
第一次嘗試：2022-08-24
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

跟前一個字元相同就把目前的長度加一，不同就**重設成 1**（新的字元本身就是長度 1 的一段），過程中記錄最大值。也可以用 `itertools.groupby`。

## 我的嘗試

第一版遇到不同的字元時把長度**重設成 0**，新的那個字元沒算進去：`"baa"` 答案 2，回傳 1。改成 1 就 AC 了。

## 正確解法

```python
class Solution:
    def maxPower(self, s: str) -> int:
        best = cur = 1
        for i in range(1, len(s)):
            cur = cur + 1 if s[i] == s[i - 1] else 1
            best = max(best, cur)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 重設成 1，不是 0。

## 面試口說整理

我掃一次，跟前一個字元相同就把長度加一，不同就重設成 1，過程中記錄最大值。時間 `O(n)`、空間 `O(1)`。
