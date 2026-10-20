---
title: "LeetCode 1161: Maximum Level Sum of a Binary Tree"
summary: "LeetCode 1161 解題筆記：把 None 放進下一層會多出一層假的總和 0"
description: "2026-01-06 的 LeetCode 1161 解題紀錄"
date: 2026-01-06
tags: ["medium", "tree", "binary-tree", "bfs"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-06
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

按層計算總和，回傳總和最大的層；有多層一樣大時，回傳最小的層號。這是標準的 BFS 層序遍歷。

## 我的第一版：每層一次遞迴

```python
def bfs(nodes, curr_level):
    if not nodes:
        return float("-inf"), -1
    curr_sum = 0
    next_layer_nodes = []
    for node in nodes:
        if node:
            curr_sum += node.val
            next_layer_nodes.append(node.left)     # 連 None 一起放進去
            next_layer_nodes.append(node.right)
    next_layer_sum, next_level = bfs(next_layer_nodes, curr_level + 1)
    ...
```

錯在**把 `None` 子節點也放進下一層**。最後一層的節點沒有子節點，下一層就會是一串 `None`。這一串不是空 list，所以會被當成一層真的節點，總和是 0。

如果真正的每一層總和都是負數，這個不存在的「總和 0 層」就會被選成答案。

修正方式是只把非空的子節點放進下一層。

## 正確解法

第二版加上 `if node.left` 和 `if node.right` 就 AC 了。不過每層一次遞迴，在退化成鏈的樹上遞迴深度等於層數，Python 有可能撞到遞迴上限。改成迭代的 BFS 比較穩：

```python
from collections import deque

class Solution:
    def maxLevelSum(self, root: Optional[TreeNode]) -> int:
        best_sum, best_level = float("-inf"), 0
        q = deque([root])
        level = 0
        while q:
            level += 1
            level_sum = 0
            for _ in range(len(q)):
                node = q.popleft()
                level_sum += node.val
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
            if level_sum > best_sum:          # 用 > 保留最小的層號
                best_sum, best_level = level_sum, level
        return best_level
```

## 複雜度

時間 `O(n)`，空間 `O(w)`，`w` 是最寬那層的節點數。

## 要特別避免的錯誤

- 把 `None` 放進 queue，多出一層假的 0。
- 平手時用 `>=`，會回傳比較大的層號。
- 初始最大值設成 0：如果所有層總和都是負數，會出錯。

## 面試口說整理

我用 BFS 一層一層處理：進入每層前先記下 queue 長度，累加這層的總和，只把非空的子節點放進 queue。總和嚴格大於目前最佳值才更新，這樣平手時會保留比較小的層號。最佳值從負無限大開始，因為節點值可能是負的。時間 `O(n)`。
