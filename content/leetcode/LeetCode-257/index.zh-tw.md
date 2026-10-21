---
title: "LeetCode 257: Binary Tree Paths"
summary: "LeetCode 257 解題筆記：DFS 帶著目前的路徑字串往下，到葉子時把整條路徑加進答案"
description: "2022-08-22 的 LeetCode 257 解題紀錄"
date: 2022-08-22
tags: ["easy", "string", "backtracking", "tree", "depth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-22
- 提交紀錄：Runtime Error ×3 → Accepted ×2

## 解題思路

DFS 時把路徑一起往下傳（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一），到葉子時就是一條完整的路徑。節點的值是整數，接成字串前要先 `str()`。

## 我的嘗試

前三版都是 TypeError：把整數 `node.val` 直接跟字串 `"->"` 相加。

## 正確解法

```python
class Solution:
    def binaryTreePaths(self, root: Optional[TreeNode]) -> List[str]:
        res = []
        def dfs(node, path):
            if not node:
                return
            path = path + [str(node.val)]
            if not node.left and not node.right:
                res.append("->".join(path))
            dfs(node.left, path)
            dfs(node.right, path)
        dfs(root, [])
        return res
```

## 複雜度

時間 `O(n · h)`，空間 `O(h)`。

## 要特別避免的錯誤

- 整數不能直接跟字串相加，要先 `str()`。

## 面試口說整理

我用 DFS 帶著目前的路徑往下，到葉子時用 `->` 把路徑接成字串加進答案。時間 `O(n · h)`。
