---
title: "LeetCode 448: Find All Numbers Disappeared in an Array"
summary: "LeetCode 448 解題筆記：把陣列本身當雜湊表，看到 x 就把 nums[x - 1] 標成負數，最後還是正數的位置就是沒出現的數"
description: "2022-08-24 的 LeetCode 448 解題紀錄"
date: 2022-08-24
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
第一次嘗試：2022-08-24
- 提交紀錄：Accepted ×2

## 解題思路

值都在 `1..n`，可以把陣列本身當雜湊表（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板二）：看到 `x` 就把 `nums[abs(x) - 1]` 變成負數，表示 `x` 出現過。用 `abs` 是因為那格可能已經被標成負數。最後 `nums[i] > 0` 的位置，`i + 1` 就沒出現過。`O(1)` 額外空間。

## 我的嘗試

兩次都一次 AC，第一次就是用上面這個「標成負數」的寫法。

## 正確解法

```python
class Solution:
    def findDisappearedNumbers(self, nums: List[int]) -> List[int]:
        for x in nums:
            i = abs(x) - 1
            nums[i] = -abs(nums[i])
        return [i + 1 for i, x in enumerate(nums) if x > 0]
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 讀值的時候要取 `abs`，那格可能已經被標成負數。
- 標記要寫成 `-abs(...)`，同一個數出現兩次時不能翻回正的。

## 面試口說整理

值都在 1 到 n，我把陣列本身當雜湊表，看到 x 就把第 x - 1 格標成負數，最後還是正數的位置加一就是沒出現的數。額外空間 `O(1)`。
