---
title: "LeetCode 1493: Longest Subarray of 1's After Deleting One Element"
summary: "LeetCode 1493 解題筆記：找「最多 1 個 0」的最長視窗，因為一定要刪一個元素，答案是視窗長度減 1"
description: "2025-08-24 的 LeetCode 1493 解題紀錄"
date: 2025-08-24
tags: ["medium", "sliding-window", "dynamic-programming", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-24
- 提交紀錄：Accepted ×2

## 解題思路

刪掉一個元素後全是 1 的子陣列，原本就是「**最多含一個 0**」的子陣列，刪掉的就是那個 0（沒有 0 的話隨便刪一個 1）。

所以找最多一個 0 的最長視窗，答案是**視窗長度 − 1**：

- 右邊界加入元素，0 的數量超過 1 就縮左邊界。
- 更新 `right - left`（也就是長度減 1）。

全是 1 的時候也一定要刪一個，答案是 `n - 1`，這個寫法自然涵蓋。

## 我的解法

```python
class Solution:
    def longestSubarray(self, nums: List[int]) -> int:
        left = zeros = best = 0
        for right, x in enumerate(nums):
            zeros += x == 0
            while zeros > 1:
                zeros -= nums[left] == 0
                left += 1
            best = max(best, right - left)         # 視窗長度 - 1
        return best
```

兩次 AC 的寫法差不多，第二次把 `while` 條件寫得比較乾淨（第一次多了一個 `nums[right] == 0` 的判斷）。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 回傳視窗長度而不是長度減 1：題目規定一定要刪一個。
- 全是 1 時答案是 `n - 1`，不是 `n`。

## 面試口說整理

刪掉一個元素後全是 1，代表原本的子陣列最多只有一個 0。我用滑動視窗找最多一個 0 的最長視窗，0 超過一個就縮左邊。因為一定要刪一個元素，答案是視窗長度減 1，全是 1 時也成立。時間 `O(n)`。
