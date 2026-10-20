---
title: "LeetCode 976: Largest Perimeter Triangle"
summary: "LeetCode 976 解題筆記：排序後，從最大的開始看連續的三條邊，a + b > c 第一次成立就是最大周長"
description: "2026-01-29 的 LeetCode 976 解題紀錄"
date: 2026-01-29
tags: ["easy", "math", "greedy", "sorting", "geometry", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-29
- 提交紀錄：Wrong Answer → Time Limit Exceeded → Accepted ×3

## 解題思路

排序後，三條邊 `a <= b <= c` 能組成三角形 ⇔ `a + b > c`。

固定最長邊 `c = nums[i]` 時，最好的另外兩條邊是**緊鄰在它前面的兩條** `nums[i - 1]`、`nums[i - 2]`：它們是比 `c` 小的裡面最大的，和最大，最可能 `> c`，周長也最大。如果連它們都不行，換更小的也不行，只能把最長邊往下換。

所以從最大的開始，看連續的三條邊，第一個成立的就是答案。

## 我的嘗試

前兩版想用兩個指針分別管「最長邊」和「另外兩條邊」，指針移動的邏輯寫亂了：

- 第一版會算出不是三角形的組合。例如 `[1, 1, 3, 4]`：沒有任何三條能組成三角形，答案是 0，回傳 3。
- 第二版改了條件，但有些情況指針都不動，例如 `[8, 8, 1, 7]` 會無窮迴圈，TLE。

想清楚「最長邊固定時，配最大的兩條就好」之後，只要一個迴圈。

## 正確解法

```python
class Solution:
    def largestPerimeter(self, nums: List[int]) -> int:
        nums.sort()
        for i in range(len(nums) - 1, 1, -1):
            if nums[i - 2] + nums[i - 1] > nums[i]:
                return nums[i - 2] + nums[i - 1] + nums[i]
        return 0
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 三角不等式是嚴格大於。
- 不需要雙指針：最長邊固定時，緊鄰的兩條一定最好。

## 面試口說整理

排序後，最長邊固定時，最好的另外兩條就是緊鄰在它前面的兩條，因為它們的和最大。所以我從最大的開始看連續的三條邊，第一個滿足 `a + b > c` 的就是最大周長，都不行就回傳 0。時間 `O(n log n)`。
