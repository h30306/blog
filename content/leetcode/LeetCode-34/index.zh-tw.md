---
title: "LeetCode 34: Find First and Last Position of Element in Sorted Array"
summary: "LeetCode 34 解題筆記：做兩次 lower bound：第一個 >= target 的位置，以及第一個 >= target + 1 的位置減一"
description: "2022-10-21 的 LeetCode 34 解題紀錄"
date: 2022-10-21
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-21
- 提交紀錄：Time Limit Exceeded ×5 → Runtime Error ×2 → Wrong Answer ×3 → Runtime Error → Wrong Answer ×2 → Accepted ×4 → Wrong Answer → Accepted ×2

## 解題思路

兩個邊界都可以用同一個 lower bound 函式（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一）：

- 開頭：第一個 `>= target` 的位置。
- 結尾：第一個 `>= target + 1` 的位置再減一。

開頭超出範圍或那個位置不是 `target`，就代表不存在。

## 我的嘗試

這題 2022 年提交了 20 次：

- 前幾版用 `while l < r` 加上 `l = mid` / `r = mid`，區間縮不動，無限迴圈（TLE）。
- 改好迴圈之後，最後用 `start < end` 判斷有沒有找到：**只出現一次時開頭等於結尾**，被當成不存在。例如 `[1]`、`target = 1`：答案 `[0, 0]`，回傳 `[-1, -1]`；有一版結尾用了 `low` 而不是 `high`，回傳 `[0, 1]`。

## 正確解法

```python
class Solution:
    def searchRange(self, nums: List[int], target: int) -> List[int]:
        def lower(x):
            l, r = 0, len(nums)
            while l < r:
                mid = (l + r) // 2
                if nums[mid] < x:
                    l = mid + 1
                else:
                    r = mid
            return l
        start = lower(target)
        if start == len(nums) or nums[start] != target:
            return [-1, -1]
        return [start, lower(target + 1) - 1]
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只有一個元素時開頭和結尾一樣，不能用 `start < end` 判斷存不存在。
- 找到之後不要停，要繼續往左（或往右）縮。

## 面試口說整理

我寫一個 lower bound，找第一個不小於目標的位置當開頭，再找第一個不小於目標加一的位置減一當結尾；開頭不是目標就回傳 `[-1, -1]`。兩次二分，時間 `O(log n)`。
