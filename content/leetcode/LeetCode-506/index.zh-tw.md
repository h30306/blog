---
title: "LeetCode 506: Relative Ranks"
summary: "LeetCode 506 解題筆記：把 index 按分數由高到低排序，前三名給獎牌，其他給名次的字串，放回原本的位置"
description: "2022-08-25 的 LeetCode 506 解題紀錄"
date: 2022-08-25
tags: ["easy", "array", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-25
- 提交紀錄：Accepted ×2

## 解題思路

把 index 按分數由大到小排序（或用 max-heap 依序彈出，[Heap]({{< relref "/algorithm/Heap" >}})），第 `r` 名（從 0 開始）是前三名就給 `Gold Medal`、`Silver Medal`、`Bronze Medal`，否則給 `str(r + 1)`，寫回原本的 index。

## 我的解法

```python
class Solution:
    def findRelativeRanks(self, score: List[int]) -> List[str]:
        medals = ["Gold Medal", "Silver Medal", "Bronze Medal"]
        res = [""] * len(score)
        order = sorted(range(len(score)), key=lambda i: -score[i])
        for r, i in enumerate(order):
            res[i] = medals[r] if r < 3 else str(r + 1)
        return res
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 答案要放回原本的位置，不是排序後的順序。

## 面試口說整理

我把 index 按分數由高到低排序，依名次給獎牌或名次字串，寫回原本的 index。時間 `O(n log n)`。
