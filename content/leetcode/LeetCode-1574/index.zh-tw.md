---
title: "LeetCode 1574: Shortest Subarray to be Removed to Make Array Sorted"
summary: "LeetCode 1574 解題筆記：留下來的一定是「非遞減前綴 + 非遞減後綴」；先找出最長前綴和後綴，再用雙指針把兩段接起來"
description: "2026-01-25 的 LeetCode 1574 解題紀錄"
date: 2026-01-25
tags: ["medium", "two-pointers", "binary-search", "array", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

刪掉一段連續子陣列後，留下來的是**一段前綴 + 一段後綴**，兩段都要非遞減，而且接起來也要非遞減。

1. 從左邊找最長的非遞減前綴 `arr[0..left]`。如果整個陣列都是，答案是 0。
2. 從右邊找最長的非遞減後綴 `arr[right..n-1]`。
3. 三種留法：
   - 只留前綴：刪掉 `n - left - 1` 個。
   - 只留後綴：刪掉 `right` 個。
   - 前綴取到 `i`、後綴從 `j` 開始，要 `arr[i] <= arr[j]`，刪掉 `j - i - 1` 個。

第三種用同向雙指針：`i` 從 0 走到 `left`，`j` 從 `right` 開始。`arr[i] <= arr[j]` 就更新答案、`i` 往右（試試保留更長的前綴）；否則 `j` 往右（後綴的值更大）。因為 `arr[i]` 越來越大，能接的 `j` 也只會往右，兩個指針都不用回頭。

## 我的解法

```python
class Solution:
    def findLengthOfShortestSubarray(self, arr: List[int]) -> int:
        n = len(arr)
        left = 0
        while left + 1 < n and arr[left] <= arr[left + 1]:
            left += 1
        if left == n - 1:
            return 0                               # 已經排好

        right = n - 1
        while right > 0 and arr[right - 1] <= arr[right]:
            right -= 1

        ans = min(n - left - 1, right)             # 只留前綴 / 只留後綴
        i, j = 0, right
        while i <= left and j < n:
            if arr[i] <= arr[j]:
                ans = min(ans, j - i - 1)          # 前綴到 i、後綴從 j
                i += 1
            else:
                j += 1
        return ans
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 忘了「只留前綴」和「只留後綴」這兩種情況。
- 接合處的條件是 `arr[i] <= arr[j]`（非遞減），不是 `<`。

## 面試口說整理

刪掉一段之後留下的是前綴加後綴，所以我先找出最長的非遞減前綴和後綴。答案先取「只留前綴」和「只留後綴」的較小值，再用兩個同向指針嘗試把前綴的 `i` 接到後綴的 `j`：`arr[i] <= arr[j]` 就更新答案並讓 `i` 前進，否則 `j` 前進。兩個指針都不回頭，時間 `O(n)`。
