---
title: "LeetCode 42: Trapping Rain Water"
summary: "LeetCode 42 解題筆記：每格能存的水是 min(左邊最高, 右邊最高) - 自己的高度；用前後綴最大值或左右雙指針"
description: "2022-10-27 的 LeetCode 42 解題紀錄"
date: 2022-10-27
tags: ["hard", "array", "two-pointers", "dynamic-programming", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2022-10-27
- 提交紀錄：Wrong Answer ×6 → Runtime Error ×2 → Time Limit Exceeded → Wrong Answer → Accepted ×5

## 解題思路

第 `i` 格上方的水位由**兩邊最高的牆中比較矮的那一面**決定：`water[i] = min(leftMax[i], rightMax[i]) - height[i]`，`leftMax`、`rightMax` 包含自己，所以不會是負的。

- 前後綴最大值（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 模板六）：先算兩個陣列，`O(n)` 空間。
- 左右雙指針（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）：維護 `lmax`、`rmax`，哪一邊的最大值比較小，那一邊的水位就已經確定（另一邊一定有更高的牆），計算後往內移，`O(1)` 空間。

## 我的嘗試

這題在同一個晚上提交了 15 次：

- 前六版用一個「左牆、右牆」的掃描去找凹槽，遇到下降再上升時算面積，各種形狀都處理不好，連最簡單的 `[4, 3, 4]` 都回傳 0，答案 1。
- 接著改成每格都用 `max(height[:i])`、`max(height[i + 1:])` 算兩邊最高，答案對了但是 `O(n²)`，TLE。
- 改成前後綴最大值之後，第一版前綴的迴圈從 1 開始，**第 0 格的高度沒有算進最大值**：`[4, 3, 4]` 還是回傳 0。改從 0 開始就 AC 了，最後再換成雙指針版本。

## 正確解法

```python
class Solution:
    def trap(self, height: List[int]) -> int:
        l, r = 0, len(height) - 1
        lmax = rmax = water = 0
        while l < r:
            lmax = max(lmax, height[l])
            rmax = max(rmax, height[r])
            if lmax <= rmax:
                water += lmax - height[l]
                l += 1
            else:
                water += rmax - height[r]
                r -= 1
        return water
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用「找凹槽、算面積」的方式分情況，很難處理所有形狀；改成逐格算水位。
- 每格都重新掃左右的最大值是 `O(n²)`，會 TLE。
- 前綴最大值要從第 0 格開始算。

## 面試口說整理

每格能存的水是左邊最高和右邊最高中比較矮的那個減掉自己。我用左右雙指針，維護兩邊目前的最大值，比較小的那邊水位已經確定，算完就往內移。時間 `O(n)`、空間 `O(1)`。
