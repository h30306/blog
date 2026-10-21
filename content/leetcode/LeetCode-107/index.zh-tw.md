---
title: "LeetCode 107: Binary Tree Level Order Traversal II"
summary: "LeetCode 107 解題筆記：一般的層序遍歷，最後把結果反轉，就是由下往上"
description: "2022-11-18 的 LeetCode 107 解題紀錄"
date: 2022-11-18
tags: ["medium", "tree", "breadth-first-search", "binary-tree"]
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
- 提交紀錄：Accepted ×2

## 解題思路

跟 LC 102 一樣一層一層收集（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二），最後把整個結果反轉，就變成從最下面那層開始。

## 我的解法

```python
class Solution:
    def levelOrderBottom(self, root: Optional[TreeNode]) -> List[List[int]]:
        res, level = [], [root] if root else []
        while level:
            res.append([n.val for n in level])
            level = [c for n in level for c in (n.left, n.right) if c]
        return res[::-1]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 反轉的是層的順序，每層裡面還是由左到右。

## 面試口說整理

我照一般的 BFS 一層一層收集，最後把層的順序反轉。時間 `O(n)`。
