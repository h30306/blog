---
title: "LeetCode 2235: Add Two Integers"
summary: "LeetCode 2235 解題筆記：回傳兩數相加；C++ 版本忘了分號編譯失敗一次"
description: "2025-12-17 的 LeetCode 2235 解題紀錄"
date: 2025-12-17
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
第一次嘗試：2025-12-17
- 提交紀錄：Accepted（Python）→ Compile Error（C++）→ Accepted（C++）

## 解題思路

回傳 `num1 + num2`。這題我拿來練 C++ 的語法。

## 我的嘗試

C++ 第一版 `return num1 + num2` 少了分號，Compile Error。

## 正確解法

```python
class Solution:
    def sum(self, num1: int, num2: int) -> int:
        return num1 + num2
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 從 Python 換到 C++ 時，陳述式結尾要加分號。

## 面試口說整理

直接回傳兩數的和。數值範圍很小，不會溢位。時間 `O(1)`。
