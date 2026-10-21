---
title: "LeetCode 674: Longest Continuous Increasing Subsequence"
summary: "LeetCode 674 解題筆記：掃一次，嚴格遞增就延長目前的長度，否則重設成 1，迴圈結束後也要更新最大值"
description: "2022-08-30 的 LeetCode 674 解題紀錄"
date: 2022-08-30
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-30
- 提交紀錄：Wrong Answer ×2 → Runtime Error ×4 → Accepted ×2 → Wrong Answer ×2 → Accepted

## 解題思路

走過每一段嚴格遞增的連續段（[Array]({{< relref "/algorithm/Array" >}}) 模板一）：`nums[i] > nums[i - 1]` 就延長，否則從 1 重新開始。每一步都更新最大值，就不會漏掉最後一段。**不能排序**，題目要的是原本順序中連續的一段。

## 我的嘗試

這題提交了 11 次：

- 第一版**先排序**，連續遞增的順序就被破壞了，而且回傳的是一個 list。
- 改成計數後，一版比的是 `nums[i + 1]`，最後一個 index 超出範圍。
- 有兩版只在段落中斷時更新最大值，**迴圈結束時最後一段沒有算到**：`[0, 1]` 回傳 1，答案 2。迴圈後補一次 `max` 才 AC。

## 正確解法

```python
class Solution:
    def findLengthOfLCIS(self, nums: List[int]) -> int:
        best = cur = 1
        for i in range(1, len(nums)):
            cur = cur + 1 if nums[i] > nums[i - 1] else 1
            best = max(best, cur)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 不要排序。
- 只在段落中斷時更新最大值的話，迴圈結束後要再更新一次。
- 比較 `nums[i]` 和 `nums[i - 1]`，用 `nums[i + 1]` 會超出範圍。

## 面試口說整理

我掃一次，比前一個大就把目前的長度加一，否則重設成 1，每一步都更新最大值，這樣最後一段也會算到。時間 `O(n)`、空間 `O(1)`。
