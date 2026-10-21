---
title: "LeetCode 2392: Build a Matrix With Conditions"
summary: "LeetCode 2392 解題筆記：列條件和欄條件互不影響，各做一次拓撲排序；數字 x 放在列順序和欄順序的位置，任一邊有環就回傳空矩陣"
description: "2026-08-01 的 LeetCode 2392 解題紀錄"
date: 2026-08-01
tags: ["hard", "graph", "topological-sort", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-01
- 提交紀錄：Accepted ×2（第二次只是拿掉 debug 的 print）

## 解題思路

每個數字剛好出現一次，`k × k` 的矩陣有 `k` 列 `k` 欄，所以可以讓**每一列、每一欄都剛好放一個數字**。

- 列條件只決定「誰在上面」，欄條件只決定「誰在左邊」，兩者互不影響。
- 對列條件做一次 [Topological Sort]({{< relref "/algorithm/Topological-Sort" >}})，得到每個數字的列；欄條件也做一次，得到每個數字的欄。
- 數字 `x` 放在 `(row_pos[x], col_pos[x])`。任一邊有環（排不出 `k` 個）就回傳空矩陣。

## 我的解法

我當時用 heap 取 in-degree 為 0 的點，還加了 `seen`；一般的 queue 就夠了：

```python
class Solution:
    def buildMatrix(self, k: int, rowConditions: List[List[int]], colConditions: List[List[int]]) -> List[List[int]]:
        def order(conditions):
            adj = [[] for _ in range(k + 1)]
            indeg = [0] * (k + 1)
            for u, v in conditions:
                adj[u].append(v)
                indeg[v] += 1
            q = deque(x for x in range(1, k + 1) if indeg[x] == 0)
            res = []
            while q:
                x = q.popleft()
                res.append(x)
                for y in adj[x]:
                    indeg[y] -= 1
                    if indeg[y] == 0:
                        q.append(y)
            return res if len(res) == k else None   # 有環

        rows, cols = order(rowConditions), order(colConditions)
        if rows is None or cols is None:
            return []
        col_pos = {x: j for j, x in enumerate(cols)}
        mat = [[0] * k for _ in range(k)]
        for i, x in enumerate(rows):
            mat[i][col_pos[x]] = x
        return mat
```

## 複雜度

時間 `O(k² + n + m)`（建矩陣是 `k²`），空間 `O(k² + n + m)`。

## 要特別避免的錯誤

- 有環時要回傳空矩陣，不是回傳部分結果。
- 數字是 1 到 `k`，陣列大小要開 `k + 1`（或全部減 1）。

## 面試口說整理

列和欄的條件互不影響，所以我對兩組條件各做一次拓撲排序，每個數字拿到自己的列和欄，因為每個數字只出現一次，每列每欄放一個剛好放得下。任一邊排不出 `k` 個代表有環，回傳空矩陣。時間 `O(k² + n + m)`。
