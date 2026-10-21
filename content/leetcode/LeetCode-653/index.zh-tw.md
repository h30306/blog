---
title: "LeetCode 653: Two Sum IV - Input is a BST"
summary: "LeetCode 653 解題筆記：遍歷時用集合記看過的值，k - val 已經在集合裡就找到了"
description: "2022-08-29 的 LeetCode 653 解題紀錄"
date: 2022-08-29
tags: ["easy", "hash-table", "two-pointers", "tree", "depth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-29
- 提交紀錄：Runtime Error → Accepted ×3 → Wrong Answer → Runtime Error → Accepted

## 解題思路

跟 Two Sum 一樣，用集合記住看過的值（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。遍歷每個節點時，先看 `k - val` 有沒有出現過，有就回傳 `True`，再把自己加進去。用中序加雙指針也可以利用 BST 的排序性質，但集合最簡單。

## 我的嘗試

第一版變數沒定義。我 AC 的版本多了 `if k == 0: return False`，但 `k` 可以是 0、樹裡也可能同時有 -1 和 1，這個判斷其實是錯的，只是剛好沒被測到；11 月重寫時一版沒有回傳值。

## 正確解法

```python
class Solution:
    def findTarget(self, root: Optional[TreeNode], k: int) -> bool:
        seen, stack = set(), [root]
        while stack:
            node = stack.pop()
            if not node:
                continue
            if k - node.val in seen:
                return True
            seen.add(node.val)
            stack += [node.left, node.right]
        return False
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 要先查再加，不然同一個節點會跟自己配對。
- `k` 可以是 0（例如 -1 和 1），不要把 `k == 0` 當成不可能。

## 面試口說整理

我遍歷整棵樹，用集合記看過的值，每到一個節點先檢查 `k - val` 是否已經看過，再把自己加進集合。時間和空間都是 `O(n)`。
