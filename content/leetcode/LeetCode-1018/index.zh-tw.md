---
title: "LeetCode 1018: Binary Prefix Divisible By 5"
summary: "LeetCode 1018 解題筆記：前綴每多一位就是 x = 2x + bit，只要保留 x mod 5，數字不會變大"
description: "2022-09-27 的 LeetCode 1018 解題紀錄"
date: 2022-09-27
tags: ["easy", "array", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-27
- 提交紀錄：Runtime Error → Time Limit Exceeded ×2 → Accepted ×4

## 解題思路

前綴多讀一位時，數值變成 `2x + bit`（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})，左移一位再加上新的位元）。只關心是否被 5 整除，所以每一步都 `% 5`，數字永遠小於 5。每次重新把前綴轉成整數是 `O(n²)`，而且數字會有上萬位。

## 我的嘗試

第一版把整數 list 直接 `join`（TypeError）；修好之後每個前綴都重新轉成整數，`O(n²)` 而且數字越來越大，**TLE 了兩次**。改成每一步只保留餘數才 AC。

## 正確解法

```python
class Solution:
    def prefixesDivBy5(self, nums: List[int]) -> List[bool]:
        res, x = [], 0
        for bit in nums:
            x = (x * 2 + bit) % 5
            res.append(x == 0)
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 每一步取餘數，`(2x + b) mod 5` 只跟 `x mod 5` 有關。
- 每次重新轉換前綴是 `O(n²)`，會 TLE。

## 面試口說整理

前綴每多一位，值就變成兩倍加上新的位元，而我只在乎除以 5 的餘數，所以每一步都只保留餘數，數字不會變大。時間 `O(n)`。
