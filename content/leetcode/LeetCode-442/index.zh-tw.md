---
title: "LeetCode 442: Find All Duplicates in an Array"
summary: "LeetCode 442 解題筆記：值在 1..n，用 nums[v-1] 的負號記錄 v 出現過；第二次遇到時它已經是負的"
description: "2026-01-31 的 LeetCode 442 解題紀錄"
date: 2026-01-31
tags: ["medium", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-31
- 提交紀錄：Time Limit Exceeded ×2 → Accepted

## 解題思路

值都在 `1..n`，所以 `nums[v - 1]` 剛好可以當 `v` 的「出現過」標記（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板二）：

- 第一次遇到 `v`，把 `nums[v - 1]` 變成負的。
- 再遇到 `v` 時 `nums[v - 1]` 已經是負的，`v` 就是重複的。

讀值時要取絕對值，因為它本身可能已經被別的數標記成負的。

## 我的嘗試

前兩版用 `-num in nums` 檢查，**在 list 上用 `in` 是 `O(n)`**，整體 `O(n²)`，TLE。改成用 index 直接查就 AC 了。

## 正確解法

```python
class Solution:
    def findDuplicates(self, nums: List[int]) -> List[int]:
        res = []
        for x in nums:
            i = abs(x) - 1
            if nums[i] < 0:
                res.append(abs(x))
            else:
                nums[i] = -nums[i]
        return res
```

## 複雜度

時間 `O(n)`，額外空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- list 的 `in` 是線性搜尋。
- 讀值時要取絕對值。

## 面試口說整理

值在 1 到 `n`，我用 `nums[v - 1]` 的正負號記錄 `v` 有沒有出現過。第一次遇到就把它變負，第二次遇到時已經是負的，就把 `v` 加進答案。時間 `O(n)`、額外空間 `O(1)`。
