---
title: "LeetCode 153: Find Minimum in Rotated Sorted Array"
summary: "LeetCode 153 解題筆記：拿 mid 跟右端比：nums[mid] > nums[r] 代表最小值在右邊，否則 mid 可能就是最小值，r = mid"
description: "2022-10-28 的 LeetCode 153 解題紀錄"
date: 2022-10-28
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
第一次嘗試：2022-10-28
- 提交紀錄：Wrong Answer → Accepted ×2 → Wrong Answer ×6 → Accepted → Wrong Answer ×2 → Accepted ×4

## 解題思路

最小值是旋轉的斷點。拿 `nums[mid]` 跟 `nums[r]` 比（[Binary Search]({{< relref "/algorithm/Binary-Search" >}})）：

- `nums[mid] > nums[r]`：斷點在 `mid` 右邊，`l = mid + 1`。
- 否則 `[mid, r]` 是遞增的，最小值在 `mid` 或它的左邊，`r = mid`。

用 `while l < r`，最後 `l == r` 就是最小值。跟右端比比較不會錯：跟左端比時，沒有旋轉的陣列要另外處理。

## 我的嘗試

前面 9 次 WA 都是拿 `nums[mid]` 跟**左端**比，條件組合不完整，只有兩個元素的旋轉陣列就錯了，例如 `[5, 4]` 回傳 5。改成跟右端比就簡單多了。

## 正確解法

```python
class Solution:
    def findMin(self, nums: List[int]) -> int:
        l, r = 0, len(nums) - 1
        while l < r:
            mid = (l + r) // 2
            if nums[mid] > nums[r]:
                l = mid + 1
            else:
                r = mid
        return nums[l]
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `r = mid` 不是 `mid - 1`：`mid` 本身可能就是最小值。

## 面試口說整理

最小值是斷點，所以我拿中間跟右端比：中間比較大代表斷點在右邊，否則最小值在中間或左邊，把右界縮到中間。最後左右界相遇的位置就是最小值。時間 `O(log n)`。
