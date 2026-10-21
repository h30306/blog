---
title: "LeetCode 103: Binary Tree Zigzag Level Order Traversal"
summary: "LeetCode 103 解題筆記：一般的層序遍歷，奇數層的結果反轉就是之字形"
description: "2022-11-18 的 LeetCode 103 解題紀錄"
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
- 提交紀錄：Accepted（一次通過）

## 解題思路

一樣一層一層收集（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二），第 0、2、4… 層由左到右，第 1、3、5… 層反轉。產生下一層的順序不用改，只改記錄的方向。

## 我的解法

```python
class Solution:
    def zigzagLevelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        res, level = [], [root] if root else []
        while level:
            vals = [n.val for n in level]
            res.append(vals if len(res) % 2 == 0 else vals[::-1])
            level = [c for n in level for c in (n.left, n.right) if c]
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(w)`。

## 要特別避免的錯誤

- 只反轉記錄的值，不要反轉產生下一層的順序。

## 面試口說整理

我照一般的 BFS 一層一層走，奇數層記錄時反轉，產生下一層的順序不變。時間 `O(n)`。
