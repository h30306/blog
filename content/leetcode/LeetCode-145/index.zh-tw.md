---
title: "LeetCode 145: Binary Tree Postorder Traversal"
summary: "LeetCode 145 解題筆記：迭代的後序遍歷，節點第一次彈出時標記後放回去，再依序推右、左小孩；第二次彈出才記錄"
description: "2022-08-20 的 LeetCode 145 解題紀錄"
date: 2022-08-20
tags: ["easy", "stack", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-20
- 提交紀錄：Runtime Error ×3 → Accepted ×3 → Runtime Error ×2 → Wrong Answer ×2 → Accepted ×2

## 解題思路

後序是「左、右、根」，根要等兩個小孩都處理完才記錄（[Tree]({{< relref "/algorithm/Tree" >}})）。在 stack 裡放 `(node, visited)`：

- 第一次彈出（`visited = False`）：把自己標成 `True` 放回去，再推**右**小孩、**左**小孩（左的後進，會先處理）。
- 第二次彈出（`visited = True`）：兩個小孩都處理完了，記錄。

## 我的嘗試

空樹時前幾版直接回傳 `None`；一版把節點本身放進答案而不是值；一版推小孩的順序是先左後右，**右邊反而先處理**，例如根 9、左 8、右 5：答案 `[8, 5, 9]`，回傳 `[5, 8, 9]`。

## 正確解法

```python
class Solution:
    def postorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res, stack = [], [(root, False)]
        while stack:
            node, visited = stack.pop()
            if not node:
                continue
            if visited:
                res.append(node.val)
            else:
                stack.append((node, True))
                stack.append((node.right, False))
                stack.append((node.left, False))
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 推小孩的順序：先右後左，左邊才會先處理。
- 回傳的是值，不是節點。

## 面試口說整理

後序要等左右都處理完才記錄根，所以我在 stack 裡放「節點加上是否已經展開過」。第一次彈出時把自己放回去並推右、左小孩，第二次彈出才記錄。時間 `O(n)`。
