---
title: "LeetCode 993: Cousins in Binary Tree"
summary: "LeetCode 993 解題筆記：堂兄弟要同一層、但父節點不同；DFS 記錄 x 和 y 的深度與父節點再比較"
description: "2022-09-26 的 LeetCode 993 解題紀錄"
date: 2022-09-26
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Wrong Answer ×4 → Runtime Error → Wrong Answer → Accepted ×3

## 解題思路

堂兄弟有兩個條件：**深度相同**、**父節點不同**（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。DFS 時帶著父節點和深度，找到 `x`、`y` 時記下來，最後兩個條件都檢查。

## 我的嘗試

前幾版**只比較深度**，沒有檢查父節點。例如 `[17, 3, 8]`、`x = 3`、`y = 8`：兩個是兄弟，答案 `False`，回傳 `True`。

## 正確解法

```python
class Solution:
    def isCousins(self, root: Optional[TreeNode], x: int, y: int) -> bool:
        info = {}
        def dfs(node, parent, depth):
            if not node:
                return
            if node.val in (x, y):
                info[node.val] = (parent, depth)
            dfs(node.left, node, depth + 1)
            dfs(node.right, node, depth + 1)
        dfs(root, None, 0)
        (px, dx), (py, dy) = info[x], info[y]
        return dx == dy and px is not py
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 同一層的兄弟（同一個父節點）不是堂兄弟。

## 面試口說整理

堂兄弟要同一層而且父節點不同，所以我用 DFS 記下 `x` 和 `y` 的深度和父節點，最後兩個條件都檢查。時間 `O(n)`。
