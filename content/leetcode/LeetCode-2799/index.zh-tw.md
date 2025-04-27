---
title: "LeetCode 2799: Count Complete Subarrays in an Array"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-24
tags: ["LeetCode", "blog", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-24
- 總花費時間：15:00.00

## 解題思路

這題的陣列長度相對較小，  
所以可以直接使用暴力法，雙層遍歷陣列來統計符合條件的子陣列數量。  
不過有一個更優化的方法：  
當我們從起始索引遍歷到結尾索引時，  
一旦目前的子陣列已經符合「完整子陣列」的條件，  
就可以立刻停止內層迴圈，並直接統計從當前結尾索引到陣列末尾的所有子陣列數量。  
這樣可以有效避免 TLE（超時）問題。

## 解法

```python
class Solution:
    def countCompleteSubarrays(self, nums):
        distinct_elements = set(nums)
        total_distinct = len(distinct_elements)
        count = 0
        n = len(nums)
        
        for i in range(n):
            current_set = set()
            for j in range(i, n):
                current_set.add(nums[j])
                if len(current_set) == total_distinct:
                    count += (n - j)
                    break
        return count
```

## 收穫

NA

## 遇到的問題

NA