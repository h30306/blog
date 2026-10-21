---
title: "LeetCode 3788: Maximum Score of a Split"
summary: "LeetCode 3788 解題筆記：先建後綴最小值，再從左邊累加前綴和，枚舉每個分割點"
description: "2025-12-28 的 LeetCode 3788 解題紀錄"
date: 2025-12-28
tags: ["medium", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-12-28
- 提交紀錄：Accepted（一次通過）

## 解題思路

分割點 `i` 的分數是 `prefixSum(i) - suffixMin(i + 1)`，兩個量都可以預先算好（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 模板二）：

- 後綴最小值 `suf_min[i] = min(nums[i..n-1])`，從右往左建。
- 前綴和邊掃邊加。

數字可能是負的，答案也可能是負的，所以初始值要用 `-inf`。

## 我的解法

我當時把兩個陣列的名字取反了（`prefix_min` 其實是前綴和），而且後綴陣列是反著存的。這裡整理成：

```python
class Solution:
    def maximumScore(self, nums: List[int]) -> int:
        n = len(nums)
        suf_min = nums[:]
        for i in range(n - 2, -1, -1):
            suf_min[i] = min(suf_min[i + 1], nums[i])
        best, prefix = -inf, 0
        for i in range(n - 1):
            prefix += nums[i]
            best = max(best, prefix - suf_min[i + 1])
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 答案可能是負的，初始值不能用 0。
- `i` 最多到 `n - 2`，右邊不能是空的。

## 面試口說整理

分數是左邊的前綴和減右邊的最小值。我先從右往左建後綴最小值，再從左往右累加前綴和，每個分割點算一次取最大。時間 `O(n)`。
