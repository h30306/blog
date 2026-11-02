---
title: "LeetCode 429: N-ary Tree Level Order Traversal"
summary: "LeetCode 429 解題筆記：BFS 層序遍歷，把左右小孩換成 children 清單"
description: "2026-10-24 的 LeetCode 429 解題紀錄"
date: 2026-10-24
tags: ["medium", "tree", "breadth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

和二元樹的層序遍歷一樣（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二），只是小孩從 `left`、`right` 變成 `children` 清單。每一輪先記下佇列長度，這一輪 pop 的就是同一層。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def levelOrder(self, root: 'Node') -> List[List[int]]:
        if not root:
            return []
        q = deque([root])
        res = []
        while q:
            level = []
            for _ in range(len(q)):
                node = q.popleft()
                level.append(node.val)
                q.extend(node.children)
            res.append(level)
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(w)`（最寬的一層）。

## 要特別避免的錯誤

- 空樹要回傳 `[]`。
- 一層的長度要在迴圈開始前記下來，迴圈中佇列會一直變長。

## 面試口說整理

這是 BFS 層序遍歷，每一輪先記下佇列長度，pop 這麼多個就是同一層，同時把每個節點的 children 全部放進佇列。時間 `O(n)`，空間是最寬那層的大小。
