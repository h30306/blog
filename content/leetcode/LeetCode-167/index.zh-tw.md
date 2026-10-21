---
title: "LeetCode 167: Two Sum II - Input Array Is Sorted"
summary: "LeetCode 167 解題筆記：已排序，左右指針往中間走：和太大右指針左移，太小左指針右移；回傳的 index 從 1 開始"
description: "2022-10-27 的 LeetCode 167 解題紀錄"
date: 2022-10-27
tags: ["medium", "array", "two-pointers", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-27
- 提交紀錄：Runtime Error ×2 → Wrong Answer → Runtime Error ×2 → Wrong Answer ×5 → Accepted → Wrong Answer ×3 → Accepted ×2 → Wrong Answer → Accepted

## 解題思路

陣列已排序（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）：左指針在最小、右指針在最大。和太大就讓右指針左移（換一個比較小的），太小就讓左指針右移。每一步排除一個不可能的數，`O(n)`。題目的 index 從 1 開始。

## 我的嘗試

2022 年提交了 18 次：

- 一開始兩個指標都從左邊開始，和太大時同時移動兩個，一直找不到答案或超出範圍，例如 `[2, 3, 5]`、`target = 8`。
- 改成從兩端開始之後，有一版和太小時寫成 `l -= 1`，方向反了，例如 `[1, 4]`、`target = 5` 找不到。2026 年重寫時則是忘了 index 從 1 開始，回傳了 `[0, 1]`。

## 正確解法

```python
class Solution:
    def twoSum(self, numbers: List[int], target: int) -> List[int]:
        l, r = 0, len(numbers) - 1
        while l < r:
            s = numbers[l] + numbers[r]
            if s == target:
                return [l + 1, r + 1]
            if s > target:
                r -= 1
            else:
                l += 1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。也可以對每個數二分找另一半，`O(n log n)`。

## 要特別避免的錯誤

- 和太小時是左指針**往右**（`l += 1`），不是往左。
- 回傳的 index 要加 1。

## 面試口說整理

陣列已排序，我從兩端開始，和太大就把右邊往左移、太小就把左邊往右移，相等就回傳兩個從 1 開始的 index。時間 `O(n)`、空間 `O(1)`。
