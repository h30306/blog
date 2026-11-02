---
title: "LeetCode 863: All Nodes Distance K in Binary Tree"
summary: "LeetCode 863 解題筆記：先把樹轉成無向圖（補上往父節點的邊），再從 target BFS 走 k 步"
description: "2026-10-28 的 LeetCode 863 解題紀錄"
date: 2026-10-28
tags: ["medium", "hash-table", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-28
- 提交紀錄：Accepted（一次通過）

## 解題思路

距離 `k` 的節點可能在 target 的子樹裡，也可能要先往上走到祖先再往下。樹只有往下的指標，所以先把它轉成**無向圖**（[Tree]({{< relref "/algorithm/Tree" >}}) 模板五）：DFS 一遍，每條父子邊兩個方向都記下來。節點的值都不同，可以直接用值當圖的節點。

接著從 target 做 BFS，第 `k` 層的節點就是答案。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def distanceK(self, root: TreeNode, target: TreeNode, k: int) -> List[int]:
        adj = defaultdict(list)

        def dfs(node):
            for child in (node.left, node.right):
                if child:
                    adj[node.val].append(child.val)
                    adj[child.val].append(node.val)
                    dfs(child)

        dfs(root)
        seen = {target.val}
        level = [target.val]
        for _ in range(k):
            nxt = []
            for node in level:
                for nei in adj[node]:
                    if nei not in seen:
                        seen.add(nei)
                        nxt.append(nei)
            level = nxt
        return level
```

我當時的寫法是在 pop 時才檢查 `seen`、`dist > k` 就停，結果一樣；上面這個版本在放進佇列時就標記，同一個節點不會重複進佇列。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只往下找會漏掉要經過父節點的那些節點。
- BFS 要記 `seen`，無向圖會走回頭路。
- 也可以只記 `parent` 指標，不用建完整的鄰接表。

## 面試口說整理

距離 `k` 的節點可能要先往上走，所以我先 DFS 把樹轉成無向圖，每條父子邊都加兩個方向。然後從 target 做 BFS，用 `seen` 避免走回頭，走 `k` 層之後佇列裡的節點就是答案。時間、空間都是 `O(n)`。
