---
title: "LeetCode 684: Redundant Connection"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-05-04
tags: ["LeetCode", "blog", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-05-04
- 總花費時間：04:00.00

## 解題思路

這題要找出最後一條會導致圖中出現環（cycle）的邊。  
根據並查集（Union Find）演算法，當我們對兩個節點進行 union 操作時，如果它們已經有相同的根（parent），就代表這條邊會形成環。  
因此，我們只需要記錄這條邊並回傳即可。

## 解法

```python
class Solution:
    def findRedundantConnection(self, edges: List[List[int]]) -> List[int]:
        n = len(edges)
        ranking = [0 for _ in range(n)]
        parent = [i for i in range(n)]
        res = []

        def find(x):
            if parent[x] != x:
                parent[x] = find(parent[x])
            return parent[x]

        def union(x, y):
            nonlocal res
            x_root = find(x)
            y_root = find(y)

            if x_root == y_root:
                res = [x + 1, y + 1]
                return

            if ranking[x_root] > ranking[y_root]:
                parent[y_root] = parent[x_root]
                ranking[x_root] += ranking[y_root]
            else:
                parent[x_root] = parent[y_root]
                ranking[y_root] += ranking[x_root]

        for x, y in edges:
            union(x - 1, y - 1)

        return res
```

## 收穫

## 遇到的問題