---
title: "LeetCode 2196: Create Binary Tree From Descriptions"
summary: "LeetCode 2196 解題筆記：用 dict 存節點一次連好，根是唯一不是任何人子節點的值"
description: "2026-06-26 的 LeetCode 2196 解題紀錄"
date: 2026-06-26
tags: ["medium", "tree", "binary-tree", "hash-map"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-26
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩件事：

1. **找根**：根是唯一「出現過，但從來不是任何人的子節點」的值。
2. **建樹**：依照描述把子節點接到父節點的左邊或右邊。

## 我的解法：先建 parent → children 表，再遞迴建樹

```python
from collections import defaultdict

class Solution:
    def createBinaryTree(self, descriptions: List[List[int]]) -> Optional[TreeNode]:
        parent_map = defaultdict(list)
        child_set = set()
        for parent, child, isLeft in descriptions:
            parent_map[parent].append((child, isLeft))
            child_set.add(child)

        root = (set(parent_map.keys()) - child_set).pop()

        def build_tree(node):
            if node.val not in parent_map:
                return node
            for child, isLeft in parent_map[node.val]:
                if isLeft:
                    node.left = build_tree(TreeNode(child))
                else:
                    node.right = build_tree(TreeNode(child))
            return node

        return build_tree(TreeNode(root))
```

正確。不過有個隱憂：描述最多 `10^4` 筆，如果樹退化成一條鏈，遞迴深度會到 `10^4`，超過 Python 預設的遞迴上限。

## 改進版：dict 存節點，一次迴圈連好

不需要遞迴：用 dict 記住每個值對應的節點，看到描述就直接連起來。

```python
class Solution:
    def createBinaryTree(self, descriptions: List[List[int]]) -> Optional[TreeNode]:
        nodes = {}
        children = set()
        for parent, child, is_left in descriptions:
            if parent not in nodes:
                nodes[parent] = TreeNode(parent)
            if child not in nodes:
                nodes[child] = TreeNode(child)
            if is_left:
                nodes[parent].left = nodes[child]
            else:
                nodes[parent].right = nodes[child]
            children.add(child)

        root = next(v for v in nodes if v not in children)
        return nodes[root]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`，`n` 是描述的筆數。

## 要特別避免的錯誤

- 每看到一個值就 `TreeNode(...)` 新建一個：同一個值會變成好幾個不同的節點，樹會斷掉。
- 遞迴建樹在鏈狀樹上撞到遞迴上限。

## 面試口說整理

我用 dict 把每個值對應到唯一的節點，掃一次描述就把子節點接到父節點的左邊或右邊，同時記錄出現過的子節點。根就是唯一不在子節點集合裡的值。不用遞迴，所以沒有遞迴深度問題，時間和空間都是 `O(n)`。
