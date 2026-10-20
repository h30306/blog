---
title: "LeetCode 2163: Minimum Difference in Sums After Removal of Elements"
summary: "LeetCode 2163 解題筆記：枚舉第一段和第二段的分界 k；左邊 nums[:k] 選 n 個最小的（最大堆維護），右邊 nums[k:] 選 n 個最大的（最小堆維護），前後綴各掃一次"
description: "2026-09-05 的 LeetCode 2163 解題紀錄"
date: 2026-09-05
tags: ["hard", "dynamic-programming", "heap", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-05
- 提交紀錄：Accepted（一次通過）

## 解題思路

刪掉 `n` 個之後，剩下的前 `n` 個是第一段、後 `n` 個是第二段。換個角度：**選一個分界 `k`**（`n <= k <= 2n`），第一段從 `nums[:k]` 裡選 `n` 個，第二段從 `nums[k:]` 裡選 `n` 個。

要讓 `sum_first - sum_second` 最小：

- 第一段選 `nums[:k]` 裡**最小的 `n` 個**：從左往右掃，用最大堆維護目前最小的 `n` 個，多了就把最大的丟掉。`left_min[k - 1]` = 前 `k` 個裡最小 `n` 個的和。
- 第二段選 `nums[k:]` 裡**最大的 `n` 個**：從右往左掃，用最小堆維護，多了就丟最小的。`right_max[k]` = 從 `k` 開始最大 `n` 個的和。

答案是 `min(left_min[k - 1] - right_max[k])`。

## 我的解法

```python
import heapq

class Solution:
    def minimumDifference(self, nums: List[int]) -> int:
        n = len(nums) // 3

        left_min = [0] * (3 * n)                   # left_min[i]：nums[:i+1] 最小 n 個的和
        heap, total = [], 0                        # 最大堆（存負數）
        for i in range(2 * n):
            heapq.heappush(heap, -nums[i])
            total += nums[i]
            if len(heap) > n:
                total += heapq.heappop(heap)       # 丟掉最大的（存的是負數）
            left_min[i] = total

        right_max = [0] * (3 * n)                  # right_max[i]：nums[i:] 最大 n 個的和
        heap, total = [], 0                        # 最小堆
        for i in range(3 * n - 1, n - 1, -1):
            heapq.heappush(heap, nums[i])
            total += nums[i]
            if len(heap) > n:
                total -= heapq.heappop(heap)       # 丟掉最小的
            right_max[i] = total

        return min(left_min[k - 1] - right_max[k] for k in range(n, 2 * n + 1))
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 分界的範圍是 `n` 到 `2n`：兩邊都要至少有 `n` 個可以選。
- Python 只有最小堆，最大堆要存負數，彈出來的值也是負的。

## 面試口說整理

刪掉 `n` 個之後，等於選一個分界，第一段從左邊選 `n` 個、第二段從右邊選 `n` 個。要差最小，左邊選最小的 `n` 個、右邊選最大的 `n` 個。我從左往右用最大堆算每個前綴的最小 `n` 個的和，從右往左用最小堆算每個後綴的最大 `n` 個的和，再枚舉分界。時間 `O(n log n)`。
