---
title: "LeetCode 275: H-Index II"
summary: "LeetCode 275 解題筆記：引用數已排序，找第一個 citations[i] >= n - i 的位置，答案是 n - i；用二分做到 O(log n)"
description: "2022-11-27 的 LeetCode 275 解題紀錄"
date: 2022-11-27
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-27
- 提交紀錄：Wrong Answer ×2 → Accepted ×2

## 解題思路

h-index 是最大的 `h`，使得有 `h` 篇論文引用數 `>= h`。陣列由小到大排序，從位置 `i` 到結尾有 `n - i` 篇，條件是 `citations[i] >= n - i`（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一）。這個條件從左到右是「先不成立、後成立」，找第一個成立的位置 `i`，答案就是 `n - i`；都不成立時 `i = n`，答案是 0。

## 我的嘗試

前兩版是線性掃描，但條件寫成 `citations[i] >= 總篇數`、找不到時沒有回傳值，例如 `[0]` 回傳 `None`，答案是 0。

## 正確解法

```python
class Solution:
    def hIndex(self, citations: List[int]) -> int:
        n = len(citations)
        l, r = 0, n
        while l < r:
            mid = (l + r) // 2
            if citations[mid] >= n - mid:
                r = mid
            else:
                l = mid + 1
        return n - l
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 全部的引用數都是 0 時答案是 0，函式每條路徑都要有回傳值。

## 面試口說整理

引用數排好序之後，從某個位置開始引用數都夠多，所以我二分找第一個 `citations[i] >= n - i` 的位置，答案是 `n - i`。時間 `O(log n)`。
