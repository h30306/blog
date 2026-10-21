---
title: "LeetCode 81: Search in Rotated Sorted Array II"
summary: "LeetCode 81 解題筆記：有重複值時 nums[l] == nums[mid] 會分不出哪一半有序，這時只能把 l 往右移一格；最壞 O(n)"
description: "2022-10-26 的 LeetCode 81 解題紀錄"
date: 2022-10-26
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
第一次嘗試：2022-10-26
- 提交紀錄：Accepted → Wrong Answer ×8 → Accepted → Wrong Answer → Accepted ×2 → Wrong Answer ×3 → Accepted → Wrong Answer → Accepted

## 解題思路

跟 LC 33 一樣判斷哪一半有序，但多了重複值（[Binary Search]({{< relref "/algorithm/Binary-Search" >}})）。`nums[l] == nums[mid]` 時，例如 `[1, 1, 1, 3, 1]`，分不出左半是不是有序，只能把 `l` 往右移一格再試。全部都一樣的時候會退化成 `O(n)`。

## 我的嘗試

這題 2022 年提交了 19 次，幾乎都是 WA：

- 一開始只用 `nums[r] >= target` / `nums[l] <= target` 決定方向，沒有先判斷哪一半有序，例如 `[2, 2, 3, 0]`、`target = 3` 回傳 `False`。
- 加上有序判斷後，**沒有處理 `nums[l] == nums[mid]`**，有重複值時判斷錯哪一半有序，例如 `[1, 2, 3, 1, 1, 1, 1]`、`target = 2` 回傳 `False`。
- 一版函式最後沒有回傳值，一版回傳了 `-1` 而不是 `False`。

## 正確解法

```python
class Solution:
    def search(self, nums: List[int], target: int) -> bool:
        l, r = 0, len(nums) - 1
        while l <= r:
            mid = (l + r) // 2
            if nums[mid] == target:
                return True
            if nums[l] == nums[mid]:                     # 分不出哪一半有序
                l += 1
            elif nums[l] < nums[mid]:                    # 左半有序
                if nums[l] <= target < nums[mid]:
                    r = mid - 1
                else:
                    l = mid + 1
            else:                                        # 右半有序
                if nums[mid] < target <= nums[r]:
                    l = mid + 1
                else:
                    r = mid - 1
        return False
```

## 複雜度

平均 `O(log n)`，最壞 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 重複值讓 `nums[l] == nums[mid]` 時無法判斷，只能縮一格。

## 面試口說整理

跟沒有重複時一樣先判斷哪一半有序，但 `nums[l]` 等於 `nums[mid]` 時分不出來，只能把左界往右移一格。平均 `O(log n)`，全部一樣時是 `O(n)`。
