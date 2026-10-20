---
title: "LeetCode 3507: Minimum Pair Removal to Sort Array I"
summary: "LeetCode 3507 解題筆記：n 很小直接模擬，切片賦值右邊要是 list"
description: "2025-04-06 的 LeetCode 3507 解題紀錄"
date: 2025-04-06
tags: ["easy", "simulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-04-06
- 提交紀錄：Runtime Error → Accepted

## 解題思路

規則是固定的：每次找「和最小的相鄰 pair」，平手取最左邊，合併成一個數。重複到陣列非遞減為止，回傳操作次數。

`n <= 50`，每次操作掃一遍是 `O(n)`，最多操作 `n` 次，直接模擬 `O(n^2)` 就夠了。

`n` 到 `10^5` 的版本（LC 3510）才需要用 heap 加雙向鏈結串列。

## 我的嘗試：切片賦值給了一個 int

```python
nums[min_index:min_index+2] = min_value      # TypeError
```

切片賦值的右邊必須是 iterable。要把兩個元素換成一個，要寫成 `[min_value]`。

## 正確解法

```python
class Solution:
    def minimumPairRemoval(self, nums: List[int]) -> int:
        ops = 0
        while any(nums[i] > nums[i + 1] for i in range(len(nums) - 1)):
            best = min(range(len(nums) - 1), key=lambda i: nums[i] + nums[i + 1])
            nums[best:best + 2] = [nums[best] + nums[best + 1]]
            ops += 1
        return ops
```

`min` 遇到平手會回傳第一個，剛好符合「取最左邊」。

## 複雜度

時間 `O(n^2)`，空間 `O(1)`。

## 要特別避免的錯誤

- 切片賦值右邊放單一值。
- 平手時取到右邊的 pair：比較時要用 `<` 而不是 `<=`。

## 面試口說整理

`n` 最多 50，所以我直接模擬：只要陣列還不是非遞減，就找和最小的相鄰 pair，平手取最左邊，把它換成兩數的和，計數加一。每次操作 `O(n)`，最多 `n` 次，總共 `O(n^2)`。如果 `n` 很大，就要改用 heap 維護 pair 的和，加上雙向鏈結串列處理合併。
