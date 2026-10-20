---
title: "LeetCode 3487: Maximum Unique Subarray Sum After Deletion"
summary: "LeetCode 3487 解題筆記：可以任意刪除，所以等於挑不重複的值；非負的全拿，全是負數時只拿最大的一個"
description: "2025-03-16 的 LeetCode 3487 解題紀錄"
date: 2025-03-16
tags: ["easy", "greedy", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-03-16
- 提交紀錄：Wrong Answer ×2 → Accepted（2025-07-25）

## 解題思路

可以刪掉任意元素（但不能刪光），所以任何「值不重複」的一組元素都能留下來變成一個子陣列。問題就變成：**挑一組不重複的值，總和最大**。

- 非負的值每種都拿一個（0 不影響總和）。
- 如果全部都是負數，至少要留一個，就留最大的那個。

這是 [Greedy]({{< relref "/algorithm/Greedy" >}}) 的「排序後掃描」型，只是這裡連排序都不用。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 | 只收集正數，**全是負數時集合是空的，回傳 0**。例如 `[-3]`：答案是 -3 |
| 第二版 | 特判長度 1，但 `[-5, -1]` 還是回傳 0，答案是 -1 |
| AC | 集合是空的時候，回傳所有負數中最大的 |

## 正確解法

```python
class Solution:
    def maxSum(self, nums: List[int]) -> int:
        keep = set(x for x in nums if x >= 0)
        return sum(keep) if keep else max(nums)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 結果不能是空的：全是負數時要回傳最大值，不是 0。
- 特判長度 1 不夠，要判斷的是「有沒有非負數」。

## 面試口說整理

因為可以任意刪除，任何一組不重複的值都能變成子陣列，所以我把每個非負的值各拿一次加總。如果沒有非負數，至少要留一個，就回傳最大的負數。時間 `O(n)`。
