---
title: "LeetCode 988: Smallest String Starting From Leaf"
summary: "LeetCode 988 解題筆記：DFS 時把字元加在字串前面，到葉子時就是「從葉子到根」的字串，取最小的"
description: "2024-04-17 的 LeetCode 988 解題紀錄"
date: 2024-04-17
tags: ["medium", "string", "backtracking", "tree", "depth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2024-04-17
- 提交紀錄：Accepted（一次通過）

## 解題思路

字串是從葉子讀到根，所以往下走時把字元**加在前面**（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一），到葉子時就是完整的字串，跟目前最小的比。不能在每個節點取左右較小的再往上接，因為接上前綴之後大小關係可能改變。

## 我的解法

```python
class Solution:
    def smallestFromLeaf(self, root: Optional[TreeNode]) -> str:
        best = None
        def dfs(node, s):
            nonlocal best
            if not node:
                return
            s = chr(ord("a") + node.val) + s
            if not node.left and not node.right:
                if best is None or s < best:
                    best = s
            dfs(node.left, s)
            dfs(node.right, s)
        dfs(root, "")
        return best
```

## 複雜度

時間 `O(n · h)`，空間 `O(h)`。

## 要特別避免的錯誤

- 方向是從葉子到根，字元要加在前面。

## 面試口說整理

我用 DFS 往下走，每到一個節點把字元加在字串前面，到葉子時這就是從葉子到根的字串，跟目前最小的比較。時間 `O(n · h)`。
