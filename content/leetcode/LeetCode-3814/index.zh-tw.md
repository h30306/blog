---
title: "LeetCode 3814: Maximum Capacity Within Budget"
summary: "LeetCode 3814 解題筆記：依成本排序加上前綴最大容量，每台機器用 bisect 找能搭配的最貴機器"
description: "2026-01-18 的 LeetCode 3814 解題紀錄"
date: 2026-01-18
tags: ["medium", "binary-search", "sorting", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-18
- 提交紀錄：Time Limit Exceeded → Accepted

## 解題思路

最多選兩台不同的機器，總成本**嚴格小於** `budget`，讓總容量最大。

選一台的情況很簡單：所有成本 `< budget` 的機器取容量最大的。

選兩台時，依成本排序，固定比較貴的那台 `i`，另一台要從 `i` 前面、成本 `< budget - cost[i]` 的機器裡挑容量最大的：

1. 依成本排序，建「前綴最大容量」`best[j] = max(cap[0..j])`。
2. 對每個 `i`，用 `bisect_left(costs, budget - cost[i])` 找到第一個成本太高的位置 `idx`，可以搭配的範圍是 `[0, min(idx, i) - 1]`。
3. 答案候選是 `cap[i] + best[min(idx, i) - 1]`。

限制在 `i` 前面，是為了確保兩台是不同的機器，而且每一對只會被算一次。

## 我的嘗試：雙層迴圈

```python
for i in range(n):
    for j in range(i + 1, n):
        if first_cost + second_cost >= budget:
            break
        max_cap = max(max_cap, first_cap + second_cap)
```

排序後內層有 `break`，但成本都很低的時候，內層幾乎會跑完，最壞 `O(n^2)`，TLE。

中間還試過雙指針加前綴最大值的寫法（留在註解裡沒有交），最後改成 bisect 版本 AC。

## 正確解法

```python
import bisect

class Solution:
    def maxCapacity(self, costs: List[int], capacity: List[int], budget: int) -> int:
        machines = sorted(zip(costs, capacity))
        sorted_costs = [c for c, _ in machines]

        best_prefix = []
        cur = 0
        for _, cap in machines:
            cur = max(cur, cap)
            best_prefix.append(cur)

        ans = 0
        for i, (cost, cap) in enumerate(machines):
            if cost >= budget:
                break
            ans = max(ans, cap)                                      # 只選一台
            j = min(bisect.bisect_left(sorted_costs, budget - cost), i) - 1
            if j >= 0:
                ans = max(ans, cap + best_prefix[j])                 # 選兩台
        return ans
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 「嚴格小於」寫成 `<=`：要用 `bisect_left(costs, budget - cost)`，找的是第一個 `>= budget - cost` 的位置。
- 沒有限制在 `i` 前面：可能選到同一台機器兩次。
- 忘記只選一台的情況。

## 面試口說整理

我把機器依成本排序，建前綴最大容量。只選一台時取成本低於預算的最大容量；選兩台時，固定比較貴的那台 `i`，用 `bisect_left` 找出成本低於 `budget - cost[i]` 的範圍，再限制在 `i` 之前避免重複，前綴最大值就是最好的搭配。時間 `O(n log n)`。
