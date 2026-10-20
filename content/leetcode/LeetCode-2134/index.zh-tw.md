---
title: "LeetCode 2134: Minimum Swaps to Group All 1's Together II"
summary: "LeetCode 2134 解題筆記：所有 1 最後會佔一段長度為 1 的個數的環狀視窗，要交換的次數就是視窗裡 0 的數量；在環上滑動找最小值"
description: "2025-12-27 的 LeetCode 2134 解題紀錄"
date: 2025-12-27
tags: ["medium", "sliding-window", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-12-27
- 提交紀錄：Accepted（一次通過）

## 解題思路

設 1 的個數是 `ones`。所有 1 聚在一起後，會佔據環上一段長度 `ones` 的連續位置。

對某一段視窗來說，視窗裡的每個 0 都要跟視窗外的一個 1 交換，一次交換解決一個，所以**交換次數 = 視窗裡 0 的數量**。

在環上滑動長度 `ones` 的視窗（index 用 `% n`），找 0 最少的那段。

## 我的解法

我 AC 的寫法沒有處理環，而是換個角度：在環上「1 連在一起」，在直線上只有兩種樣子：

- 1 在直線上連續：長度 `ones` 的視窗裡 0 的數量。
- 1 跨過頭尾：那 0 就在直線上連續，長度 `zeros` 的視窗裡 1 的數量。

兩種各用一次固定長度視窗，取最小值。這裡整理成直接在環上滑動的版本：

```python
class Solution:
    def minSwaps(self, nums: List[int]) -> int:
        n = len(nums)
        ones = sum(nums)
        zeros_in = ones - sum(nums[:ones])         # 視窗 [0, ones) 裡的 0
        best = zeros_in
        for right in range(ones, n + ones - 1):    # 視窗起點 1..n-1
            zeros_in += (nums[right % n] == 0) - (nums[(right - ones) % n] == 0)
            best = min(best, zeros_in)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 忘了環狀：1 可能跨過陣列的頭尾。
- 交換次數不是「要移動的距離」：任意兩個位置都能交換，一次交換就能把一個 0 換出去。

## 面試口說整理

所有 1 聚在一起後佔一段長度等於 1 的個數的連續位置，視窗裡每個 0 都要跟外面的 1 換一次，所以交換次數就是視窗裡 0 的數量。我在環上用固定長度的滑動視窗、index 取模，找 0 最少的那段。也可以不處理環：1 跨過頭尾時，0 在直線上就是連續的，改找長度等於 0 的個數、1 最少的視窗。時間 `O(n)`。
