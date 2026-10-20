---
title: "LeetCode 323: Number of Connected Components in an Undirected Graph"
summary: "LeetCode 323 解題筆記：DFS 或 Union-Find 數連通塊；Union-Find 沒有路徑壓縮會慢很多"
description: "2026-08-31 的 LeetCode 323 解題紀錄"
date: 2026-08-31
tags: ["medium", "graph", "dfs", "bfs", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-31
- 提交紀錄：Accepted（Union-Find，417ms）→ Accepted（DFS，11ms）

## 解題思路

連通塊的經典題，兩種做法：

- **DFS / BFS**：從每個還沒拜訪過的點出發，走完它所在的整塊，計數加 1。
- **Union-Find**：每條邊把兩端合併，最後數有幾個不同的根。

## 我的嘗試：Union-Find 沒有路徑壓縮

```python
def find(x):
    rootX = parent[x]
    if x != rootX:
        return find(rootX)          # 只往上找，沒有把路徑壓縮
    return rootX
```

`find` 只是一路往上找到根，**沒有把經過的節點直接接到根上**。樹可能退化成一條鏈，每次 `find` 都是 `O(n)`。這版跑了 417ms，改用 DFS 只要 11ms。

加上路徑壓縮只要一行：`parent[x] = find(parent[x])`。

## 正確解法

### DFS（用 stack 迭代）

```python
from collections import defaultdict

class Solution:
    def countComponents(self, n: int, edges: List[List[int]]) -> int:
        adj = defaultdict(list)
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        seen = set()
        count = 0
        for start in range(n):
            if start in seen:
                continue
            count += 1
            seen.add(start)
            stack = [start]
            while stack:
                u = stack.pop()
                for v in adj[u]:
                    if v not in seen:
                        seen.add(v)
                        stack.append(v)
        return count
```

原本的 DFS 版本用遞迴，`n <= 2000` 時一條鏈就會到 2000 層，超過 Python 預設的遞迴上限；改成 stack 迭代比較安全。

### Union-Find（有路徑壓縮）

```python
class Solution:
    def countComponents(self, n: int, edges: List[List[int]]) -> int:
        parent = list(range(n))

        def find(x: int) -> int:
            if parent[x] != x:
                parent[x] = find(parent[x])
            return parent[x]

        components = n
        for u, v in edges:
            ru, rv = find(u), find(v)
            if ru != rv:
                parent[ru] = rv
                components -= 1          # 每合併一次，連通塊少一個
        return components
```

每次真的合併兩塊，連通塊就少一個，所以不用最後再掃一遍數根。

## 複雜度

DFS：`O(n + m)`。有路徑壓縮的 Union-Find：接近 `O(n + m)`。

## 要特別避免的錯誤

- Union-Find 沒有路徑壓縮。
- 遞迴 DFS 在長鏈上超過遞迴上限。
- 邊只建單向。

## 面試口說整理

我建無向鄰接表，從每個還沒拜訪的點用 stack 做 DFS 走完整塊，每開始一次就是一個新的連通塊，時間 `O(n + m)`。也可以用 Union-Find：從 `n` 塊開始，每次合併兩個不同的根就減 1，記得加上路徑壓縮，不然 `find` 最壞會是 `O(n)`。
