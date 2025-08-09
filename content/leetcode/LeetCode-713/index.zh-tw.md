---
title: "LeetCode 713: Subarray Product Less Than K"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-08-02
- 總花費時間：00:00.00

## 解題思路

這是一個滑動窗口（Sliding Window）的經典問題。目標是找到所有乘積小於 k 的連續子陣列數量。

關鍵思路：
1. 使用雙指針技巧，維護一個滑動窗口
2. 右指針不斷向右擴展，將新元素乘入乘積
3. 當乘積 >= k 時，左指針向右移動，縮小窗口
4. 每次右指針移動後，計算以右指針為結尾的所有有效子陣列數量

**為什麼這樣做是正確的？**
- 當窗口內乘積 < k 時，以右指針結尾的所有子陣列都滿足條件
- 子陣列數量 = right - left + 1
- 這包含了所有可能的子陣列：從 left 到 right 的每個位置開始的子陣列

## 解法

```python
class Solution:
    def numSubarrayProductLessThanK(self, nums: List[int], k: int) -> int:
        if k <= 1:
            return 0
        
        n = len(nums)
        count = left = 0
        product = 1
        
        for right in range(n):
            product *= nums[right]
            
            while product >= k and left <= right:
                product //= nums[left]
                left += 1
            
            count += right - left + 1
        
        return count
```

**時間複雜度：** O(n)，每個元素最多被訪問兩次
**空間複雜度：** O(1)，只使用常數額外空間

## 收穫

1. **滑動窗口的變形應用**：這題展示了非固定大小的滑動窗口，需要動態調整窗口大小
2. **乘積問題的處理**：當涉及乘積時，需要特別注意 0 和 1 的邊界情況
3. **子陣列計數技巧**：學會了如何高效計算滿足條件的子陣列數量
4. **雙指針的靈活運用**：理解了如何用雙指針維護動態窗口
5. **時間複雜度優化**：從 O(n²) 的暴力解法優化到 O(n) 的滑動窗口解法
6. **空間複雜度控制**：只使用常數額外空間，非常高效

## 遇到的問題