---
title: "LeetCode 105: Construct Binary Tree from Preorder and Inorder Traversal"
summary: "LeetCode 105 解題筆記：前序的第一個是根，在中序裡找到根的位置就知道左子樹有幾個節點；用字典查位置，O(n)"
description: "2022-10-29 的 LeetCode 105 解題紀錄"
date: 2022-10-29
tags: ["medium", "array", "hash-table", "divide-and-conquer", "tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-29
- 提交紀錄：Runtime Error ×4 → Wrong Answer → Accepted ×3 → Runtime Error → Accepted ×2 → Runtime Error → Accepted

## 解題思路

前序是「根、左、右」，所以目前範圍的第一個就是根；中序是「左、根、右」，根左邊的就是左子樹（[Tree]({{< relref "/algorithm/Tree" >}})）。

- 用字典記住每個值在中序的位置。
- 用一個指標依序取前序的值當根，先建左子樹再建右子樹（前序的順序就是這樣）。
- 中序的範圍 `[lo, hi]` 決定子樹裡有哪些節點，範圍是空的就回傳 `None`。

## 我的嘗試

前幾版是切片寫法，一直出現 index 超出範圍、`pop` 空的 list、變數沒定義的錯；一版建節點時寫成 `TreeNode(index_root_node)`，**用的是中序的 index 而不是值**，例如 `[8]` 回傳 `[0]`。

## 正確解法

```python
class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        pos = {v: i for i, v in enumerate(inorder)}
        it = iter(preorder)
        def build(lo, hi):
            if lo > hi:
                return None
            val = next(it)
            root = TreeNode(val)
            root.left = build(lo, pos[val] - 1)          # 先建左子樹
            root.right = build(pos[val] + 1, hi)
            return root
        return build(0, len(inorder) - 1)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 節點的值是 `preorder` 裡的值，不是它在中序的 index。
- 一定要先建左子樹，前序的指標才會對。
- 每次用 `list.index` 找位置是 `O(n)`，整體變 `O(n²)`；用字典是 `O(1)`。

## 面試口說整理

前序的第一個是根，它在中序的位置把中序切成左右子樹。我用字典記中序的位置，依序從前序取根，先遞迴建左子樹再建右子樹。時間 `O(n)`。
