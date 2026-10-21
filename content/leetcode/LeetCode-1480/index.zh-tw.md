---
title: "LeetCode 1480: Running Sum of 1d Array"
summary: "LeetCode 1480 解題筆記：前綴和的定義，每一格加上前一格"
description: "2022-11-23 的 LeetCode 1480 解題紀錄"
date: 2022-11-23
tags: ["easy", "array", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

前綴和本身（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})）：`res[i] = res[i - 1] + nums[i]`。Python 可以直接用 `itertools.accumulate`。

## 我的解法

```python
class Solution:
    def runningSum(self, nums: List[int]) -> List[int]:
        for i in range(1, len(nums)):
            nums[i] += nums[i - 1]
        return nums
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（原地修改）。

## 要特別避免的錯誤

- 從 index 1 開始，第 0 格不變。

## 面試口說整理

每一格加上前一格的值就是前綴和，我原地修改，時間 `O(n)`。
