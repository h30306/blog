---
title: "LeetCode 133: Clone Graph"
summary: "LeetCode 133 解題筆記：DFS 時用雜湊表記住舊節點對應的新節點，遇到已經複製過的就直接回傳，避免無限遞迴；空圖回傳 None"
description: "2022-10-30 的 LeetCode 133 解題紀錄"
date: 2022-10-30
tags: ["medium", "hash-table", "depth-first-search", "breadth-first-search", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-30
- 提交紀錄：Runtime Error ×7 → Accepted ×2

## 解題思路

深拷貝一張可能有環的圖：`dfs(node)` 先查雜湊表，複製過就回傳那個副本；否則建立新節點，**先放進雜湊表**再遞迴複製鄰居（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})，[BFS]({{< relref "/algorithm/BFS" >}}) 也可以）。先放進表裡才能處理環。輸入是空的時回傳 `None`。

## 我的嘗試

前幾版是語法錯誤和**沒有處理空圖**：輸入是 `None` 時讀 `node.val`（AttributeError）。有一版的寫法本身是對的，但同樣漏了 `if not node`。補上就 AC 了。

## 正確解法

```python
class Solution:
    def cloneGraph(self, node: Optional['Node']) -> Optional['Node']:
        if not node:
            return None
        copies = {}
        def dfs(cur):
            if cur in copies:
                return copies[cur]
            copy = Node(cur.val)
            copies[cur] = copy
            copy.neighbors = [dfs(nb) for nb in cur.neighbors]
            return copy
        return dfs(node)
```

## 複雜度

時間 `O(V + E)`，空間 `O(V)`。

## 要特別避免的錯誤

- 先把新節點放進雜湊表再遞迴，不然環會無限遞迴。
- 空圖要回傳 `None`。

## 面試口說整理

我用 DFS 搭配雜湊表記住每個舊節點對應的新節點，建立新節點後先放進表裡再複製鄰居，這樣遇到環時會直接拿到已經建立的副本；空圖回傳 None。時間 `O(V + E)`。
