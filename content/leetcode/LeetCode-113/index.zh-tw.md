---
title: "LeetCode 113: Path Sum II"
summary: "LeetCode 113 解題筆記：回溯記錄目前的路徑，到葉子時總和等於目標就存一份複本；值可能是負的，不能提早剪枝"
description: "2022-11-18 的 LeetCode 113 解題紀錄"
date: 2022-11-18
tags: ["medium", "backtracking", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-18
- 提交紀錄：Wrong Answer → Accepted → Wrong Answer → Accepted

## 解題思路

跟 LC 112 一樣往下減目標，但要記錄整條路徑（[Backtracking]({{< relref "/algorithm/Backtracking" >}})）：進入節點時把值加進路徑，到葉子時符合就存一份複本，離開時拿掉。

**節點的值可以是負的**，所以「目前總和已經超過目標」不代表後面不可能，不能剪枝。

## 我的嘗試

兩次 WA 都是同一個剪枝：`targetSum - root.val < 0` 就不往下走。但節點的值可以是負的，例如 `[4, -1]`、`targetSum = 3`：`4 - 1 = 3`，答案 `[[4, -1]]`；這版在根就剪掉了，回傳空的。

## 正確解法

```python
class Solution:
    def pathSum(self, root: Optional[TreeNode], targetSum: int) -> List[List[int]]:
        res, path = [], []
        def dfs(node, rest):
            if not node:
                return
            path.append(node.val)
            rest -= node.val
            if not node.left and not node.right and rest == 0:
                res.append(path[:])                  # 存複本
            dfs(node.left, rest)
            dfs(node.right, rest)
            path.pop()
        dfs(root, targetSum)
        return res
```

## 複雜度

時間 `O(n · h)`（複製路徑），空間 `O(h)`。

## 要特別避免的錯誤

- 值有負數時不能用「已經超過」來剪枝。
- 存答案要存複本 `path[:]`。

## 面試口說整理

我用回溯維護目前的路徑，往下時把值加進去、目標減掉，到葉子時剛好是 0 就存一份複本，離開節點時把值拿掉。值可能是負的，所以不剪枝。時間 `O(n · h)`。
