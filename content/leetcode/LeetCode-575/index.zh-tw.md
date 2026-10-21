---
title: "LeetCode 575: Distribute Candies"
summary: "LeetCode 575 解題筆記：最多只能吃 n / 2 顆，種類最多 len(set)，答案是兩者的較小值"
description: "2022-08-27 的 LeetCode 575 解題紀錄"
date: 2022-08-27
tags: ["easy", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-27
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×2 → Accepted ×3

## 解題思路

兩個上限：只能吃 `n / 2` 顆，所以種類不會超過 `n / 2`；總共只有 `len(set(candyType))` 種。兩個都達得到，所以答案是 `min`（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。

## 我的嘗試

前兩版語法錯誤，接著兩版寫成 `max`，**兩個上限只取了比較寬鬆的那個**：`[4, 0]` 回傳 2，但只能吃 1 顆。改成 `min` 就 AC 了。

## 正確解法

```python
class Solution:
    def distributeCandies(self, candyType: List[int]) -> int:
        return min(len(candyType) // 2, len(set(candyType)))
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 兩個上限都要滿足，取 `min`。

## 面試口說整理

能吃的種類同時受限於只能吃一半、以及總共只有幾種，所以答案是兩者的較小值。時間 `O(n)`。
