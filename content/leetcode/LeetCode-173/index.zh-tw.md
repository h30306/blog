---
title: "LeetCode 173: Binary Search Tree Iterator"
summary: "LeetCode 173 解題筆記：攤平成陣列很直接但用 O(n) 空間；follow-up 用 stack 存左側鏈，均攤 O(1)、空間 O(h)"
description: "2026-10-24 的 LeetCode 173 解題紀錄"
date: 2026-10-24
tags: ["medium", "stack", "tree", "design", "binary-search-tree", "binary-tree", "iterator"]
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

`next()` 要依中序順序回傳 BST 的值。

最直接的做法：建構時中序走一遍，把值存進陣列，`next()` 就是讀下一個。

題目的 follow-up 要求 `next()` 和 `hasNext()` 平均 `O(1)`、空間 `O(h)`。做法是把迭代版中序拆開（[Tree]({{< relref "/algorithm/Tree" >}}) 模板八）：

- stack 裡放「還沒輸出的左側鏈」。建構時把根一路往左推進去。
- `next()`：pop 一個節點，它就是下一個最小值；再把它右子樹的左側鏈推進去。

## 我的嘗試

一次通過，用的是攤平成陣列的版本。

```python
class BSTIterator:
    def __init__(self, root: Optional[TreeNode]):
        self.nodes = []
        self.curr = 0

        def dfs(node):
            if not node:
                return
            dfs(node.left)
            self.nodes.append(node.val)
            dfs(node.right)

        dfs(root)

    def next(self) -> int:
        node = self.nodes[self.curr]
        self.curr += 1
        return node

    def hasNext(self) -> bool:
        return self.curr < len(self.nodes)
```

## 正確解法：stack，空間 O(h)

```python
class BSTIterator:
    def __init__(self, root: Optional[TreeNode]):
        self.stack = []
        self._push_left(root)

    def _push_left(self, node):
        while node:
            self.stack.append(node)
            node = node.left

    def next(self) -> int:
        node = self.stack.pop()
        self._push_left(node.right)
        return node.val

    def hasNext(self) -> bool:
        return bool(self.stack)
```

## 複雜度

| 做法 | `next()` | 空間 |
|---|---|---|
| 攤平成陣列 | `O(1)` | `O(n)` |
| stack | 均攤 `O(1)`，最差 `O(h)` | `O(h)` |

stack 版每個節點只會被 push、pop 各一次，所以 `n` 次 `next()` 總共 `O(n)`。

## 要特別避免的錯誤

- 攤平版雖然會過，面試一定會被追問 `O(h)` 空間的做法。
- `next()` pop 之後要記得處理右子樹，不然會漏掉右邊的節點。

## 面試口說整理

最簡單是建構時中序攤平成陣列，但空間是 `O(n)`。要 `O(h)` 的話，我用 stack 模擬迭代版中序：建構時把左側鏈推進 stack，`next()` pop 出來的就是下一個最小值，再把它右子樹的左側鏈推進去。每個節點只進出 stack 一次，所以 `next()` 均攤 `O(1)`，空間 `O(h)`。
