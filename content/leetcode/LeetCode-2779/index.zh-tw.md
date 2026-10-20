---
title: "LeetCode 2779: Maximum Beauty of an Array After Applying Operation"
summary: "LeetCode 2779 解題筆記：每個數可以變成 [x - k, x + k] 裡的任何值，一群數能變成同一個值 ⇔ 最大 - 最小 <= 2k；排序後找最長的這種視窗"
description: "2026-01-11 的 LeetCode 2779 解題紀錄"
date: 2026-01-11
tags: ["medium", "sliding-window", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-11
- 提交紀錄：Time Limit Exceeded → Accepted

## 解題思路

每個數 `x` 可以變成區間 `[x - k, x + k]` 裡的任何值。一群數能變成同一個值 ⇔ 它們的區間有共同交集 ⇔ **最大值 − 最小值 `<= 2k`**。

題目要的是子序列（不用連續），所以先排序，問題變成「排序後 `nums[right] - nums[left] <= 2k` 的最長視窗」。

## 我的嘗試

第一版對每個數，把 `[x - k, x + k]` 裡的每個整數都計數一次，再取最大值，時間 `O(n · k)`，`k` 到 `10^5` 時 TLE。

（這個想法本身可以用差分陣列做到 `O(n + 值域)`，但排序 + 滑動視窗更直接。）

## 正確解法

```python
class Solution:
    def maximumBeauty(self, nums: List[int], k: int) -> int:
        nums.sort()
        left = best = 0
        for right, x in enumerate(nums):
            while x - nums[left] > 2 * k:
                left += 1
            best = max(best, right - left + 1)
        return best
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 把每個區間裡的整數都計數：`O(n · k)`。
- 條件是 `2k`，不是 `k`：兩邊各可以往中間移 `k`。

## 面試口說整理

每個數可以變成它加減 `k` 範圍內的任何值，一群數能變成同一個值，代表最大減最小不超過 `2k`。題目要的是子序列，所以先排序，再用滑動視窗找最大減最小 `<= 2k` 的最長一段。時間 `O(n log n)`。
