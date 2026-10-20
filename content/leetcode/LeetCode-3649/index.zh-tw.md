---
title: "LeetCode 3649: Number of Perfect Pairs"
summary: "LeetCode 3649 解題筆記：把條件化簡成「較大的絕對值 <= 2 × 較小的絕對值」，排序絕對值後用雙指針計數"
description: "2025-08-16 的 LeetCode 3649 解題紀錄"
date: 2025-08-16
tags: ["medium", "two-pointers", "math", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-16
- 提交紀錄：Accepted（一次通過）

## 解題思路

這題的關鍵是先把條件化簡。設 `x = min(|a|, |b|)`、`y = max(|a|, |b|)`：

- 不管 `a`、`b` 的正負號，`{|a - b|, |a + b|}` 一定是 `{y - x, y + x}`：同號時相減會抵消，異號時相加會抵消。
- 第一個條件：`min = y - x <= x`，也就是 **`y <= 2x`**。
- 第二個條件：`max = y + x >= y`，**永遠成立**。

所以只要數「較大的絕對值 `<=` 2 × 較小的絕對值」的配對數，跟原本的正負號、位置都無關。

把絕對值排序後，對每個 `right`，找最左邊滿足 `2 * arr[left] >= arr[right]` 的 `left`，`[left, right)` 裡每個都能跟 `arr[right]` 配對。`right` 變大時，`left` 只會往右，所以是同向雙指針。

## 我的解法

```python
class Solution:
    def perfectPairs(self, nums: List[int]) -> int:
        arr = sorted(abs(x) for x in nums)
        ans = left = 0
        for right, y in enumerate(arr):
            while 2 * arr[left] < y:
                left += 1
            ans += right - left            # arr[left..right-1] 都能跟 y 配對
        return ans
```

`left` 最多走到 `right`（`2y >= y`），所以不會越界。

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 直接照原條件 `O(n^2)` 枚舉：`n` 到 `10^5` 會超時。
- 化簡時漏掉正負號的兩種情況。

## 面試口說整理

我先化簡條件：設兩個數的絕對值是 `x <= y`，`|a - b|` 和 `|a + b|` 一定是 `y - x` 和 `y + x`，所以第二個條件永遠成立，第一個條件變成 `y <= 2x`。接著把絕對值排序，對每個右端用一個只會往右走的左指針，找到第一個 `2 * arr[left] >= arr[right]` 的位置，中間的都能配對。時間 `O(n log n)`。
