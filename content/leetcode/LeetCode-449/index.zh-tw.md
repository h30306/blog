---
title: "LeetCode 449: Serialize and Deserialize BST"
summary: "LeetCode 449 解題筆記：BST 只要存前序，不用空節點標記；反序列化帶著上下界遞迴，O(n)"
description: "2026-10-25 的 LeetCode 449 解題紀錄"
date: 2026-10-25
tags: ["medium", "string", "tree", "depth-first-search", "breadth-first-search", "design", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-25
- 提交紀錄：Accepted ×3

## 解題思路

和 LC 297 的差別是：這是 **BST**，所以不需要空節點標記，序列化可以更短。

- 序列化：前序遍歷，只寫值。
- 反序列化：前序第一個是根。帶著合法範圍 `(low, high)` 遞迴（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）：下一個值不在範圍內，代表它不屬於這棵子樹，回傳 `None` 讓祖先去接。左子樹的範圍是 `(low, val)`，右子樹是 `(val, high)`。

每個值只被讀一次，所以是 `O(n)`。這和 LC 1008（由前序建 BST）是同一個做法。

## 我的嘗試

三次都一次通過：10-25 先用空白分隔、再改成逗號分隔，10-27 又重寫一次。

第一版的函式取名叫 `inorder`，但它是先 append 再遞迴，實際上是**前序**。如果真的用中序，BST 只會得到排序後的序列，所有形狀的 BST 都長一樣，還原不回來。

## 正確解法

```python
class Codec:
    def serialize(self, root: Optional[TreeNode]) -> str:
        res = []

        def preorder(node):
            if not node:
                return
            res.append(str(node.val))
            preorder(node.left)
            preorder(node.right)

        preorder(root)
        return ",".join(res)

    def deserialize(self, data: str) -> Optional[TreeNode]:
        if not data:
            return None
        vals = deque(int(x) for x in data.split(","))

        def build(low, high):
            if not vals or not low < vals[0] < high:
                return None
            val = vals.popleft()
            node = TreeNode(val)
            node.left = build(low, val)
            node.right = build(val, high)
            return node

        return build(-inf, inf)
```

## 複雜度

兩個方向都是時間 `O(n)`、空間 `O(n)`。

## 要特別避免的錯誤

- 空樹序列化成空字串，`"".split(",")` 會得到 `[""]`，`int("")` 會出錯，要先判斷。
- 序列化要用前序（或後序），不能用中序。
- 反序列化不要每層切陣列找分界，那樣最差是 `O(n^2)`。

## 面試口說整理

因為是 BST，我只存前序的值，不需要空節點標記。反序列化時第一個值是根，我帶著上下界遞迴：下一個值不在範圍內就回傳空，讓祖先接手；左子樹的上界是根的值，右子樹的下界是根的值。每個值只讀一次，時間 `O(n)`。
