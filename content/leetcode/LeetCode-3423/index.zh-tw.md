---
title: "LeetCode 3423: Maximum Difference Between Adjacent Elements in a Circular Array"
summary: "LeetCode 3423 解題筆記：環狀陣列的相鄰包含最後一個和第一個；用 nums[i - 1] 從 i = 0 開始剛好涵蓋"
description: "2025-07-17 的 LeetCode 3423 解題紀錄"
date: 2025-07-17
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
第一次嘗試：2025-07-17
- 提交紀錄：Accepted（一次通過）

## 解題思路

每一對相鄰元素算一次差的絕對值取最大（[Array]({{< relref "/algorithm/Array" >}}) 模板一）。環狀代表最後一個和第一個也相鄰。Python 的 `nums[-1]` 就是最後一個，所以讓 `i` 從 0 開始、跟 `nums[i - 1]` 比，就一次涵蓋所有相鄰配對。

## 我的解法

```python
class Solution:
    def maxAdjacentDistance(self, nums: List[int]) -> int:
        return max(abs(nums[i] - nums[i - 1]) for i in range(len(nums)))
```

我當時另外加上 `abs(nums[-1] - nums[0])`，效果一樣。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 別忘了頭尾也相鄰。

## 面試口說整理

我算每一對相鄰元素的差，包含最後一個和第一個，取最大值。用 `nums[i - 1]` 從 `i = 0` 開始，就會自然包含頭尾那一對。時間 `O(n)`。
