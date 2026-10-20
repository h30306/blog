---
title: "LeetCode 958: Check Completeness of a Binary Tree"
summary: "LeetCode 958 解題筆記：完整性是整體性質，用 BFS 檢查第一個空位之後還有沒有節點"
description: "2025-07-16 的 LeetCode 958 解題紀錄"
date: 2025-07-16
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
第一次嘗試：2025-07-16
- 提交紀錄：Wrong Answer → Accepted（隔天）

## 解題思路

完整二元樹的定義是：除了最後一層，每層都填滿；最後一層的節點都靠左。

換成 BFS 的角度：**用層序把節點（包含空的子節點）排成一排，第一個空位出現之後，後面就不能再有任何真正的節點。**

## 我的第一版：遞迴檢查左右子樹

```python
def isCompleteTree(self, root):
    if root.val == None:
        return True
    completed_left = False
    completed_right = False
    if root.left:
        completed_left = self.isCompleteTree(root.left)
    if root.right:
        completed_right = self.isCompleteTree(root.right)

    completed = True
    if root.left and root.right:
        if not completed_left or not completed_right:
            completed = False
    else:
        if not completed_left and completed_right:
            completed = False
    return completed
```

錯在把**整體性質當成局部性質**。左右子樹各自完整，不代表合起來完整。例如左子樹高度 2、右子樹高度 3，兩邊各自都是完整樹，但整棵樹的最後一層不會全部靠左。

要用遞迴做，必須額外回傳高度和「是否是滿樹」，條件會變得很複雜。換成 BFS 反而直接。

另外 `root.val == None` 判斷的是節點的值，不是節點本身，這行沒有作用。

## 正確解法

```python
from collections import deque

class Solution:
    def isCompleteTree(self, root: Optional[TreeNode]) -> bool:
        if not root:
            return True

        q = deque([root])
        while q[0] is not None:          # 一路走到第一個空位
            node = q.popleft()
            q.append(node.left)          # 刻意把 None 也放進去
            q.append(node.right)

        while q and q[0] is None:        # 把連續的空位清掉
            q.popleft()

        return not q                     # 空位後面還有節點就不完整
```

這是少數**刻意把 `None` 放進 queue** 的 BFS。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 用「左右子樹各自完整」推出整棵樹完整。
- 判斷 `root.val == None` 想表達的其實是 `root is None`。

## 面試口說整理

完整二元樹在層序遍歷中，第一個空位之後不能再出現任何節點。所以我用 BFS，把空的子節點也放進 queue，一直走到第一個 `None`。接著把連續的 `None` 清掉，如果 queue 還有東西，代表空位後面還有節點，就不是完整樹。時間和空間都是 `O(n)`。
