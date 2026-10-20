---
title: "LeetCode 3550: Smallest Index With Digit Sum Equal to Index"
summary: "LeetCode 3550 解題筆記：由小到大檢查每個 index，算位數和，第一個相等的就是答案"
description: "2025-05-18 的 LeetCode 3550 解題紀錄"
date: 2025-05-18
tags: ["easy", "math", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-05-18
- 提交紀錄：Accepted（一次通過）

## 解題思路

從 index 0 開始，算 `nums[i]` 的位數和，第一個等於 `i` 的就是最小的 index；都沒有就回傳 -1。

## 我的解法

```python
class Solution:
    def smallestIndex(self, nums: List[int]) -> int:
        for i, x in enumerate(nums):
            if sum(int(c) for c in str(x)) == i:
                return i
        return -1
```

## 複雜度

時間 `O(n · d)`，`d` 是位數，空間 `O(d)`。

## 要特別避免的錯誤

- 要回傳最小的 index，從頭掃到第一個就回傳。

## 面試口說整理

由小到大掃每個 index，把數字轉成字串加總位數，第一個等於 index 的就回傳，沒有就回傳 -1。時間 `O(n · d)`。
