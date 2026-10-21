---
title: "LeetCode 977: Squares of a Sorted Array"
summary: "LeetCode 977 解題筆記：平方後最大的一定在兩端，左右指針比較兩端的平方，大的從結果的最後面往前填"
description: "2022-09-26 的 LeetCode 977 解題紀錄"
date: 2022-09-26
tags: ["easy", "array", "two-pointers", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Wrong Answer → Accepted ×3

## 解題思路

有負數的話平方之後順序會亂，但**最大的平方一定在兩端**（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。左右指針比較兩端的平方，大的放到結果的最後面，往中間收。

## 我的嘗試

第一版寫成 `[...].sort()`，`sort()` 是原地排序、回傳 `None`，所以整個函式回傳 `None`。

## 正確解法

```python
class Solution:
    def sortedSquares(self, nums: List[int]) -> List[int]:
        n = len(nums)
        res = [0] * n
        l, r = 0, n - 1
        for k in range(n - 1, -1, -1):
            if abs(nums[l]) > abs(nums[r]):
                res[k] = nums[l] * nums[l]
                l += 1
            else:
                res[k] = nums[r] * nums[r]
                r -= 1
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- `list.sort()` 是原地排序，回傳 `None`；要回傳排序後的 list 用 `sorted()`。

## 面試口說整理

平方後最大的一定在兩端，所以我用左右指針比較兩端的絕對值，大的平方從結果的尾巴往前放。時間 `O(n)`。
