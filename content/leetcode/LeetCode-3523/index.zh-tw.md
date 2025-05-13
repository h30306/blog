---
title: "LeetCode 3523: Make Array Non-decreasing"
summary: "LeetCode 解題紀錄"
description: "LeetCode Weekly"
date: 2025-04-20
series: ["LeetCode Weekly Contest 446"]
series_order: 2
tags: ["LeetCode", "weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-20
- 總花費時間：22:00.00

## 解題思路

根據題目描述，我們需要讓陣列變成**不遞減序列**。  
也就是說，從左到右遍歷時，如果遇到某個數字小於之前遇過的最大值，就必須將它「移除」或「修正」。  
因此，我們可以遍歷整個陣列，統計需要被移除的元素數量。  
最後的陣列大小就是原本長度減去需要移除的元素數量。

## 解法

```python
class Solution:
    def maximumPossibleSize(self, nums: List[int]) -> int:
        i = 0
        n = len(nums)
        change_count = 0
        
        while i < n - 1:
            if nums[i] > nums[i + 1]:
                change_count += 1
                nums[i + 1] = nums[i]
            i += 1
            
        return n - change_count
```
### 不需要修改陣列

我們不需要修改 `nums[i]`；  
只需要記錄當前的最大值 `prev_max`。

```python
class Solution:
    def maximumPossibleSize(self, nums: List[int]) -> int:
        ans = 0
        prev_max = 0
        
        for n in nums:
            if n>=prev_max:
                ans += 1
                prev_max = n
            
        return ans
```

## 收穫

NA

## 遇到的問題

NA