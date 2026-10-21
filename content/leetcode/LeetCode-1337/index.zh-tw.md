---
title: "LeetCode 1337: The K Weakest Rows in a Matrix"
summary: "LeetCode 1337 解題筆記：每列的士兵都在前面，用二分找第一個 0 就是士兵數；照（士兵數, 列號）排序取前 k 個"
description: "2022-11-21 的 LeetCode 1337 解題紀錄"
date: 2022-11-21
tags: ["easy", "array", "binary-search", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-21
- 提交紀錄：Accepted（一次通過）

## 解題思路

每一列的 1 都排在 0 前面，所以士兵數就是「第一個 0 的位置」，可以二分（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一）。之後照 `(士兵數, 列號)` 排序，取前 `k` 個列號。

## 我的解法

```python
class Solution:
    def kWeakestRows(self, mat: List[List[int]], k: int) -> List[int]:
        def soldiers(row):
            l, r = 0, len(row)
            while l < r:
                mid = (l + r) // 2
                if row[mid] == 1:
                    l = mid + 1
                else:
                    r = mid
            return l
        return sorted(range(len(mat)), key=lambda i: (soldiers(mat[i]), i))[:k]
```

我當時是直接 `sum(row)` 再丟進 heap，一樣會過；這裡用二分利用「1 都在前面」的性質。

## 複雜度

時間 `O(m log n + m log m)`，空間 `O(m)`。

## 要特別避免的錯誤

- 士兵數一樣時，列號小的比較弱。

## 面試口說整理

每列的士兵都在前面，所以我二分找第一個 0 得到士兵數，再用（士兵數, 列號）排序取前 `k` 個。時間 `O(m log n + m log m)`。
