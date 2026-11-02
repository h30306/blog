---
title: "LeetCode 515: Find Largest Value in Each Tree Row"
summary: "LeetCode 515 解題筆記：BFS 層序遍歷，每層取最大值；初始值用 -inf"
description: "2026-10-24 的 LeetCode 515 解題紀錄"
date: 2026-10-24
tags: ["medium", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
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

BFS 層序遍歷（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二），每一層記一個最大值。值的範圍包含負數（到 `-2^31`），所以每層的初始值要用 `-inf`。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def largestValues(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return []
        res = []
        queue = deque([root])
        while queue:
            best = -inf
            for _ in range(len(queue)):
                node = queue.popleft()
                best = max(best, node.val)
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)
            res.append(best)
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(w)`。

## 要特別避免的錯誤

- 每層的最大值初始成 0 會錯，整層都是負數時答案是負的。
- 空樹回傳 `[]`。

## 面試口說整理

BFS 一層一層走，每層從 `-inf` 開始取最大值，因為值可以是負的。時間 `O(n)`，空間是最寬那層。也可以用 DFS 帶著深度，`res[depth] = max(res[depth], val)`。
