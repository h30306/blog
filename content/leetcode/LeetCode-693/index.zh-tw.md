---
title: "LeetCode 693: Binary Number with Alternating Bits"
summary: "LeetCode 693 解題筆記：相鄰位元都不同，代表二進位字串裡沒有 00 也沒有 11；位元版本是 n ^ (n >> 1) 全部是 1"
description: "2022-08-30 的 LeetCode 693 解題紀錄"
date: 2022-08-30
tags: ["easy", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-30
- 提交紀錄：Wrong Answer → Accepted ×4

## 解題思路

字串寫法：`bin(n)` 裡不能有 `"00"` 也不能有 `"11"`。位元寫法（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）：相鄰位元都不同時，`x = n ^ (n >> 1)` 的每一位都是 1，再用 `x & (x + 1) == 0` 檢查全部是 1。

## 我的嘗試

第一版寫成 `'00' in s or '11' in s`，**意思剛好相反**：`2`（`10`）回傳 `False`。改成 `not in ... and not in` 就 AC 了。

## 正確解法

```python
class Solution:
    def hasAlternatingBits(self, n: int) -> bool:
        x = n ^ (n >> 1)
        return x & (x + 1) == 0
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 條件是**沒有** `00` **而且沒有** `11`，不要寫成有。

## 面試口說整理

相鄰位元都不同時，n 和 n 右移一位做 XOR 會得到全部是 1 的數，我再用 x & (x + 1) 是 0 檢查全部是 1。時間 `O(1)`。
