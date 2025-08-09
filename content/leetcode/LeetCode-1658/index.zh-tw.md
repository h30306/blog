---
title: "LeetCode 1658: Minimum Operations to Reduce X to Zero"
summary: "LeetCode 解題紀錄 - 反向思考與滑動窗口"
description: "LeetCode Daily - 使用反向方法尋找將X減少到零的最小操作數"
date: 2025-08-03
tags: ["LeetCode", "daily", "medium", "sliding window", "array", "reverse thinking", "prefix sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-08-03
- 總花費時間：00:00.00

## 解題思路

我們可以通過反向思考來解決這個問題。與其尋找將 `x` 減少到零的最小操作數，我們可以尋找總和等於 `sum(nums) - x` 的最大子陣列長度。這是因為如果我們從兩端移除元素來將 `x` 減少到零，剩餘的元素總和必須等於 `sum(nums) - x`。所需的最小操作數將是 `len(nums) - max_subarray_length`。

## 解法

### 反向思考與滑動窗口
```python
class Solution:
    def minOperations(self, nums: List[int], x: int) -> int:
        
        target_sum = sum(nums) - x

        # 處理邊界情況
        if target_sum < 0:
            return -1
        if target_sum == 0:
            return len(nums)
    
        max_len = 0
        left = sum_now = 0

        # 尋找總和等於 target_sum 的最大子陣列
        for right in range(len(nums)):
            sum_now += nums[right]

            # 如果總和超過目標，則縮小窗口
            while sum_now > target_sum:
                sum_now -= nums[left]
                left += 1
            
            # 如果總和等於目標，則更新最大長度
            if sum_now == target_sum:
                max_len = max(max_len, right - left + 1)

        return len(nums) - max_len if max_len != 0 else -1
```

## 演算法分析

### 時間複雜度
- **時間**: O(n)，其中 n 是輸入陣列的長度
- **空間**: O(1)，因為我們只使用常數量的額外空間

### 關鍵洞察
1. **反向思考**: 將問題轉換為尋找具有特定總和的最大子陣列
2. **滑動窗口**: 使用滑動窗口尋找具有目標總和的最長子陣列
3. **邊界情況處理**: 處理目標總和為負數或零的情況

## 收穫

1. **反向問題轉換**: 這道題展示了如何通過反向思考來簡化解決方案。與其尋找最小操作數，我們尋找最大子陣列長度。

2. **滑動窗口應用**: 轉換後的問題成為經典的滑動窗口問題 - 尋找具有特定總和的最長子陣列。

3. **目標總和計算**: 關鍵洞察是 `target_sum = sum(nums) - x` 代表我們想要保留在中間的元素總和。

4. **窗口管理**: 我們維持一個滑動窗口，並根據當前總和是否等於、超過或小於目標總和來調整其大小。

5. **邊界情況處理**: 我們需要處理幾個邊界情況：當目標總和為負數（不可能）、當目標總和為零（移除所有元素）、以及當找不到有效子陣列時。

6. **結果計算**: 最終結果是 `len(nums) - max_len`，代表我們需要從兩端移除的元素數量。

7. **單次遍歷解決方案**: 解決方案只需要遍歷陣列一次，對於大型輸入非常高效。

8. **記憶體效率**: O(1) 空間複雜度使這個解決方案非常記憶體高效，因為我們只需要幾個變數來追蹤當前狀態。

## 遇到的問題

1. **初始方法困惑**: 我最初嘗試通過直接從兩端移除元素來解決這個問題，這很複雜且效率低下。關鍵洞察是反向思考方法。

2. **目標總和理解**: 理解 `target_sum = sum(nums) - x` 至關重要。我必須仔細思考這在原始問題的上下文中代表什麼。

3. **邊界情況管理**: 我必須處理多個邊界情況：負數目標總和、零目標總和，以及不存在有效子陣列的情況。
