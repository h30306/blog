---
title: "LeetCode 3796: Find Maximum Value in a Constrained Sequence"
summary: "LeetCode 3796 解題筆記：每個位置的上界是自己的限制、左邊上界 + 差值、右邊上界 + 差值三者取最小；左右各掃一次"
description: "2026-01-03 的 LeetCode 3796 解題紀錄"
date: 2026-01-03
tags: ["medium", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-03
- 提交紀錄：Wrong Answer ×2 → Accepted（2026-01-04）

## 解題思路

令 `ub[i]` 是 `a[i]` 可能的最大值。它受到三個限制：

- 自己的 `restrictions`（`a[0]` 固定是 0）。
- 左邊：`a[i] <= a[i - 1] + diff[i - 1]`，所以 `ub[i] <= ub[i - 1] + diff[i - 1]`。
- 右邊：同理 `ub[i] <= ub[i + 1] + diff[i]`。

先左往右傳一次，再右往左傳一次（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板三）。傳完之後相鄰的 `ub` 差距都不超過 `diff`，所以 `ub` 本身就是一個合法的序列，每個位置同時取到上界，答案是 `max(ub)`。

## 我的嘗試

我一開始想在每兩個限制點之間，用二分找出左右兩條斜坡的交叉點。

1. **第一版**沒有把限制往外傳：最後一段直接拿「最後一個限制值 + 後面的差值」，沒檢查從 `a[0] = 0` 走不走得到。例如 `n = 2`、`restrictions = [[1, 3]]`、`diff = [0]`：`a[1]` 只能是 0，這版回傳 3。
2. **第二版**先左右傳遞了限制值，但二分找到「左邊斜坡第一次比右邊高」的位置後回傳 `r - 1`，**只檢查交叉點的前一格**。例如 `n = 4`、`restrictions = [[3, 1]]`、`diff = [3, 3, 3]`：最佳是 `[0, 3, 4, 1]`，最大值 4 就在交叉那一格，這版回傳 3。
3. 改成直接對每個位置算上界、左右各傳一次，就 AC 了，也不用二分。

## 正確解法

```python
class Solution:
    def findMaxVal(self, n: int, restrictions: List[List[int]], diff: List[int]) -> int:
        ub = [inf] * n
        ub[0] = 0
        for idx, cap in restrictions:
            ub[idx] = min(ub[idx], cap)
        for i in range(n - 1):                     # 左邊傳過來
            ub[i + 1] = min(ub[i + 1], ub[i] + diff[i])
        for i in range(n - 2, -1, -1):             # 右邊傳過來
            ub[i] = min(ub[i], ub[i + 1] + diff[i])
        return max(ub)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 限制要往兩邊傳，不能只看相鄰的兩個限制點。
- 兩段斜坡的最高點可能就在交叉的那一格，不要只看前一格。

## 面試口說整理

每個位置的最大可能值受自己的限制和左右鄰居限制。我先把限制填進上界陣列，左往右傳一次、右往左傳一次，傳完之後相鄰差距都合法，所以上界本身就能同時達到，答案是上界的最大值。時間 `O(n)`。
