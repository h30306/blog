---
title: "LeetCode 3548: Equal Sum Grid Partition II"
summary: "LeetCode 3548 解題筆記：枚舉橫切（直切用轉置），兩邊差值要等於較大那邊某一格的值；那一邊只有一列或一欄時只能去掉兩端，否則任何一格都可以"
description: "2026-07-27 的 LeetCode 3548 解題紀錄"
date: 2026-07-27
tags: ["hard", "prefix-sum", "hash-table", "matrix", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-27
- 提交紀錄：Accepted ×2

## 解題思路

只寫橫切，直切把矩陣轉置再做一次。切在第 `k` 列下面時，上面的和用列總和的前綴和累加（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 模板二），差 `diff = top - bottom`：

- `diff == 0`：直接成立。
- `diff > 0`：要從上半部去掉一格值剛好是 `diff` 的格子；`diff < 0` 則從下半部去掉 `-diff`。

去掉一格之後那一半還要連通：

| 那一半的形狀 | 能去掉哪些格子 |
|---|---|
| 只有一列（或只有一欄） | 只能去掉兩端，去掉中間會斷成兩段 |
| 至少 2 × 2 | 任何一格都可以 |

所以要知道「某個值有沒有出現在上半部 / 下半部」：記每個值**最早**和**最晚**出現的列。上半部是第 `0..k` 列，只要最早出現的列 `<= k`；下半部是第 `k+1..m-1` 列，只要最晚出現的列 `>= k + 1`。

## 我的解法

```python
class Solution:
    def canPartitionGrid(self, grid: List[List[int]]) -> bool:
        def check(g):                              # 只試橫切
            m, n = len(g), len(g[0])
            total = sum(map(sum, g))
            first_row, last_row = {}, {}
            for r in range(m):
                for v in g[r]:
                    first_row.setdefault(v, r)
                    last_row[v] = r
            top = 0
            for k in range(m - 1):                 # 切在第 k 列和第 k+1 列之間
                top += sum(g[k])
                diff = top - (total - top)
                if diff == 0:
                    return True
                if diff > 0:                       # 上半部去掉一格 diff
                    if k == 0:                     # 只有一列：只能去掉兩端
                        ok = diff in (g[0][0], g[0][-1])
                    elif n == 1:                   # 只有一欄：只能去掉兩端
                        ok = diff in (g[0][0], g[k][0])
                    else:
                        ok = first_row.get(diff, m) <= k
                else:                              # 下半部去掉一格 -diff
                    if k == m - 2:
                        ok = -diff in (g[-1][0], g[-1][-1])
                    elif n == 1:
                        ok = -diff in (g[k + 1][0], g[-1][0])
                    else:
                        ok = last_row.get(-diff, -1) >= k + 1
                if ok:
                    return True
            return False

        return check(grid) or check([list(col) for col in zip(*grid)])
```

## 複雜度

時間 `O(m · n)`，空間 `O(m · n)`（轉置和字典）。

## 要特別避免的錯誤

- 只有一列或一欄的那一半，去掉中間的格子會斷開，只能去掉兩端。
- 上半部要看最早出現的列、下半部要看最晚出現的列，不能共用同一個位置。
- 別忘了直切：轉置之後用同一個函式。

## 面試口說整理

我只處理橫切，直切用轉置。用列總和累加上半部，算出兩邊的差，差要等於較大那一邊某一格的值。那一邊如果只有一列或一欄，只能去掉兩端才不會斷開；否則任何一格都行，所以我記每個值最早和最晚出現的列，判斷它在不在那一半。時間 `O(mn)`。
