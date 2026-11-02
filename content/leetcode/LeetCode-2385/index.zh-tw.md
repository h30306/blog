---
title: "LeetCode 2385: Amount of Time for Binary Tree to Be Infected"
summary: "LeetCode 2385 解題筆記：把樹轉成無向圖，從 start 做 BFS，層數減一就是分鐘數"
description: "2026-11-01 的 LeetCode 2385 解題紀錄"
date: 2026-11-01
tags: ["medium", "hash-table", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-11-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

感染會往小孩和父節點擴散，所以和 LC 863 一樣先把樹轉成無向圖（[Tree]({{< relref "/algorithm/Tree" >}}) 模板五），再從 `start` 做 BFS。每一層是一分鐘，最後一層被感染的時間就是答案，等於 BFS 的層數減一。

也就是說，答案是 `start` 到最遠節點的距離。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def amountOfTime(self, root: Optional[TreeNode], start: int) -> int:
        graph = defaultdict(list)
        queue = deque([root])
        while queue:
            node = queue.popleft()
            for child in (node.left, node.right):
                if child:
                    graph[node.val].append(child.val)
                    graph[child.val].append(node.val)
                    queue.append(child)

        minutes = -1
        seen = {start}
        queue = deque([start])
        while queue:
            minutes += 1
            for _ in range(len(queue)):
                node = queue.popleft()
                for nei in graph[node]:
                    if nei not in seen:
                        seen.add(nei)
                        queue.append(nei)
        return minutes
```

建圖用 BFS 而不是遞迴 DFS，樹很深（最多 `10^5` 個節點）時不會碰到遞迴深度限制。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `minutes` 從 -1 開始：第一層是 `start` 自己，時間是 0。
- 不建圖、只往下找，會漏掉往父節點的方向。

## 面試口說整理

感染會往父節點擴散，所以我先把樹轉成無向圖，再從 `start` 做 BFS，一層算一分鐘，最後一層的時間就是答案，也就是 `start` 到最遠節點的距離。建圖用 BFS 避免遞迴太深。時間、空間 `O(n)`。
