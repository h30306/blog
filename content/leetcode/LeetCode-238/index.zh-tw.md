---
title: "LeetCode 238: Product of Array Except Self"
summary: "LeetCode 238 解題筆記：答案是左邊所有數的乘積乘上右邊所有數的乘積，兩次掃描，不用除法"
description: "2022-10-27 的 LeetCode 238 解題紀錄"
date: 2022-10-27
tags: ["medium", "array", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-27
- 提交紀錄：Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Output Limit Exceeded → Accepted → Runtime Error → Accepted ×5

## 解題思路

`res[i] = (nums[0] × ... × nums[i - 1]) × (nums[i + 1] × ... × nums[n - 1])`，也就是**前綴積**乘**後綴積**（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 的乘法版）。第一輪從左往右，`res[i]` 先存左邊的乘積（**不含** `nums[i]`）；第二輪從右往左用一個變數 `right` 乘上右邊的乘積。不用除法，也就不用處理 0。

## 我的嘗試

- 2022-10 的第一版有變數問題（UnboundLocalError）。
- 第二版第二輪寫成 `range(len(nums), -1)`，**這個 range 是空的**，後綴積完全沒乘；而且前綴積寫成 `res[i - 1] * nums[i]`，**把自己也乘進去了**：`[1, 3]` 回傳 `[1, 3]`，答案 `[3, 1]`。
- 修好 range 之後前綴積還是包含自己，回傳 `[3, 3]`。改成 `nums[i - 1]` 就對了，但留著 `print` 造成 Output Limit Exceeded，拿掉才 AC。

## 正確解法

```python
class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        n = len(nums)
        res = [1] * n
        left = 1
        for i in range(n):
            res[i] = left
            left *= nums[i]
        right = 1
        for i in range(n - 1, -1, -1):
            res[i] *= right
            right *= nums[i]
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 前綴積不能包含自己：`res[i] = res[i - 1] * nums[i - 1]`，不是 `nums[i]`。
- 倒著跑的 `range` 要寫 `range(n - 1, -1, -1)`，`range(n, -1)` 是空的。
- 不能用除法，陣列裡可能有 0。

## 面試口說整理

每個答案是左邊所有數的乘積乘上右邊所有數的乘積。我第一輪從左往右把左邊的乘積放進答案，第二輪從右往左用一個變數乘上右邊的乘積，不用除法，額外空間 `O(1)`。
