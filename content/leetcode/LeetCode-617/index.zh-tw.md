---
title: "LeetCode 617: Merge Two Binary Trees"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-10
tags: ["LeetCode", "daily", "easy", "tree"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-11
- 總花費時間：約 10 分鐘內

## 解題思路

我對這題的第一直覺是要建立一個新的根節點，用來儲存 `node1` 和 `node2` 的總和，並使用遞迴方式接上左右子節點。

不過在成功提交後，我發現其實不需要額外建立新的空間來放這個根節點，我可以直接使用 `root1` 或 `root2` 作為結果樹，然後把另一棵樹的值加進去即可。

## 解法

**解法一**：建立一個新的節點來合併 `root1` 和 `root2`：
```python
class Solution:
    def mergeTrees(self, root1: Optional[TreeNode], root2: Optional[TreeNode]) -> Optional[TreeNode]:
        
        def additionNodes(node, node1, node2):
            if not node1 and not node2:
                return
            
            node1 = TreeNode(0) if not node1 else node1
            node2 = TreeNode(0) if not node2 else node2

            node = TreeNode(0) 
            node.val = node1.val+node2.val
            node.left = additionNodes(node.left, node1.left, node2.left)
            node.right = additionNodes(node.right, node1.right, node2.right)

            return node

        node = None
        return additionNodes(node, root1, root2)
```
**解法二**：使用 `root1` 或 `root2` 作為結果節點，將值加在原樹上：
```python
class Solution:
    def mergeTrees(self, root1: Optional[TreeNode], root2: Optional[TreeNode]) -> Optional[TreeNode]:
        
        def additionNodes(node1, node2):
            if not node1 and not node2:
                return
            
            node1 = TreeNode(0) if not node1 else node1
            node2 = TreeNode(0) if not node2 else node2

            node1.val += node2.val
            node1.left = additionNodes(node1.left, node2.left)
            node1.right = additionNodes(node1.right, node2.right)

            return node1

        return additionNodes(root1, root2)
```

## 收穫

我原本的解法會遍歷所有的葉節點直到 `root1` 和 `root2` 都為 None 為止。但後來我發現，其實如果其中一個是 None，就可以直接回傳另一棵不為空的樹，沒必要再繼續遞迴下去。這樣可以減少遞迴次數，也稍微優化整體效能。

改進後的寫法如下：
```python
class Solution:
    def mergeTrees(self, root1: Optional[TreeNode], root2: Optional[TreeNode]) -> Optional[TreeNode]:
        if not root1 or not root2:
            return root2 or root1

        root = TreeNode(root1.val+root2.val)
        root.left = self.mergeTrees(root1.left, root2.left)
        root.right = self.mergeTrees(root1.right, root2.right)
        
        return root
```


## 遇到的問題
無。這是一個完美的解法。