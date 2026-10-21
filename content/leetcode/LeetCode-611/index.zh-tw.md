---
title: "LeetCode 611: Valid Triangle Number"
summary: "LeetCode 611 解題筆記：排序後固定最長邊 k，左右指針找兩短邊：和夠大時中間的都可以，一次加 j - i 個"
description: "2022-11-27 的 LeetCode 611 解題紀錄"
date: 2022-11-27
tags: ["medium", "array", "two-pointers", "binary-search", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-27
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

排序之後，三角形只要檢查兩短邊之和大於最長邊（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板四）。固定最長邊 `k`，`i` 從 0、`j` 從 `k - 1` 開始：

- `nums[i] + nums[j] > nums[k]`：`i` 換成 `i..j-1` 任何一個都會更大，一次加 `j - i` 個，`j` 左移。
- 否則 `i` 右移。

## 我的嘗試

第一版一次加的是 `j - 1`（打錯），例如 `[4, 7, 9]`：`i = 0`、`j = 1` 時應該加 1，這版加了 0，回傳 0。

## 正確解法

```python
class Solution:
    def triangleNumber(self, nums: List[int]) -> int:
        nums.sort()
        res = 0
        for k in range(2, len(nums)):
            i, j = 0, k - 1
            while i < j:
                if nums[i] + nums[j] > nums[k]:
                    res += j - i
                    j -= 1
                else:
                    i += 1
        return res
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 一次加的是 `j - i`，不是 `j - 1`。

## 面試口說整理

排序後我固定最長邊，用左右指針找兩短邊：和夠大時左指針換成中間任何一個都成立，一次加上 `j - i`，右指針左移；不夠就左指針右移。時間 `O(n²)`。
