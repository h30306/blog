---
title: "BFS 與圖的遍歷"
summary: "連通塊、網格 flood fill、多源 BFS、狀態空間 BFS、最短環，以及遞迴 DFS 的深度問題"
description: "演算法學習"
date: 2026-10-20
tags: ["bfs", "dfs", "graph", "matrix", "union-find"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

BFS（廣度優先搜尋）從起點一層一層往外擴散，**第一次到達某個狀態時，走的步數就是最短的**（每一步成本相同時）。DFS 則是一路走到底再回頭，適合「找出整個連通塊」這類不需要最短距離的問題。

辨識訊號：

- 無權圖或網格上的**最少步數**：BFS。
- **連通塊**的個數或大小：BFS、DFS 或 Union-Find 都可以。
- 擴散、感染、上色，而且「同時發生」：多源 BFS，一次處理一整層。
- 除了位置，還要記住其他狀態（拿了哪些鑰匙、蛇的方向）：把狀態一起放進 BFS 的節點。

## 模板一：BFS 最短步數

```python
from collections import deque

q = deque([start])
dist = {start: 0}
while q:
    u = q.popleft()
    if u == target:
        return dist[u]
    for v in neighbors(u):
        if v not in dist:              # 推進去時就標記，避免重複推入
            dist[v] = dist[u] + 1
            q.append(v)
return -1
```

### 主要參數說明：

- **推入 queue 的時候就標記已拜訪**，而不是彈出時才標記，不然同一個節點會被推很多次。
- 每一步成本相同才能用 BFS。成本不同要用 Dijkstra；成本只有 0 和 1 可以用 0-1 BFS。
- **heap 不是必要的**：每步成本相同時，普通 queue 的順序本來就是依距離排序的（LC 1210 一開始用了 heap）。

## 模板二：連通塊

```python
seen = set()
components = 0
for node in range(n):
    if node not in seen:
        components += 1
        seen.add(node)
        stack = [node]
        while stack:                    # 用 stack 迭代，避免遞迴太深
            u = stack.pop()
            for v in adj[u]:
                if v not in seen:
                    seen.add(v)
                    stack.append(v)
```

網格的版本是把每個格子當節點、上下左右當邊。可以原地把走過的格子改成別的值，省下 `seen`。

### 主要參數說明：

- **遞迴 DFS 的深度**：Python 預設上限約 1000，網格有 `10^5` 格時，一條長長的島就會超過。用 stack 迭代比較安全（LC 827 最後改成迭代）。
- **幫連通塊編號**：把每塊的格子改成 `2, 3, 4, ...`，再用 dict 記每塊的大小，之後只要看鄰居的編號就能知道它屬於哪一塊（LC 827）。

## 模板三：多源 BFS，一次處理一層

所有起點同時開始擴散，而且同一層到達同一格時有規則要決定結果：

```python
q = deque(sources)
while q:
    arrivals = {}                       # 這一層到達的格子 -> 結果
    for _ in range(len(q)):
        r, c, color = q.popleft()
        for nr, nc in neighbors(r, c):
            if grid[nr][nc] == 0:
                arrivals[(nr, nc)] = max(arrivals.get((nr, nc), 0), color)
    for (nr, nc), color in arrivals.items():
        grid[nr][nc] = color
        q.append((nr, nc, color))
```

**先把這一層的結果收集完，再一起寫回去**，才不會讓同一層先寫入的結果影響到同一層後面的判斷（LC 3905）。

## 模板四：狀態空間 BFS

位置不夠描述狀態時，把需要的資訊一起放進節點：

| 題目 | 狀態 |
|---|---|
| LC 864 收集所有鑰匙 | `(r, c, 拿到的鑰匙的位元遮罩)` |
| LC 1210 蛇的移動 | `(蛇尾的 r, c, 水平或垂直)` |

`visited` 也要記錄整個狀態。同一個位置、拿著不同鑰匙，是不同的節點。

## 模板五：無向圖的最短環

從每個點 BFS，記錄每個點的距離和 parent。遇到一個**已經拜訪過、而且不是 parent** 的鄰居，就找到一個經過起點附近的環，長度是 `dist[u] + dist[v] + 1`：

```python
for s in range(n):
    dist = [-1] * n
    dist[s] = 0
    q = deque([(s, -1)])
    while q:
        u, parent = q.popleft()
        for v in adj[u]:
            if dist[v] == -1:
                dist[v] = dist[u] + 1
                q.append((v, u))
            elif v != parent:
                best = min(best, dist[u] + dist[v] + 1)
```

`n` 次 BFS，總共 `O(n · (n + m))`（LC 2608）。

### 延伸：反向搜尋、計算邊、度數

- **從終點反著走**（LC 417）：從海邊往「不比自己低」的格子走，兩個海都走得到的格子就是答案，每個海 `O(mn)`。
- **周長不用搜尋**（LC 463）：每格 +4，每跟上方或左方的陸地相鄰就 -2。
- **只看度數**（LC 997、1791）：`in - out == n - 1` 的是法官；星狀圖的中心是前兩條邊的共同點。
- **深拷貝**（LC 133）：舊節點 → 新節點的雜湊表，建立後先放進表裡再處理鄰居。

## 什麼時候用 Union-Find

只需要「誰跟誰連在一起」、而且邊是一條一條加進來的，Union-Find 比 BFS 方便。但要記得**路徑壓縮**：沒有路徑壓縮的 `find` 最壞是 `O(n)`，LC 323 的 Union-Find 版本跑了 417ms，改成 DFS 只要 11ms。

## 複雜度

- BFS、DFS：`O(V + E)`；網格是 `O(mn)`。
- 狀態空間 BFS：`O(狀態數 × 每個狀態的轉移數)`，例如 LC 864 是 `O(mn · 2^k · 4)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **網格的長寬寫反**：`[[0] * n for _ in range(m)]` 和 `[[0] * m for _ in range(n)]` 搞混（LC 3905）。
- **用「經過的邊」的位元遮罩當狀態找環**：狀態數爆炸，Memory Limit Exceeded（LC 2608）。
- **位元檢查少了 `& 1`**：`visited >> edge` 只要更高位有 1 就是 True（LC 2608）。
- **沒有路徑壓縮的 Union-Find**（LC 323）。
- **遞迴 DFS 在大網格上太深**（LC 3619、827）。
- **每步成本相同卻用 heap**：可以 AC，但多了 `log` 的成本（LC 1210）。
- **邊界檢查用 `and`**：`x > rows and y > cols` 應該是四個條件用 `or`（LC 733）。
- **新舊顏色相同沒有直接回傳**：換完的格子還是會被當成要換的，無限遞迴（LC 733）。
- **格子是整數卻跟 `'1'` 比較**（LC 695）。
- **反著從海邊走時用了嚴格的 `>`**：一樣高也能流；起點也不能被擋掉（LC 417）。
- **`set` 裡放 list**：要放 tuple（LC 417）。
- **複製圖時沒有處理空圖**，或沒有先放進雜湊表再遞迴（LC 133）。
- **法官只檢查被信任的次數**：還要確認他不信任任何人（LC 997）。

## 相關 LeetCode

- `LC 323` Number of Connected Components in an Undirected Graph
- `LC 3493` Properties Graph
- `LC 3619` Count Islands With Total Value Divisible by K
- `LC 827` Making A Large Island
- `LC 1306` Jump Game III
- `LC 3905` Multi Source Flood Fill
- `LC 864` Shortest Path to Get All Keys
- `LC 1210` Minimum Moves to Reach Target with Rotations
- `LC 2608` Shortest Cycle in a Graph
- `LC 3910` Count Connected Subgraphs with Even Node Sum
- `LC 773` Sliding Puzzle
- `LC 733` Flood Fill
- `LC 695` Max Area of Island
- `LC 463` Island Perimeter
- `LC 417` Pacific Atlantic Water Flow
- `LC 133` Clone Graph
- `LC 997` Find the Town Judge
- `LC 1791` Find Center of Star Graph
