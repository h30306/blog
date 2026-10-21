---
title: "LeetCode 1059: All Paths from Source Lead to Destination"
summary: "LeetCode 1059 解題筆記：從終點反向修剪出度，一個點所有出邊都指向安全的點才安全；終點本身不能有出邊"
description: "2026-04-29 的 LeetCode 1059 解題紀錄"
date: 2026-04-29
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-29
- 提交紀錄：Accepted → Wrong Answer → Accepted

## 解題思路

「所有從 source 出發的路徑都走到 destination」等於三件事：走得到的死路只能是 destination、沒有走得到的環、destination 本身沒有出邊（不然可以繼續走，甚至繞圈）。

用 [Topological Sort]({{< relref "/algorithm/Topological-Sort" >}}) 的 reverse outdegree trimming：

- 把邊反過來建，記每個點的出度。
- destination 有出邊就直接回傳 `False`。
- 從 destination 開始 BFS：一個點的出度被減到 0，代表它所有出邊都指向安全的點，它也安全。
- 環上的點出度永遠不會歸零，其他死路也不會被加進來。最後看 source 安不安全。

## 我的嘗試

第一次用反向修剪就 AC 了。之後想練 DFS 版本（三色標記：在路徑上 / 確定安全 / 確定不安全），卻**沒檢查 destination 有沒有出邊**。例如 `n = 1`、`edges = [[0, 0]]`、`source = destination = 0`：0 有自環，可以無限繞，答案是 `False`；DFS 一進來就因為 `node == destination` 回傳 `True`。補上檢查就 AC 了。

## 正確解法

```python
class Solution:
    def leadsToDestination(self, n: int, edges: List[List[int]], source: int, destination: int) -> bool:
        rev = [[] for _ in range(n)]
        out_degree = [0] * n
        for u, v in edges:
            rev[v].append(u)
            out_degree[u] += 1
        if out_degree[destination]:
            return False
        safe = {destination}
        q = deque([destination])
        while q:
            node = q.popleft()
            for prev in rev[node]:
                out_degree[prev] -= 1
                if out_degree[prev] == 0:          # 所有出邊都指向安全的點
                    safe.add(prev)
                    q.append(prev)
        return source in safe
```

## 複雜度

時間 `O(n + E)`，空間 `O(n + E)`。

## 要特別避免的錯誤

- destination 有出邊（包含自環）時一定是 `False`。
- 重邊會讓出度算兩次，反向邊也要存兩次，兩者剛好一致，不用去重。

## 面試口說整理

我從 destination 反向修剪：把邊反過來，一個點的出邊全部指向安全的點時，它的出度會被減到 0，就變成安全的。環上的點和其他死路永遠不會被加進來。destination 本身有出邊就直接是 `False`。最後回傳 source 是否安全。時間 `O(n + E)`。
