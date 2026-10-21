---
title: "LeetCode 3909: Compare Sums of Bitonic Parts"
summary: "LeetCode 3909 解題筆記：走到山頂，左右兩邊各自加總；山頂兩邊都算，比大小時加不加都一樣"
description: "2026-04-25 的 LeetCode 3909 解題紀錄"
date: 2026-04-25
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

陣列嚴格先升後降，所以山頂是唯一的。找到山頂之後，左邊是 `nums[0..peak]`、右邊是 `nums[peak..n-1]`（[Array]({{< relref "/algorithm/Array" >}}) 模板一）。山頂兩邊都算，比較大小時兩邊都加同一個數，所以可以都不加。

## 我的解法

```python
class Solution:
    def compareBitonicSums(self, nums: List[int]) -> int:
        peak = nums.index(max(nums))
        left, right = sum(nums[:peak + 1]), sum(nums[peak:])
        if left > right:
            return 0
        if left < right:
            return 1
        return -1
```

我當時用兩個指標從兩端往山頂走，邊走邊加總（沒有加山頂）。嚴格雙調時最大值就是山頂，用 `max` 找也可以。

## 複雜度

時間 `O(n)`，空間 `O(n)`（切片）。

## 要特別避免的錯誤

- 回傳值的對應：左邊大回傳 0、右邊大回傳 1、相等回傳 -1。

## 面試口說整理

嚴格雙調的陣列最大值就是山頂，我找到山頂後分別加總兩邊再比較；山頂兩邊都有，所以不影響比較結果。時間 `O(n)`。
