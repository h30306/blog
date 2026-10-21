---
title: "LeetCode 324: Wiggle Sort II"
summary: "LeetCode 324 解題筆記：排序後分成小的一半和大的一半，各自反轉後交錯放：小的放偶數位置、大的放奇數位置"
description: "2022-11-17 的 LeetCode 324 解題紀錄"
date: 2022-11-17
tags: ["medium", "array", "divide-and-conquer", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-17
- 提交紀錄：Wrong Answer → Runtime Error → Accepted → Wrong Answer

## 解題思路

`nums[0] < nums[1] > nums[2] < ...`：偶數位置放小的、奇數位置放大的。排序後前半（較小的 `ceil(n / 2)` 個）放偶數位置、後半放奇數位置，但**兩半都要反轉**：如果照遞增順序放，小半的最後一個和大半的第一個可能相等（中位數重複時），而它們剛好會相鄰。反轉之後，相等的中位數會被放在兩端，不會碰在一起。進階要求 `O(n)` 時間、`O(1)` 空間，要用 quickselect 找中位數加上 3-way partition 和虛擬 index。

## 我的嘗試

第一版照遞增順序直接交錯放，**重複的中位數碰在一起**：`[2, 4, 1, 2]` 排序後是 `[1, 2, 2, 4]`，放完變成 `[1, 2, 2, 4]`，`2` 和 `2` 相鄰不符合。改成兩半都反轉，中間有一次切片的範圍算錯（ValueError），之後就 AC 了。

## 正確解法

```python
class Solution:
    def wiggleSort(self, nums: List[int]) -> None:
        s = sorted(nums)
        half = (len(nums) + 1) // 2
        nums[::2] = s[:half][::-1]
        nums[1::2] = s[half:][::-1]
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 兩半都要反轉，不然重複的中位數會相鄰。
- 小的一半是 `ceil(n / 2)` 個，放在偶數位置。

## 面試口說整理

我排序後把較小的一半放偶數位置、較大的一半放奇數位置，兩半都反轉，這樣重複的中位數會被分到兩端，不會相鄰。時間 `O(n log n)`；進階的 `O(n)` 要用 quickselect 找中位數再做三向分割。
