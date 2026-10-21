---
title: "LeetCode 476: Number Complement"
summary: "LeetCode 476 解題筆記：做一個跟 num 一樣長、全部是 1 的遮罩，num ^ mask 就是補數"
description: "2022-08-24 的 LeetCode 476 解題紀錄"
date: 2022-08-24
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
第一次嘗試：2022-08-24
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

補數只翻轉有效位元，不能直接用 `~num`（會連前面的 0 一起翻成 1，變成負數）。`mask = (1 << num.bit_length()) - 1` 是跟 `num` 一樣長、全部是 1 的數，`num ^ mask` 就是答案（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）。

## 我的嘗試

第一版直接用了範例的 `bin(5)`，**忘了換成 `num`**，每次都回傳 5 的補數 2。

## 正確解法

```python
class Solution:
    def findComplement(self, num: int) -> int:
        return num ^ ((1 << num.bit_length()) - 1)
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- `~num` 會翻轉所有位元，結果是負數。

## 面試口說整理

補數只翻轉有效的位元，我用 bit_length 做出跟 num 一樣長、全部是 1 的遮罩，再跟 num 做 XOR。時間 `O(1)`。
