---
title: "LeetCode 2421: Number of Good Paths"
summary: "LeetCode 2421 解題筆記：依值由小到大加入節點，用 Union-Find 數同一群裡同值的節點"
description: "2026-07-26 的 LeetCode 2421 解題紀錄"
date: 2026-07-26
tags: ["hard", "tree", "union-find", "graph", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-26
- 提交紀錄：Accepted（一次通過）

## 解題思路

Good path 的兩端值相同，而且路徑上所有值都不超過兩端。

換個角度：**只用值 `<= v` 的節點，看哪些值為 `v` 的節點彼此連通。** 同一個連通塊裡如果有 `k` 個值為 `v` 的節點，它們兩兩之間都有一條 good path，共 `k * (k - 1) / 2` 條。

所以依值由小到大處理：

1. 處理值 `v` 時，把每個值為 `v` 的節點，和值 `<= v` 的鄰居合併。
2. 數每個連通塊裡有幾個值為 `v` 的節點，加上 `k * (k - 1) / 2`。
3. 單一節點本身也算一條，所以答案從 `n` 開始。

因為是由小到大加入，合併時只會用到值 `<= v` 的節點，路徑上的最大值自然不會超過 `v`。

## 我的解法

```python
from collections import defaultdict

class UF:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        rx, ry = self.find(x), self.find(y)
        if rx == ry:
            return
        if self.rank[rx] < self.rank[ry]:
            rx, ry = ry, rx
        self.parent[ry] = rx
        if self.rank[rx] == self.rank[ry]:
            self.rank[rx] += 1

class Solution:
    def numberOfGoodPaths(self, vals: List[int], edges: List[List[int]]) -> int:
        n = len(vals)
        adj = [[] for _ in range(n)]
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        val_to_nodes = defaultdict(list)
        for i, val in enumerate(vals):
            val_to_nodes[val].append(i)

        uf = UF(n)
        res = n
        for val, nodes in sorted(val_to_nodes.items()):
            for node in nodes:                         # 1. 跟值 <= val 的鄰居合併
                for nei in adj[node]:
                    if vals[nei] <= val:
                        uf.union(node, nei)

            group_count = defaultdict(int)             # 2. 數每群裡值為 val 的節點
            for node in nodes:
                group_count[uf.find(node)] += 1

            for k in group_count.values():             # 3. 兩兩配對
                res += k * (k - 1) // 2
        return res
```

當時寫的 `union` 有個小問題：rank 相同和 `rank[rx]` 比較大這兩種情況都進 `else`，而且都把 `rank[rx]` 加 1。結果仍然正確，只是 rank 會比實際高。上面已經改成只有 rank 相同時才加 1。

## 複雜度

時間 `O(n log n)`，主要是排序；Union-Find 的操作接近常數。空間 `O(n)`。

## 要特別避免的錯誤

- 合併時用 `vals[nei] < val`：值相同的鄰居也要合併，不然兩個相鄰的同值節點會被漏掉。
- 等所有值都處理完才一起計數：每個值都要在處理下一個值之前計數，否則更大的值會把群組合併得太大。
- 忘記加上 `n` 條單點路徑。

## 面試口說整理

Good path 要求路徑上的值都不超過端點，所以我依值由小到大處理節點：處理值 `v` 時，把值為 `v` 的節點和值不超過 `v` 的鄰居用 Union-Find 合併，這樣每個連通塊裡的路徑最大值都不超過 `v`。接著數每塊裡有 `k` 個值為 `v` 的節點，加上 `k(k-1)/2`，最後再加上 `n` 條單點路徑。時間主要是排序，`O(n log n)`。
