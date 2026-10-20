---
title: "LeetCode 3607: Power Grid Maintenance"
summary: "LeetCode 3607 解題筆記：Union-Find 分群，每群一個 min-heap，離線的站用 lazy deletion"
description: "2025-07-06 的 LeetCode 3607 解題紀錄"
date: 2025-07-06
tags: ["medium", "heap", "union-find", "graph", "lazy-deletion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-06
- 提交紀錄：Wrong Answer ×4 → Time Limit Exceeded ×10 → Accepted（共 15 次）

## 解題思路

1. **電網的結構不會變**：離線的站仍然屬於原本的電網。所以先用 Union-Find 把站分好群，之後不用再改。
2. **查詢要回傳「同一群裡編號最小、還在線上的站」**：每群維護一個 min-heap。
3. **站離線時不從 heap 刪除**：查詢時如果堆頂已經離線，就把它彈掉，直到堆頂是在線的站（lazy deletion）。

每個站最多被彈出一次，所以全部查詢加起來是 `O((c + q) log c)`。

## 我的嘗試

### Wrong Answer ×4：Union-Find 寫錯

```python
def union(self, x, y):
    root_x = self.find(x)
    root_y = self.find(y)
    if root_x == root_y:
        return
    if self.weight[x] >= self.weight[y]:
        self.parent[y] = self.parent[x]      # 接的是 x、y 本身，不是它們的根
    else:
        self.parent[x] = self.parent[y]
```

```python
for ps in range(c):
    groups[uf.parent[ps] + 1].add(ps + 1)    # 用 parent 而不是 find
```

兩個問題：

- `union` 找到根之後，卻把 `y` 接到 `x` 的 parent 上，**接的是節點本身而不是根**，原本 `y` 那一群的其他節點就被留在舊的根底下。
- 分群時用 `uf.parent[ps]`，但 parent 不一定是根，**要用 `find`**。

第一次還多了一個 off-by-one：分群時 key 是 `parent + 1`，查詢時用的卻是 `find(ps - 1)`，沒有加 1。

### Time Limit Exceeded ×10：每次查詢都對整群取 min

把 Union-Find 修好之後，查詢寫成：

```python
remain = groups[uf.find(ps)] - off_line    # 整群做一次集合差
res.append(min(remain))                    # 再對整群取 min
```

每次查詢都是 `O(群的大小)`。後面幾次嘗試改成離線時從 set 裡刪除、換成 union by size、改用 `is_online` 陣列……但查詢時還是 `min(set)`，所以一樣是 `O(c)`，`c` 和 `q` 都很大時就 TLE。

**問題不在 Union-Find，而在「查詢最小值」這一步。** 需要一個能快速拿到最小值、又能處理刪除的結構：heap + lazy deletion。

## 正確解法

```python
import heapq
from collections import defaultdict

class UF:
    def __init__(self, n: int):
        self.parent = list(range(n))

    def find(self, x: int) -> int:
        while self.parent[x] != x:
            self.parent[x] = self.parent[self.parent[x]]
            x = self.parent[x]
        return x

    def union(self, x: int, y: int) -> None:
        rx, ry = self.find(x), self.find(y)
        if rx != ry:
            self.parent[ry] = rx

class Solution:
    def processQueries(self, c: int, connections: List[List[int]], queries: List[List[int]]) -> List[int]:
        uf = UF(c + 1)
        for u, v in connections:
            uf.union(u, v)

        heaps = defaultdict(list)
        for station in range(1, c + 1):
            heaps[uf.find(station)].append(station)   # 依編號加入，本身就是排好的 heap

        online = [True] * (c + 1)
        res = []
        for op, x in queries:
            if op == 2:
                online[x] = False
            elif online[x]:
                res.append(x)
            else:
                heap = heaps[uf.find(x)]
                while heap and not online[heap[0]]:
                    heapq.heappop(heap)                # lazy deletion
                res.append(heap[0] if heap else -1)
        return res
```

站是依編號由小到大加入的，所以每個 list 本身就是合法的 min-heap，不用 `heapify`。

## 複雜度

時間 `O((c + n + q) log c)`，空間 `O(c)`。

## 要特別避免的錯誤

- Union-Find 的 `union` 接的是節點本身，不是根。
- 分群時用 `parent[x]` 而不是 `find(x)`。
- 1-indexed 和 0-indexed 混用。
- 卡在 TLE 時一直微調資料結構的細節，沒有回頭看「查詢的複雜度是多少」。

## 面試口說整理

電網結構不會因為站離線而改變，所以我先用 Union-Find 分群。每群維護一個依編號排序的 min-heap。站離線時只在 `online` 陣列標記，不從 heap 刪除；查詢時如果堆頂已經離線就彈掉，直到堆頂在線或 heap 空了。每個站最多被彈出一次，所以總時間是 `O((c + q) log c)`。
