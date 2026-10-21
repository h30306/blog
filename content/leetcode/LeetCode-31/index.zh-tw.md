---
title: "LeetCode 31: Next Permutation"
summary: "LeetCode 31 解題筆記：從右邊找第一個下降的位置 i，跟右邊比它大的最小值交換，再把 i 之後反轉；比較時要包含等於"
description: "2022-10-21 的 LeetCode 31 解題紀錄"
date: 2022-10-21
tags: ["medium", "array", "two-pointers"]
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
- 提交紀錄：Accepted → Runtime Error ×2 → Wrong Answer → Accepted ×2 → Wrong Answer → Accepted ×2 → Wrong Answer → Accepted ×2

## 解題思路

[Next Permutation]({{< relref "/algorithm/Next-Permutation" >}}) 的固定步驟：

1. 從右往左找第一個 `nums[i] < nums[i + 1]` 的位置 `i`。右邊 `i + 1..` 是非遞增的，已經是最大的排列了。
2. 找不到（整個非遞增）就整個反轉，變成最小的排列。
3. 從右往左找第一個 `nums[j] > nums[i]`，交換 `i`、`j`。
4. 把 `i + 1` 之後反轉成遞增。

有重複值時，第 1、3 步的比較要用 `>=` / `<=` 跳過相等的。

## 我的嘗試

2022 年第一版的比較都用嚴格的 `<` / `>`，**有重複值時停在錯的位置**，例如 `[1, 3, 1]`：答案 `[3, 1, 1]`，回傳 `[1, 1, 3]`；另一版找交換對象時 `j` 往右走，超出範圍。2026 年重寫時一版反轉從 `i + 1` 開始，但我的 `i` 指的是下降位置的下一個，等於少反轉了一格，例如 `[2, 3, 3]`：答案 `[3, 2, 3]`，回傳 `[3, 3, 2]`。

## 正確解法

```python
class Solution:
    def nextPermutation(self, nums: List[int]) -> None:
        n = len(nums)
        i = n - 2
        while i >= 0 and nums[i] >= nums[i + 1]:
            i -= 1
        if i >= 0:
            j = n - 1
            while nums[j] <= nums[i]:
                j -= 1
            nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1:] = reversed(nums[i + 1:])
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 有重複值時比較要包含等於。
- 反轉的是 `i` **之後**的部分，從 `i + 1` 開始。

## 面試口說整理

我從右邊找第一個比右邊小的位置，跟右邊比它大的最小值交換，再把它後面反轉成遞增，就是下一個排列；找不到就整個反轉。時間 `O(n)`。
