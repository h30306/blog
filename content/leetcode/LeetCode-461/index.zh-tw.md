---
title: "LeetCode 461: Hamming Distance"
summary: "LeetCode 461 解題筆記：x ^ y 的每個 1 就是一個不同的位元，數 1 的個數"
description: "2022-08-24 的 LeetCode 461 解題紀錄"
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
- 提交紀錄：Accepted ×2

## 解題思路

兩個位元不同時 XOR 是 1，所以 Hamming distance 就是 `x ^ y` 裡 1 的個數（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）。數 1 可以用 `bin(z).count("1")`，或反覆 `z &= z - 1`（每次消掉最低的 1）。

## 我的解法

```python
class Solution:
    def hammingDistance(self, x: int, y: int) -> int:
        z, count = x ^ y, 0
        while z:
            z &= z - 1
            count += 1
        return count
```

## 複雜度

時間 `O(位元數)`，空間 `O(1)`。

## 要特別避免的錯誤

- `z & (z - 1)` 每次消掉一個 1，迴圈次數等於 1 的個數。

## 面試口說整理

兩個位元不同時 XOR 是 1，我算 x XOR y，再用 z & (z - 1) 一次消掉一個 1 來數個數。時間是 1 的個數。
