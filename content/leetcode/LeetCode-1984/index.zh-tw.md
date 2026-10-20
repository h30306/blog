---
title: "LeetCode 1984: Minimum Difference Between Highest and Lowest of K Scores"
summary: "LeetCode 1984 解題筆記：排序後選出的 k 個一定是連續的一段；固定長度 k 的視窗，差是兩端相減"
description: "2026-01-26 的 LeetCode 1984 解題紀錄"
date: 2026-01-26
tags: ["easy", "sliding-window", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-26
- 提交紀錄：Accepted ×2

## 解題思路

排序後，要讓最高和最低的差最小，選的 `k` 個一定是**連續的一段**：如果中間跳過了某個數，把最高或最低換成它只會讓差變小或不變。

長度 `k` 的固定視窗，差是 `nums[right] - nums[right - k + 1]`。

## 我的解法

```python
class Solution:
    def minimumDifference(self, nums: List[int], k: int) -> int:
        nums.sort()
        return min(nums[i + k - 1] - nums[i] for i in range(len(nums) - k + 1))
```

第一次 AC 的版本手動維護 `left`，還多了一個沒用到的 `min_num`；第二次直接用 `right - k + 1` 當左端，乾淨很多。

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 沒排序就找連續一段：題目是任選 `k` 個，不是連續的。

## 面試口說整理

排序後，最佳的 `k` 個一定是連續一段，因為跳過的數放進來不會讓差變大。所以我排序後用長度 `k` 的視窗，差就是兩端相減，取最小值。時間 `O(n log n)`。
