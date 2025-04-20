---
title: "LeetCode 617: Merge Two Binary Trees"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-10
tags: ["LeetCode", "blog", "daily", "easy", "tree"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-11
- Total time: under 10 min


## Intuition

My intuition for this problem was to define a new root node that represents the sum of `node1` and `node2`, and then recursively attach the left and right nodes.  

After getting it accepted, I realized that I didn't actually need to create extra space for a new root node — I could simply use `root1` or `root2` as the result node and add the values from the other tree directly onto it.

## Approach

**Solution 1**: Create a new result node and combine `root1` and `root2`:
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

**Solution 2**: Use `root1` or `root2` as the result node and add the values in place:
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

## Findings

The approach I implemented traverses all the leaf nodes until both root1 and root2 are None. However, I realized that if either root1 or root2 is None, we can just return the non-None node as the result, and there's no need to continue traversing further. This could trim the recursion and slightly optimize the solution.
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

## Encountered Problems 
N/A. perfect solution
