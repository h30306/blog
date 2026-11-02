---
title: "LeetCode 297: Serialize and Deserialize Binary Tree"
summary: "LeetCode 297 解題筆記：前序遍歷加上空節點標記就能唯一還原樹；反序列化用迭代器依序取值"
description: "2026-10-25 的 LeetCode 297 解題紀錄"
date: 2026-10-25
tags: ["hard", "string", "tree", "depth-first-search", "breadth-first-search", "design", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-25
- 提交紀錄：Accepted ×2

## 解題思路

只有前序遍歷不能決定樹的形狀，但**把空節點也寫出來**就可以了。序列化：前序 DFS，空節點寫 `#`，用逗號分隔（值可能是負數或多位數）。

反序列化用同樣的前序順序讀回來：

- 讀到 `#` 就回傳 `None`。
- 否則建節點，先遞迴建左子樹，再建右子樹。

因為每個子樹都會以 `#` 收尾，遞迴自然知道左子樹在哪裡結束，不需要額外的長度資訊。

## 我的嘗試

2026-10-25 一次通過，10-27 又練了一次，把空節點從 `N` 改成 `#`、迭代器改成 `deque`，也一次過。

## 正確解法

```python
class Codec:
    def serialize(self, root):
        res = []

        def dfs(node):
            if not node:
                res.append("#")
                return
            res.append(str(node.val))
            dfs(node.left)
            dfs(node.right)

        dfs(root)
        return ",".join(res)

    def deserialize(self, data):
        vals = iter(data.split(","))

        def dfs():
            val = next(vals)
            if val == "#":
                return None
            node = TreeNode(int(val))
            node.left = dfs()
            node.right = dfs()
            return node

        return dfs()
```

## 複雜度

兩個方向都是時間 `O(n)`、空間 `O(n)`。

## 要特別避免的錯誤

- 不寫空節點標記，前序（或中序）會對應到多種樹。
- 不用分隔符號直接把數字接起來，負數和多位數就分不開。
- 用 `list.pop(0)` 取值是 `O(n)`，整體變 `O(n^2)`；用迭代器或 `deque`。
- 樹很歪的時候遞迴會很深，要避免的話可以改用 BFS 層序序列化。

## 面試口說整理

我用前序 DFS 序列化，空節點寫 `#`，用逗號隔開。反序列化時照同樣的前序順序讀：讀到 `#` 回傳空，否則建節點再依序遞迴建左、右子樹。因為空節點都有標記，遞迴自己知道每個子樹在哪結束。兩邊都是 `O(n)`。
