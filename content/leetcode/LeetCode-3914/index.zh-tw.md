---
title: "LeetCode 3914: Minimum Operations to Make Array Non Decreasing"
summary: "LeetCode 3914 解題筆記：對區間加 x 只會讓左邊界的差值變大 x，所以答案是所有下降量的總和"
description: "2026-04-26 的 LeetCode 3914 解題紀錄"
date: 2026-04-26
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
第一次嘗試：2026-04-26
- 提交紀錄：Accepted（一次通過）

## 解題思路

看相鄰差值 `d[i] = nums[i] - nums[i - 1]`，目標是每個 `d[i] >= 0`。對 `[l, r]` 加 `x`：

- `d[l]` 變大 `x`（如果 `l > 0`）。
- `d[r + 1]` 變小 `x`（如果 `r + 1 < n`）。
- 中間的差值不變。

所以一次操作最多讓**一個**差值變大 `x`。每個下降 `nums[i - 1] - nums[i] > 0` 都至少要補那麼多，總和是下界。而對後綴 `[i, n - 1]` 加，剛好只補 `d[i]`、不弄壞別的，達到下界。這是 [Greedy]({{< relref "/algorithm/Greedy" >}}) 模板五。

## 我的解法

```python
class Solution:
    def minOperations(self, nums: List[int]) -> int:
        return sum(max(0, nums[i - 1] - nums[i]) for i in range(1, len(nums)))
```

我當時從右往左用 while 迴圈累加下降量，做的是同一件事。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 不需要真的模擬加法；只看相鄰差值就能算出答案。

## 面試口說整理

對一段區間加 `x`，只會讓它左邊界的差值變大 `x`，所以每個下降至少要花它的大小。對後綴加剛好只補一個下降，所以答案就是所有下降量的總和。時間 `O(n)`。
