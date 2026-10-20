---
title: "LeetCode 1290: Convert Binary Number in a Linked List to Integer"
summary: "LeetCode 1290 解題筆記：從頭走到尾，每一步把目前的值左移一位再加上新的位元"
description: "2025-07-14 的 LeetCode 1290 解題紀錄"
date: 2025-07-14
tags: ["easy", "linked-list", "bit-manipulation", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-07-14
- 提交紀錄：Accepted（一次通過）

## 解題思路

Linked list 從最高位排到最低位，表示一個二進位數。

## 我的解法：先存成陣列，再反過來算

```python
values = []
while head:
    values.append(head.val)
    head = head.next
res = 0
for i, bit in enumerate(values[::-1]):
    res += bit * (2 ** i)
```

正確，但多用了一個陣列，還要反轉。

## 更好的寫法：邊走邊算

從最高位開始，每讀到一個新位元，就把目前的結果**左移一位**（乘 2），再加上這個位元。跟十進位「`123 = ((1 × 10) + 2) × 10 + 3`」是同一個想法：

```python
class Solution:
    def getDecimalValue(self, head: Optional[ListNode]) -> int:
        res = 0
        while head:
            res = (res << 1) | head.val
            head = head.next
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 從頭開始用 `2 ** i` 累加：頭是最高位，不是最低位，要先知道長度或反轉。

## 面試口說整理

Linked list 從最高位排起，所以我邊走邊算：每讀到一個位元，就把目前的結果左移一位再加上它，走到尾就是答案。不需要先存陣列或知道長度，時間 `O(n)`、空間 `O(1)`。
