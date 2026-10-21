---
title: "LeetCode 3719: Longest Balanced Subarray I"
summary: "LeetCode 3719 解題筆記：n 只有 1500，固定左端點往右擴，用兩個集合增量維護不同的奇數和偶數"
description: "2026-02-10 的 LeetCode 3719 解題紀錄"
date: 2026-02-10
tags: ["medium", "hash-table", "prefix-sum", "segment-tree", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

條件是「不同的偶數個數 = 不同的奇數個數」。「不同的值」沒辦法直接用前綴和相減，但 `n <= 1500`，`O(n²)` 就夠了：

- 固定左端點 `i`，右端點 `j` 往右擴。
- 兩個集合分別放看過的奇數、偶數，每加一個數只更新一個集合，`O(1)`。
- 兩個集合一樣大時更新答案。

如果 `n` 大很多（這題的 II 版），`O(n²)` 就不夠了，要換更進階的資料結構。

## 我的解法

```python
class Solution:
    def longestBalanced(self, nums: List[int]) -> int:
        n, best = len(nums), 0
        for i in range(n):
            odd, even = set(), set()
            for j in range(i, n):
                (odd if nums[j] % 2 else even).add(nums[j])
                if len(odd) == len(even):
                    best = max(best, j - i + 1)
        return best
```

## 複雜度

時間 `O(n²)`，空間 `O(n)`。

## 要特別避免的錯誤

- 數的是**不同的**值，重複出現的不能多算，所以要用集合。
- 往右擴時增量更新，不要每次重算整個子陣列。

## 面試口說整理

`n` 只有 1500，我固定左端點往右擴，用兩個集合記錄看過的不同奇數和偶數，每一步 `O(1)` 更新，大小相同就更新最長長度。時間 `O(n²)`。
