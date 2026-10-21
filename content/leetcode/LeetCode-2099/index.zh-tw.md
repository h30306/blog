---
title: "LeetCode 2099: Find Subsequence of Length K With the Largest Sum"
summary: "LeetCode 2099 解題筆記：選出最大的 k 個數（連同 index），再按 index 排回原本的順序"
description: "2022-11-22 的 LeetCode 2099 解題紀錄"
date: 2022-11-22
tags: ["easy", "array", "hash-table", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-22
- 提交紀錄：Accepted → Runtime Error → Accepted

## 解題思路

子序列要保持原本的順序，但總和最大就是選最大的 `k` 個數。把 `(值, index)` 依值取最大的 `k` 個（排序或大小為 `k` 的 heap，[Heap]({{< relref "/algorithm/Heap" >}}) 模板一），再依 index 排序輸出。

## 我的嘗試

2022 年一次 AC，用 heap 彈掉最小的 `n - k` 個再按 index 排序。2025 年重寫時寫成 `sort(lambda x: -x[1])`，**`key` 要用關鍵字參數**（TypeError），補上 `key=` 就 AC 了。

## 正確解法

```python
class Solution:
    def maxSubsequence(self, nums: List[int], k: int) -> List[int]:
        top = heapq.nlargest(k, range(len(nums)), key=lambda i: nums[i])
        return [nums[i] for i in sorted(top)]
```

## 複雜度

時間 `O(n log k)`，空間 `O(k)`。

## 要特別避免的錯誤

- 選完之後要按 index 排回原本的順序。
- `list.sort` 的 key 要用關鍵字參數：`sort(key=...)`。

## 面試口說整理

總和最大就是選最大的 k 個數，但子序列要保持原本的順序，所以我用 nlargest 依值選出 k 個 index，再把 index 排序後輸出對應的值。時間 `O(n log k)`。
