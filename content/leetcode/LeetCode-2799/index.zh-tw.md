---
title: "LeetCode 2799: Count Complete Subarrays in an Array"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-24
tags: ["LeetCode", "daily", "medium", "sliding window"]

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
第二次嘗試： 2025-07-01
- 總花費時間：10:00.00

## 解題思路

這題的陣列長度相對較小，  
所以可以直接使用暴力法，雙層遍歷陣列來統計符合條件的子陣列數量。  
不過有一個更優化的方法：  
當我們從起始索引遍歷到結尾索引時，  
一旦目前的子陣列已經符合「完整子陣列」的條件，  
就可以立刻停止內層迴圈，並直接統計從當前結尾索引到陣列末尾的所有子陣列數量。  
這樣可以有效避免 TLE（超時）問題。

另外還有一種使用滑動窗口的方法，我們可以用雜湊表記錄每個元素的出現次數，當不同元素的數量與原陣列中不同元素的數量相符時，就表示這個子陣列符合完整子陣列的條件。在找到最小的完整子陣列後，從右邊索引到陣列末尾的所有子陣列也都是完整子陣列，因此我們可以計算數量並繼續遍歷。

## 解法

### 方法一：優化暴力法
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

### 方法二：滑動窗口
```python
class Solution:
    def countCompleteSubarrays(self, nums):
        distinct_elements = set(nums)
        total_distinct = len(distinct_elements)
        count = 0
        n = len(nums)
        
        # 使用滑動窗口和雙指針
        left = 0
        element_count = {}
        
        for right in range(n):
            # 將當前元素加入計數
            element_count[nums[right]] = element_count.get(nums[right], 0) + 1
            
            # 當我們擁有所有不同元素時，嘗試最小化窗口
            while len(element_count) == total_distinct:
                # 從 left 到 right（包含）到末尾的所有子陣列都是完整的
                count += (n - right)
                
                # 移除最左邊的元素
                element_count[nums[left]] -= 1
                if element_count[nums[left]] == 0:
                    del element_count[nums[left]]
                left += 1
                
        return count
```

## 收穫

NA

## 遇到的問題

NA