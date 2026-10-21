---
title: "LeetCode 3912: Valid Elements in an Array"
summary: "LeetCode 3912 解題筆記：比左邊全部大就是比前綴最大值大，比右邊全部大就是比後綴最大值大；兩個方向各掃一次再照原順序輸出"
description: "2026-04-26 的 LeetCode 3912 解題紀錄"
date: 2026-04-26
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-26
- 提交紀錄：Accepted（一次通過）

## 解題思路

「嚴格大於左邊所有元素」等於「嚴格大於左邊的最大值」（[Array]({{< relref "/algorithm/Array" >}}) 模板三）。左往右掃一次標記比前綴最大值大的，右往左掃一次標記比後綴最大值大的，兩者有一個成立就留下。第一個和最後一個元素在對應方向上沒有比較對象，自然會被標記。

## 我的解法

```python
class Solution:
    def findValidElements(self, nums: List[int]) -> List[int]:
        n = len(nums)
        valid = [False] * n
        best = float("-inf")
        for i in range(n):
            if nums[i] > best:
                valid[i] = True
            best = max(best, nums[i])
        best = float("-inf")
        for i in range(n - 1, -1, -1):
            if nums[i] > best:
                valid[i] = True
            best = max(best, nums[i])
        return [x for x, ok in zip(nums, valid) if ok]
```

我當時把合格的 index 放進集合，最後排序 index 再輸出；用布林陣列就不用排序。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 是「嚴格」大於，跟最大值相等不算。
- 輸出要照原本的順序，而且同一個元素不能輸出兩次。

## 面試口說整理

比左邊全部都大等於比前綴最大值大，所以我左往右、右往左各掃一次標記合格的元素，最後照原順序輸出。時間 `O(n)`。
