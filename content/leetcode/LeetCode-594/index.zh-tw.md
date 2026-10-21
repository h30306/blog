---
title: "LeetCode 594: Longest Harmonious Subsequence"
summary: "LeetCode 594 解題筆記：子序列不用連續，所以只要計數，每個 x 看 x 和 x + 1 的次數加起來"
description: "2022-08-28 的 LeetCode 594 解題紀錄"
date: 2022-08-28
tags: ["easy", "array", "hash-table", "sliding-window", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-28
- 提交紀錄：Accepted ×2 → Runtime Error

## 解題思路

子序列不需要連續，所以順序不重要，只要計數（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。和諧子序列只會包含 `x` 和 `x + 1` 兩種值，對每個 `x`，如果 `x + 1` 也存在，答案候選就是 `cnt[x] + cnt[x + 1]`。只看 `x + 1` 就夠了，`x - 1` 的情況會在處理 `x - 1` 時算到。

## 我的解法

```python
class Solution:
    def findLHS(self, nums: List[int]) -> int:
        cnt = Counter(nums)
        return max((cnt[x] + cnt[x + 1] for x in cnt if x + 1 in cnt), default=0)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只有一種值（例如全部相同）不算和諧，要回傳 0。

## 面試口說整理

子序列不用連續，所以我直接計數，對每個值 x，如果 x + 1 也存在，就用兩者次數相加更新答案。時間 `O(n)`。
