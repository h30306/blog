---
title: "LeetCode 1379: Find a Corresponding Node of a Binary Tree in a Clone of That Tree"
summary: "LeetCode 1379 解題筆記：兩棵樹同時走，原樹走到 target 時，複製樹上的同一個位置就是答案；比的是節點本身"
description: "2022-11-17 的 LeetCode 1379 解題紀錄"
date: 2022-11-17
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
第一次嘗試：2022-11-17
- 提交紀錄：Accepted ×3

## 解題思路

複製的樹結構完全一樣，所以兩棵樹**同時**用同樣的方式走（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。原樹走到 `target`（比的是節點本身，值可能重複）時，複製樹上同一步的節點就是答案。

## 我的解法

```python
class Solution:
    def getTargetCopy(self, original: TreeNode, cloned: TreeNode, target: TreeNode) -> TreeNode:
        if not original:
            return None
        if original is target:
            return cloned
        return (self.getTargetCopy(original.left, cloned.left, target)
                or self.getTargetCopy(original.right, cloned.right, target))
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 用 `is` 比較節點本身，不要比值。

## 面試口說整理

複製樹的結構一樣，所以我兩棵樹同時遞迴，原樹走到目標節點時回傳複製樹上同一個位置的節點。時間 `O(n)`。
