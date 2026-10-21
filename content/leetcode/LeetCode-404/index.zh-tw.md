---
title: "LeetCode 404: Sum of Left Leaves"
summary: "LeetCode 404 解題筆記：DFS 時告訴小孩自己是不是左小孩，只有「是左小孩而且是葉子」才加"
description: "2022-08-23 的 LeetCode 404 解題紀錄"
date: 2022-08-23
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Runtime Error → Wrong Answer ×3 → Accepted ×3

## 解題思路

判斷「左葉子」需要兩個資訊：是葉子、而且是父節點的**左**小孩（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。往下走時多傳一個布林值 `is_left`，到葉子時看它決定要不要加。

## 我的嘗試

有兩版用字串 `'True'`、`'False'` 標記左右，但**字串 `'False'` 也是真值**，右葉子也被加進去了。例如 `[4, 6, 9]`：只有 6 是左葉子，答案 6，回傳 15。

## 正確解法

```python
class Solution:
    def sumOfLeftLeaves(self, root: Optional[TreeNode]) -> int:
        def dfs(node, is_left):
            if not node:
                return 0
            if not node.left and not node.right:
                return node.val if is_left else 0
            return dfs(node.left, True) + dfs(node.right, False)
        return dfs(root, False)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 根本身就算是葉子，也不是左葉子。
- 布林值要用 `True` / `False`，字串 `'False'` 是真值。

## 面試口說整理

我在 DFS 時多傳一個「是不是左小孩」，只有在葉子而且是左小孩時才把值加進來。時間 `O(n)`。
