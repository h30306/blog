---
title: "LeetCode 2858: Minimum Edge Reversals So Every Node Is Reachable"
summary: "LeetCode 2858 解題筆記：換根 DP：先算以 0 為根要翻幾條邊，根移到小孩時，這條邊原本順向就 +1、逆向就 -1"
description: "2026-10-31 的 LeetCode 2858 解題紀錄"
date: 2026-10-31
tags: ["hard", "dynamic-programming", "depth-first-search", "breadth-first-search", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-31
- 提交紀錄：Accepted ×2

## 解題思路

邊是有方向的，但把方向拿掉之後是一棵樹。從節點 `i` 能走到所有點，等於所有邊都要「從 `i` 往外指」。所以 `ans[i]` 是以 `i` 為根時，指向根方向（往上）的邊數。

每個點都算一次是 `O(n^2)`。用換根 DP（和 LC 834 一樣）：

1. 以 0 為根 BFS，數有幾條邊是「小孩指向父節點」，這就是 `ans[0]`。
2. 根從 `p` 移到小孩 `v` 時，只有 `p`–`v` 這條邊的需求會改變：
   - 原本是 `p → v`（順向）：以 `v` 為根時它變成往上指，要多翻一條，`ans[v] = ans[p] + 1`。
   - 原本是 `v → p`（逆向）：以 `p` 為根要翻，以 `v` 為根就不用了，`ans[v] = ans[p] - 1`。

用 `set` 存原本的有向邊，查一條邊是不是順向。

## 我的嘗試

兩次都一次通過（10-31 寫了一次，下午又重寫一次）。

## 正確解法

```python
class Solution:
    def minEdgeReversals(self, n: int, edges: List[List[int]]) -> List[int]:
        graph = defaultdict(list)
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)
        forward = {(u, v) for u, v in edges}

        parent = [-1] * n
        seen = [False] * n
        seen[0] = True
        order = []
        queue = deque([0])
        while queue:
            node = queue.popleft()
            order.append(node)
            for nei in graph[node]:
                if not seen[nei]:
                    seen[nei] = True
                    parent[nei] = node
                    queue.append(nei)

        ans = [0] * n
        ans[0] = sum(1 for v in order[1:] if (parent[v], v) not in forward)
        for v in order[1:]:
            p = parent[v]
            ans[v] = ans[p] + (1 if (p, v) in forward else -1)
        return ans
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 換根要照 BFS 順序由上往下，`ans[p]` 要先算好。
- 建圖要加兩個方向，不然從 0 走不到只能逆著走的點。

## 面試口說整理

拿掉方向是一棵樹，從 `i` 走到所有點就是所有邊都要從 `i` 往外指，所以答案是以 `i` 為根時往上指的邊數。我先以 0 為根數出來，再換根：根從 `p` 移到 `v`，只有這條邊會變，原本 `p → v` 就加一，`v → p` 就減一。時間 `O(n)`。
