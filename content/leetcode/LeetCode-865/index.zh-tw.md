---
title: "LeetCode 865: Smallest Subtree with all the Deepest Nodes"
summary: "LeetCode 865 解題筆記：BFS 找最後一層再一起往上爬，或一次 DFS 回傳 (深度, 節點)"
description: "2026-01-09 的 LeetCode 865 解題紀錄"
date: 2026-01-09
tags: ["medium", "tree", "binary-tree", "bfs", "dfs", "lca"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-09
- 提交紀錄：Accepted（一次通過）
- 同一題：LC 1123 Lowest Common Ancestor of Deepest Leaves

## 解題思路

「包含所有最深節點的最小子樹」，就是**所有最深節點的最低共同祖先（LCA）**。

## 我的解法：BFS 找最後一層，再整組往上爬

1. BFS 記錄每個節點的 parent，同時留下最後一層的節點。
2. 把最後一層放進集合，整組同時往上移一層，直到集合只剩一個節點。

```python
from collections import deque

class Solution:
    def subtreeWithAllDeepest(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        if not root:
            return None

        parent = {root: None}
        q = deque([root])
        last_level = []
        while q:
            last_level = []
            for _ in range(len(q)):
                node = q.popleft()
                last_level.append(node)
                if node.left:
                    parent[node.left] = node
                    q.append(node.left)
                if node.right:
                    parent[node.right] = node
                    q.append(node.right)

        deepest = set(last_level)
        while len(deepest) > 1:
            deepest = {parent[node] for node in deepest}
        return deepest.pop()
```

因為所有最深節點都在同一層，整組一起往上走，深度永遠相同，第一次合併成一個節點時就是 LCA。

## 另一種解法：一次 DFS 回傳 (深度, 答案)

每個節點回傳「子樹的最大深度」和「這棵子樹的答案節點」：

- 左邊比較深：答案在左子樹。
- 右邊比較深：答案在右子樹。
- 一樣深：兩邊都有最深節點，答案就是自己。

```python
class Solution:
    def subtreeWithAllDeepest(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        def dfs(node):
            if not node:
                return 0, None
            left_depth, left_ans = dfs(node.left)
            right_depth, right_ans = dfs(node.right)
            if left_depth > right_depth:
                return left_depth + 1, left_ans
            if right_depth > left_depth:
                return right_depth + 1, right_ans
            return left_depth + 1, node

        return dfs(root)[1]
```

## 複雜度

| 解法 | 時間 | 空間 |
|---|---|---|
| BFS + 往上爬 | 最壞 `O(n * h)`，往上爬每層都要處理整個集合 | `O(n)` |
| DFS 回傳 tuple | `O(n)` | `O(h)` |

## 要特別避免的錯誤

- 只找到「其中一個最深節點」就回傳它：最深節點可能不只一個。
- DFS 版平手時回傳子節點而不是自己。

## 面試口說整理

包含所有最深節點的最小子樹，就是這些節點的 LCA。我用一次後序 DFS，每個節點回傳子樹最大深度和答案：哪邊比較深，答案就在哪邊；兩邊一樣深，代表最深節點分佈在兩側，答案就是目前節點。時間 `O(n)`，空間是樹高。
