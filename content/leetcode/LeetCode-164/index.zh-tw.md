---
title: "LeetCode 164: Maximum Gap"
summary: "LeetCode 164 解題筆記：最大間距至少是平均間距，桶子寬度不超過它時，最大差一定在相鄰的非空桶子之間；每個桶子只記最小和最大值，O(n)"
description: "2025-04-14 的 LeetCode 164 解題紀錄"
date: 2025-04-14
tags: ["medium", "bucket-sort", "radix-sort", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-04-14
- 提交紀錄：Runtime Error → Accepted（排序）→ Memory Limit Exceeded ×2（2025-04-15、2025-04-20）

## 解題思路

題目要求線性時間，不能排序。用鴿籠原理（[Bucket Sort]({{< relref "/algorithm/Bucket-Sort" >}})）：

- `n` 個數在 `[lo, hi]` 裡，排序後的 `n - 1` 個相鄰差加起來是 `hi - lo`，所以最大差**至少**是平均 `(hi - lo) / (n - 1)`。
- 把值域切成寬度不超過平均的桶子，同一個桶子裡兩個數的差一定小於平均，**不可能是最大差**。
- 所以最大差一定是「某個非空桶子的最小值 - 前一個非空桶子的最大值」，每個桶子只要記最小值和最大值。

## 我的嘗試

1. 第一版直接排序，多了一個括號 RE，修好之後 AC，但這是 `O(n log n)`，不符合題目要求。
2. 之後想做到線性，開了一個跟值域一樣大的布林陣列標記出現過的值，再掃一次找最大間距。值可以到 `10^9`，兩次都 Memory Limit Exceeded。
3. 正確的做法是讓桶子數量跟 `n` 有關，而不是跟值域有關。

## 正確解法

```python
class Solution:
    def maximumGap(self, nums: List[int]) -> int:
        lo, hi, n = min(nums), max(nums), len(nums)
        if n < 2 or lo == hi:
            return 0
        size = max(1, (hi - lo) // (n - 1))        # 桶子寬度不超過平均間距
        count = (hi - lo) // size + 1
        bmin, bmax = [None] * count, [None] * count
        for x in nums:
            b = (x - lo) // size
            bmin[b] = x if bmin[b] is None else min(bmin[b], x)
            bmax[b] = x if bmax[b] is None else max(bmax[b], x)
        best, prev = 0, lo
        for b in range(count):
            if bmin[b] is not None:
                best = max(best, bmin[b] - prev)
                prev = bmax[b]
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 不要開跟值域一樣大的陣列。
- 桶子寬度要用整數除法再跟 1 取最大值，避免寬度是 0。
- 只比較「相鄰的非空桶子」，空桶子要跳過。

## 面試口說整理

最大間距至少是平均間距，所以我把值域切成寬度不超過平均的桶子，同一個桶子裡的差不可能是最大的。每個桶子只記最小和最大值，最後掃一次，用每個非空桶子的最小值減掉前一個非空桶子的最大值。時間和空間都是 `O(n)`。
