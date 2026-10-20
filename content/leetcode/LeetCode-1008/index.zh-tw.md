---
title: "LeetCode 1008: Construct Binary Search Tree from Preorder Traversal"
summary: "LeetCode 1008 解題筆記：切陣列遞迴 O(n^2)，帶上界遞迴 O(n)"
description: "2025-07-16 的 LeetCode 1008 解題紀錄"
date: 2025-07-16
tags: ["medium", "tree", "bst", "binary-tree", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-16
- 提交紀錄：Accepted（一次通過）

## 解題思路

Preorder 的第一個值是根。因為是 BST，後面比根小的值全部屬於左子樹，比根大的值全部屬於右子樹，兩邊各自遞迴就好。

## 我的解法：把陣列切兩半再遞迴

```python
class Solution:
    def bstFromPreorder(self, preorder: List[int]) -> Optional[TreeNode]:
        if not preorder:
            return None

        root = TreeNode(preorder[0], None, None)
        left = []
        right = []
        for node in preorder[1:]:
            if node < root.val:
                left.append(node)
            else:
                right.append(node)

        if left:
            root.left = self.bstFromPreorder(left)
        if right:
            root.right = self.bstFromPreorder(right)
        return root
```

正確，`n <= 100` 也很快。但每一層都要掃過剩下的陣列並建新的 list，遇到**已排序的輸入**（樹退化成一條鏈）會變成 `O(n^2)`。

## 更好的解法：帶上界遞迴，O(n)

依照 preorder 的順序一個一個取值，同時告訴遞迴「這棵子樹的值不能超過多少」：

- 左子樹的上界是根的值。
- 右子樹沿用父節點傳下來的上界。
- 下一個值超過上界時，代表它不屬於這棵子樹，回傳 `None` 讓上一層處理。

```python
class Solution:
    def bstFromPreorder(self, preorder: List[int]) -> Optional[TreeNode]:
        i = 0

        def build(bound: float) -> Optional[TreeNode]:
            nonlocal i
            if i == len(preorder) or preorder[i] > bound:
                return None
            root = TreeNode(preorder[i])
            i += 1
            root.left = build(root.val)
            root.right = build(bound)
            return root

        return build(float("inf"))
```

每個值只被取一次，所以是 `O(n)`。

## 複雜度

| 解法 | 時間 | 空間 |
|---|---|---|
| 切陣列遞迴 | 最壞 `O(n^2)` | `O(n^2)`（每層新建 list） |
| 帶上界遞迴 | `O(n)` | `O(h)` 遞迴深度 |

## 要特別避免的錯誤

- `i` 在巢狀函式裡被重新賦值，要用 `nonlocal`。
- 左子樹的上界寫成 `bound` 而不是 `root.val`，會把右子樹的值也收進左邊。

## 面試口說整理

Preorder 第一個值是根，後面比它小的屬於左子樹。直接切陣列遞迴是 `O(n^2)`，所以我改成依序取值，並帶著上界遞迴：左子樹上界是根的值，右子樹沿用原本的上界；下一個值超過上界就回傳 `None`。每個值只處理一次，時間 `O(n)`。
