---
title: "LeetCode 987: Vertical Order Traversal of a Binary Tree"
summary: "LeetCode 987 解題筆記：收集 (欄, 列, 值) 三元組，排序後依欄分組"
description: "2026-09-12 的 LeetCode 987 解題紀錄"
date: 2026-09-12
tags: ["hard", "tree", "binary-tree", "bfs", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-12
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個節點都有座標：根是 `(row 0, col 0)`，左子節點 `col - 1`，右子節點 `col + 1`，`row` 都加 1。

輸出要求：

1. 依欄由左到右。
2. 同一欄由上到下。
3. 同欄同列時，依值由小到大。

這三個條件剛好就是 **`(col, row, val)` 的字典序**。所以把每個節點的三元組收集起來，排序一次，再依欄分組就完成了。

這題難在排序規則，不在遍歷：用 BFS 或 DFS 收集都可以。

## 我的解法

```python
from collections import deque

class Solution:
    def verticalTraversal(self, root: Optional[TreeNode]) -> List[List[int]]:
        q = deque([(root, 0, 0)])               # (node, col, row)
        cells = []
        while q:
            node, col, row = q.popleft()
            cells.append((col, row, node.val))
            if node.left:
                q.append((node.left, col - 1, row + 1))
            if node.right:
                q.append((node.right, col + 1, row + 1))

        cells.sort()

        res = []
        prev_col = None
        for col, _, val in cells:
            if col != prev_col:
                res.append([])
                prev_col = col
            res[-1].append(val)
        return res
```

原本的寫法用 `prev_x` 和 `curr_x` 手動分組，最後再補上最後一組；上面改成「欄改變就開新的一組」，不用另外補最後一組。

## 複雜度

時間 `O(n log n)`，主要是排序。空間 `O(n)`。

## 要特別避免的錯誤

- 只依欄分組、沒有依列排序：BFS 的順序雖然大致由上到下，但同一列裡不同子樹的節點順序不一定照值排。
- 同欄同列時沒有依值排序，這是題目特別要求的。
- 分組時忘記把最後一組加進結果。

## 面試口說整理

我給每個節點座標，根是 `(0, 0)`，往左欄減 1、往右欄加 1，每往下一層列加 1。輸出的排序規則剛好是 `(欄, 列, 值)` 的字典序，所以收集所有三元組排序一次，再依欄分組。時間 `O(n log n)`。
