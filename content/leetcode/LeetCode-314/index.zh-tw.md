---
title: "LeetCode 314: Binary Tree Vertical Order Traversal"
summary: "LeetCode 314 解題筆記：BFS 帶著欄位編號，用 BFS 才能保證同一欄由上到下、同一列由左到右"
description: "2026-10-22 的 LeetCode 314 解題紀錄"
date: 2026-10-22
tags: ["medium", "hash-table", "tree", "depth-first-search", "breadth-first-search", "sorting", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-22
- 提交紀錄：Accepted ×2

## 解題思路

根在第 0 欄，往左小孩欄位 -1，往右小孩 +1。依欄位由左到右輸出，同一欄裡要**由上到下**，同一列同一欄的要**由左到右**。

用 BFS（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二）帶著欄位編號走：BFS 本身就是由上到下、同一層由左到右，所以直接 append 到該欄的清單就是正確順序。最後把欄位排序輸出。

## 我的嘗試

一次通過，同一份程式碼交了兩次。

## 正確解法

```python
class Solution:
    def verticalOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        cols = defaultdict(list)
        queue = deque([(root, 0)])
        while queue:
            node, col = queue.popleft()
            if node:
                cols[col].append(node.val)
                queue.append((node.left, col - 1))
                queue.append((node.right, col + 1))
        return [cols[c] for c in sorted(cols)]
```

## 複雜度

時間 `O(n + k log k)`，`k` 是欄數；空間 `O(n)`。也可以記錄最小、最大欄位，從最小走到最大，省掉排序。

## 要特別避免的錯誤

- 用 DFS 的話，比較深的節點可能先被走到，同一欄裡的順序會錯，必須額外記列號再排序。
- 這題同一列同一欄依「左到右」；LC 987 則是依**值**排序，兩題規則不同。

## 面試口說整理

我用 BFS，每個節點帶著欄位編號，左小孩減一、右小孩加一。BFS 本身就是由上到下、同層由左到右，所以直接放進該欄的清單就符合題目的順序。最後把欄位由小到大輸出，時間 `O(n + k log k)`，記最小最大欄位的話可以到 `O(n)`。
