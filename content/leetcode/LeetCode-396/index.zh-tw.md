---
title: "LeetCode 396: Rotate Function"
summary: "LeetCode 396 解題筆記：F(k) 和 F(k - 1) 只差一個公式：F(k) = F(k - 1) + sum - n × 被移到最前面的那個數"
description: "2022-11-16 的 LeetCode 396 解題紀錄"
date: 2022-11-16
tags: ["medium", "array", "math", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-16
- 提交紀錄：Time Limit Exceeded → Wrong Answer ×2 → Accepted

## 解題思路

每旋轉一次，除了最後一個元素以外，每個元素的係數都加 1，總共多了 `sum - nums[last]`；最後一個元素的係數從 `n - 1` 變成 0，少了 `(n - 1) × nums[last]`。合起來 `F(k) = F(k - 1) + sum - n × nums[n - k]`。先算 `F(0)`，再用這個遞推算出全部，`O(n)`（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 模板一）。

## 我的嘗試

- 2022 年第一版直接算每個旋轉的值，`O(n²)` TLE，而且 `range(len(nums) - 1)` 少算了一種旋轉。第二版的遞推公式沒有把結果累加回 `cur_sum`，每次都是從 `F(0)` 算。
- 2026 年重寫時，被移到最前面的 index 寫成固定從 `3` 開始（**照著範例的長度寫死了**），換一個長度就錯；改成 `range(n - 1, 0, -1)` 才 AC。

## 正確解法

```python
class Solution:
    def maxRotateFunction(self, nums: List[int]) -> int:
        n, total = len(nums), sum(nums)
        cur = best = sum(i * x for i, x in enumerate(nums))
        for k in range(1, n):
            cur += total - n * nums[n - k]
            best = max(best, cur)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 每次旋轉移到最前面的是 `nums[n - k]`，index 要跟著 `k` 變。
- 直接算每個旋轉是 `O(n²)`，會 TLE。

## 面試口說整理

每旋轉一次，除了被移到最前面的那個數，其他數的係數都加一，所以 F(k) 等於 F(k - 1) 加上總和、再減掉 n 乘上被移到最前面的數。我先算 F(0)，再用遞推算出所有旋轉的值取最大。時間 `O(n)`。
