---
title: "LeetCode 3904: Smallest Stable Index II"
summary: "LeetCode 3904 解題筆記：前綴最大值減後綴最小值 <= k 的第一個 index；後綴最小值先從右往左建好"
description: "2026-04-19 的 LeetCode 3904 解題紀錄"
date: 2026-04-19
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
第一次嘗試：2026-04-19
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個 index 的分數是 `max(nums[0..i]) - min(nums[i..n-1])`，兩邊各掃一次（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 模板二）：

- 後綴最小值從右往左先建好。
- 前綴最大值從左往右邊掃邊更新，第一個分數 `<= k` 的就回傳。

這題的 I 和 II 只差在長度上限（I 是 100、II 是 `10^5`），我兩題用的是同一份 `O(n)` 程式；I 的範圍小，每個位置直接算 `max` 和 `min` 的 `O(n²)` 也會過。另一題見 [LeetCode 3903]({{< relref "/leetcode/LeetCode-3903" >}})。

## 我的解法

```python
class Solution:
    def firstStableIndex(self, nums: List[int], k: int) -> int:
        n = len(nums)
        suf_min = nums[:]
        for i in range(n - 2, -1, -1):
            suf_min[i] = min(suf_min[i + 1], nums[i])
        pre_max = -inf
        for i, x in enumerate(nums):
            pre_max = max(pre_max, x)
            if pre_max - suf_min[i] <= k:
                return i
        return -1
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 兩個區間都包含 `i` 自己。

## 面試口說整理

分數是左邊到 `i` 的最大值減右邊從 `i` 開始的最小值。我先從右往左建後綴最小值，再從左往右維護前綴最大值，第一個差 `<= k` 的位置就是答案。時間 `O(n)`。
