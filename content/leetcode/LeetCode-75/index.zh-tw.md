---
title: "LeetCode 75: Sort Colors"
summary: "LeetCode 75 解題筆記：荷蘭國旗：low 左邊都是 0、high 右邊都是 2；遇到 2 換到 high 之後不要前進，換過來的數還沒檢查"
description: "2022-10-26 的 LeetCode 75 解題紀錄"
date: 2022-10-26
tags: ["medium", "array", "two-pointers", "sorting", "quicksort"]
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
- 提交紀錄：Accepted ×2 → Runtime Error → Wrong Answer ×3 → Runtime Error ×5 → Wrong Answer → Accepted ×5

## 解題思路

三個指標（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）：`[0, low)` 是 0、`(high, n)` 是 2、`i` 是目前看的位置：

- `nums[i] == 0`：跟 `low` 交換，`low`、`i` 都前進（換過來的一定是 1）。
- `nums[i] == 2`：跟 `high` 交換，`high -= 1`，**`i` 不動**（換過來的還沒看過）。
- `nums[i] == 1`：`i` 前進。

## 我的嘗試

第一次 AC 的是先數 0、1、2 各有幾個再填回去（兩次掃描）。之後想練一次掃描，用 `for i in range(len(nums))` 寫，**跟 `high` 交換之後 `i` 還是會前進**，換過來的數沒有再檢查，例如 `[2, 1]` 沒有變；也有幾版變數名稱打錯。

## 正確解法

```python
class Solution:
    def sortColors(self, nums: List[int]) -> None:
        low, i, high = 0, 0, len(nums) - 1
        while i <= high:
            if nums[i] == 0:
                nums[low], nums[i] = nums[i], nums[low]
                low += 1
                i += 1
            elif nums[i] == 2:
                nums[high], nums[i] = nums[i], nums[high]
                high -= 1
            else:
                i += 1
```

## 複雜度

時間 `O(n)`，一次掃描，空間 `O(1)`。

## 要特別避免的錯誤

- 跟 `high` 交換之後 `i` 不能前進。
- 迴圈條件是 `i <= high`，不是 `i < n`。

## 面試口說整理

我用荷蘭國旗的三個指標：0 換到左邊、2 換到右邊。換到右邊之後換過來的數還沒看過，所以目前的指標不動。一次掃描，時間 `O(n)`。
