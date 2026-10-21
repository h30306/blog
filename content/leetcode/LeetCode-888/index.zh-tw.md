---
title: "LeetCode 888: Fair Candy Swap"
summary: "LeetCode 888 解題筆記：交換 x 和 y 後總和相等，代表 y = x + (sumB - sumA) / 2；把 B 放進集合，逐一檢查 A 的 x"
description: "2022-09-21 的 LeetCode 888 解題紀錄"
date: 2022-09-21
tags: ["easy", "array", "hash-table", "binary-search", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-21
- 提交紀錄：Time Limit Exceeded → Wrong Answer ×5 → Runtime Error → Time Limit Exceeded ×2 → Wrong Answer → Accepted → Wrong Answer ×3 → Accepted → Wrong Answer → Runtime Error → Accepted

## 解題思路

Alice 給出 `x`、拿到 `y` 之後兩邊相等：`sumA - x + y = sumB - y + x`，整理得 `y = x + (sumB - sumA) / 2`（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。把 Bob 的糖果放進集合，對每個 `x` 檢查 `y` 在不在裡面。

## 我的嘗試

這題提交了 18 次：

- 第一版在迴圈裡每次都重新算 `sum(bobSizes)`，而且用 `in` 在 list 上找，TLE。
- 之後想用兩個指標一邊走一邊調整，條件一直寫不對，索引超出範圍或找不到答案，例如 `[4, 8]` 和 `[4]`（答案 `[8, 4]`）回傳不出來。最後才改成推公式加集合。

## 正確解法

```python
class Solution:
    def fairCandySwap(self, aliceSizes: List[int], bobSizes: List[int]) -> List[int]:
        delta = (sum(bobSizes) - sum(aliceSizes)) // 2
        bob = set(bobSizes)
        for x in aliceSizes:
            if x + delta in bob:
                return [x, x + delta]
```

## 複雜度

時間 `O(m + n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 先把公式推出來，不要在迴圈裡重複算總和（每次 `O(n)`）。
- 題目保證答案存在，差值一定是偶數。

## 面試口說整理

交換後兩邊總和相等可以推出 `y = x + (sumB - sumA) / 2`，所以我把 Bob 的糖果放進集合，對每個 `x` 查 `y` 在不在。時間 `O(m + n)`。
