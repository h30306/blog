---
title: "LeetCode 283: Move Zeroes"
summary: "LeetCode 283 解題筆記：寫入指標只在遇到非零數時前進，跟它交換；零自然被推到後面"
description: "2022-08-23 的 LeetCode 283 解題紀錄"
date: 2022-08-23
tags: ["easy", "array", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Accepted ×2 → Wrong Answer ×2 → Accepted ×2

## 解題思路

`left` 是下一個非零數要放的位置（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板五）。掃到非零的 `nums[right]` 就跟 `nums[left]` 交換，`left += 1`。非零數的相對順序保持不變，零都被換到後面。

## 我的嘗試

2022 年就 AC 了；2025 年重寫時把 `left += 1` 寫在 `if` 外面，每一步都前進，等於沒有移動，例如 `[0, 1]` 還是 `[0, 1]`。

## 正確解法

```python
class Solution:
    def moveZeroes(self, nums: List[int]) -> None:
        left = 0
        for right in range(len(nums)):
            if nums[right] != 0:
                nums[left], nums[right] = nums[right], nums[left]
                left += 1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `left += 1` 要放在 `if` 裡面，只有寫入非零數時才前進。

## 面試口說整理

我用 `left` 記下一個非零數要放的位置，遇到非零數就跟它交換並前進，零就會被擠到後面。時間 `O(n)`、空間 `O(1)`。
