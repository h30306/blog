---
title: "LeetCode 1514: Path with Maximum Probability"
summary: "LeetCode 1514 解題筆記：機率相乘只會變小，所以 Dijkstra 可以直接用；剪枝要用 <="
description: "2026-04-17 的 LeetCode 1514 解題紀錄"
date: 2026-04-17
tags: ["medium", "graph", "dijkstra", "shortest-path", "heap"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-17
- 提交紀錄：Wrong Answer ×2 → Memory Limit Exceeded ×2 → Accepted → Accepted（2026-04-27 重寫）

## 解題思路

找從 `start` 到 `end` 成功機率最大的路徑，路徑機率是邊機率的乘積。

為什麼可以用 Dijkstra：Dijkstra 需要「路徑越走越差」，也就是非負邊權。這題每條邊的機率在 `[0, 1]`，**乘上去只會變小或不變**，性質一樣。所以把機率取負號放進 min-heap，每次取出機率最大的節點擴展；**第一次取出 `end` 時就是答案**。

## 我的嘗試

1. **從節點 0 出發**：`pq = [(-1, 0)]` 寫死了 0，應該是 `start_node`。
2. **到達 `end` 時回傳了錯的變數**：`return res`，但 `res` 還是初始值。
3. **Memory Limit Exceeded**：剪枝條件用 `<`：

    ```python
    if nn in visited and visited[nn] < prob * np:
        continue
    ```

    存的是負的機率，`visited[nn] < prob * np` 表示「已經有更好的」。但**一樣好的**情況沒有被剪掉，同一個節點會一直被重複推進 heap，記憶體爆掉。改成 `<=` 就 AC 了。

4. 十天後重寫成標準的 Dijkstra：用 `visited` 集合，每個節點第一次被彈出時就確定答案，之後直接跳過。

## 正確解法

```python
import heapq
from collections import defaultdict

class Solution:
    def maxProbability(self, n: int, edges: List[List[int]], succProb: List[float],
                       start_node: int, end_node: int) -> float:
        adj = defaultdict(list)
        for (u, v), p in zip(edges, succProb):
            adj[u].append((v, p))
            adj[v].append((u, p))

        best = [0.0] * n
        best[start_node] = 1.0
        heap = [(-1.0, start_node)]
        while heap:
            neg_p, u = heapq.heappop(heap)
            p = -neg_p
            if u == end_node:
                return p
            if p < best[u]:
                continue                         # 過期的資料
            for v, w in adj[u]:
                if p * w > best[v]:              # 嚴格變好才推進去
                    best[v] = p * w
                    heapq.heappush(heap, (-best[v], v))
        return 0.0
```

用 `best` 陣列，而且**只有嚴格變好才推入**，就不會重複推入一樣好的狀態。

## 複雜度

時間 `O(E log V)`，空間 `O(V + E)`。

## 要特別避免的錯誤

- 起點寫死成 0。
- 剪枝用 `<`：一樣好的狀態一直被重複推入。
- 把題目當成「最短路」直接加總機率：機率要相乘。
- 也可以取 `-log(p)` 轉成加法的最短路，但浮點誤差比直接相乘大，沒有必要。

## 面試口說整理

路徑機率是邊機率相乘，而每條邊的機率不超過 1，所以路徑越長機率只會越小，這跟 Dijkstra 需要的非負邊權性質一樣。我用 max-heap（存負的機率）每次取出目前機率最大的節點，只有讓鄰居機率嚴格變大時才更新並推入。第一次彈出終點就是答案，彈完都沒遇到就回傳 0。時間 `O(E log V)`。
