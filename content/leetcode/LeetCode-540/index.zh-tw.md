---
title: "LeetCode 540: Single Element in a Sorted Array"
summary: "LeetCode 540 解題筆記：單獨的那個出現之前，每一對都從偶數 index 開始；二分看偶數位置 mid 和 mid + 1 是否相同"
description: "2022-11-27 的 LeetCode 540 解題紀錄"
date: 2022-11-27
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
第一次嘗試：2022-11-27
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

在單獨的元素之前，每一對的第一個都在**偶數** index；在它之後，每一對的第一個都在奇數 index（[Binary Search]({{< relref "/algorithm/Binary-Search" >}})）。把 `mid` 調成偶數，看 `nums[mid] == nums[mid + 1]`：

- 相等：前面都是完整的對，答案在右邊，`l = mid + 2`。
- 不相等：答案在 `mid` 或左邊，`r = mid`。

## 我的嘗試

我當時是每兩個一組掃過去（`O(n)`，題目要求 `O(log n)`）。前兩版沒處理「單獨的在最後一個」：迴圈跑完沒有回傳值，例如 `[7, 7, 8]` 回傳 `None`，答案 8；只有一個元素 `[3]` 時也一樣。

## 正確解法

```python
class Solution:
    def singleNonDuplicate(self, nums: List[int]) -> int:
        l, r = 0, len(nums) - 1
        while l < r:
            mid = (l + r) // 2
            if mid % 2:
                mid -= 1                                # 調成偶數
            if nums[mid] == nums[mid + 1]:
                l = mid + 2
            else:
                r = mid
        return nums[l]
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 題目要求 `O(log n)`；每兩個一組掃過去是 `O(n)`。
- 單獨的那個在最後一個時，迴圈裡找不到，要另外回傳。

## 面試口說整理

單獨的元素前面每一對都從偶數位置開始，所以我把 `mid` 調成偶數，看它跟下一個是不是一樣：一樣代表答案在右邊，不一樣代表在 `mid` 或左邊。時間 `O(log n)`。
