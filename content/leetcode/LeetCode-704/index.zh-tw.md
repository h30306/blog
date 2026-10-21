---
title: "LeetCode 704: Binary Search"
summary: "LeetCode 704 解題筆記：左閉右閉區間 [l, r]，mid 用整數除法；找到就回傳，否則依大小縮掉一半"
description: "2022-08-31 的 LeetCode 704 解題紀錄"
date: 2022-08-31
tags: ["easy", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-31
- 提交紀錄：Accepted → Runtime Error ×3 → Accepted ×2 → Runtime Error → Accepted ×3

## 解題思路

標準的二分搜尋（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一）。區間 `[l, r]` 兩端都包含，`while l <= r`：`nums[mid]` 太小就 `l = mid + 1`，太大就 `r = mid - 1`。

## 我的嘗試

幾次 RE 都是 `mid = (l + r) / 2` 得到浮點數拿來當 index（TypeError），或邊界算錯超出範圍。

## 正確解法

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        l, r = 0, len(nums) - 1
        while l <= r:
            mid = (l + r) // 2
            if nums[mid] == target:
                return mid
            if nums[mid] < target:
                l = mid + 1
            else:
                r = mid - 1
        return -1
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- Python 3 的 `/` 會得到浮點數，index 要用 `//`。
- 閉區間就配 `while l <= r` 和 `mid ± 1`。

## 面試口說整理

我用左閉右閉的區間二分，`mid` 比目標小就把左界移到 `mid + 1`，比目標大就把右界移到 `mid - 1`，找到就回傳。時間 `O(log n)`。
