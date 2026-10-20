---
title: "LeetCode 1377: Frog Position After T Seconds"
summary: "LeetCode 1377 解題筆記：無向邊、seen 要記節點、提早到達目標時要看還能不能走"
description: "2026-08-30 的 LeetCode 1377 解題紀錄"
date: 2026-08-30
tags: ["hard", "tree", "dfs", "bfs", "graph", "probability"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-30
- 提交紀錄：Wrong Answer ×5 → Accepted

## 解題思路

青蛙從節點 1 出發，每秒等機率跳到一個還沒去過的鄰居；沒有地方可跳時就停在原地。問 `t` 秒後停在 `target` 的機率。

樹上從 1 到 `target` 只有一條路徑，所以只要沿著這條路徑把機率相乘：每經過一個節點，機率乘上 `1 / (未拜訪的鄰居數)`。

到達 `target` 時要分三種情況：

| 到達時間 | `target` 還有沒走過的鄰居嗎 | 結果 |
|---|---|---|
| 剛好 `t` 秒 | 不重要 | 回傳機率 |
| 早於 `t` 秒 | 沒有，青蛙會一直停在這 | 回傳機率 |
| 早於 `t` 秒 | 有，青蛙會跳走 | 回傳 0 |

## 我的嘗試

五次 WA 都卡在同幾個錯誤：

1. **只建單向邊**：`edgeMap[u].append(v)` 沒有反向。如果 edge 寫成 `[2, 1]`，就走不到節點 2。
2. **`seen` 加錯東西**：`seen.add(second)` 把時間放進集合，而不是節點，所以 `if vertex in seen` 完全沒有作用。
3. **只檢查 `second == t`**：青蛙提早到達目標、而且無路可走時，會一直停在那裡，應該也要算進去。
4. **改成 `second <= t` 又太寬**：提早到達但還能繼續跳時，青蛙會離開，機率應該是 0。
5. 中間還留著 `print(pq)` 除錯輸出。

## 正確解法

AC 的版本用了 heap，但這題不需要：每個節點只會被到達一次，用 DFS 或 BFS 都可以。下面用 DFS，順著路徑把機率傳下去：

```python
class Solution:
    def frogPosition(self, n: int, edges: List[List[int]], t: int, target: int) -> float:
        adj = [[] for _ in range(n + 1)]
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        def dfs(u: int, parent: int, time: int, prob: float) -> float:
            children = [v for v in adj[u] if v != parent]
            if u == target:
                if time == t or (time < t and not children):
                    return prob
                return 0.0
            if time == t or not children:
                return 0.0
            for v in children:
                p = dfs(v, u, time + 1, prob / len(children))
                if p:
                    return p
            return 0.0

        return dfs(1, 0, 0, 1.0)
```

樹沒有環，所以用 `parent` 取代 `seen` 就能避免走回頭路。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 樹的邊只建單向。
- `seen` 加入的不是節點。
- 沒有區分「剛好在 `t` 秒到達」和「提早到達後停住」。
- 用 heap 或其他重工具，反而把邏輯變複雜。

## 面試口說整理

樹上從 1 到目標只有一條路徑，所以我用 DFS 沿路把機率除以未拜訪的子節點數。到達目標時，如果時間剛好是 `t`，或時間還沒到但已經沒有子節點可跳，就回傳目前機率；否則青蛙會跳走，機率是 0。邊要建成雙向，用 parent 避免走回頭路。時間 `O(n)`。
