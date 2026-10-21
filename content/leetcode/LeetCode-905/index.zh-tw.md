---
title: "LeetCode 905: Sort Array By Parity"
summary: "LeetCode 905 解題筆記：寫入指標把偶數交換到前面，跟 move zeroes 一樣"
description: "2022-09-25 的 LeetCode 905 解題紀錄"
date: 2022-09-25
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
第一次嘗試：2022-09-25
- 提交紀錄：Wrong Answer → Accepted ×2 → Runtime Error → Accepted ×3

## 解題思路

跟 LC 283 一樣（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板五）：`left` 是下一個偶數要放的位置，遇到偶數就交換到前面。

## 我的嘗試

第一版沒有回傳陣列；第二版用了沒定義的變數。

## 正確解法

```python
class Solution:
    def sortArrayByParity(self, nums: List[int]) -> List[int]:
        left = 0
        for right in range(len(nums)):
            if nums[right] % 2 == 0:
                nums[left], nums[right] = nums[right], nums[left]
                left += 1
        return nums
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 這題要回傳陣列。

## 面試口說整理

我用寫入指標把偶數依序交換到前面，奇數自然留在後面。時間 `O(n)`、空間 `O(1)`。
