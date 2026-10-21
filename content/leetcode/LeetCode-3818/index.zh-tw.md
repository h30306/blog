---
title: "LeetCode 3818: Minimum Prefix Removal to Make Array Strictly Increasing"
summary: "LeetCode 3818 解題筆記：從右往左找最長的嚴格遞增後綴，它前面的都要刪"
description: "2026-01-25 的 LeetCode 3818 解題紀錄"
date: 2026-01-25
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

留下來的一定是一段後綴，而且要嚴格遞增。後綴越長、刪的前綴越短，所以從右往左走，只要 `nums[i - 1] < nums[i]` 就繼續（[Array]({{< relref "/algorithm/Array" >}}) 模板一）。停下來的位置 `i` 就是要刪的長度。

## 我的解法

```python
class Solution:
    def minimumPrefixLength(self, nums: List[int]) -> int:
        i = len(nums) - 1
        while i > 0 and nums[i - 1] < nums[i]:
            i -= 1
        return i
```

我當時寫成 `while ... else: return right`，因為迴圈沒有 `break`，`else` 一定會執行，結果一樣；直接回傳比較清楚。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 嚴格遞增，相等也要停。

## 面試口說整理

留下的一定是嚴格遞增的後綴，所以我從右往左走到第一個不遞增的位置，它的 index 就是要刪的前綴長度。時間 `O(n)`。
