---
title: "LeetCode 98: Validate Binary Search Tree"
summary: "LeetCode 98 解題筆記：每個節點都有一個合法範圍（下界, 上界），往左走上界變成自己、往右走下界變成自己；只比父子不夠"
description: "2022-10-29 的 LeetCode 98 解題紀錄"
date: 2022-10-29
tags: ["medium", "tree", "depth-first-search", "binary-search-tree", "binary-tree"]
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
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Accepted → Wrong Answer → Runtime Error ×3 → Wrong Answer ×3 → Accepted
- 2026-10-24 重寫：Wrong Answer → Accepted ×2 → Wrong Answer → Accepted

## 解題思路

BST 要求**整棵**左子樹都比節點小、整棵右子樹都比節點大，不只是小孩（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。往下傳一個範圍 `(lo, hi)`：

- 節點的值要嚴格在範圍內。
- 往左走，上界變成這個節點的值；往右走，下界變成這個節點的值。

## 我的嘗試

這題提交了 16 次，大部分是**只比較父節點和小孩**：例如 `[15, None, 22, 12]`，22 比 15 大、12 比 22 小，每一對父子都對；但 12 在 15 的右子樹裡，卻比 15 小，答案 `False`，回傳 `True`。其他的錯還有相等的值沒擋（`[9, 9]` 回傳 `True`）、只有一個小孩時直接回傳 `True`、回傳了 tuple。

## 正確解法

```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        def ok(node, lo, hi):
            if not node:
                return True
            if not lo < node.val < hi:
                return False
            return ok(node.left, lo, node.val) and ok(node.right, node.val, hi)
        return ok(root, float("-inf"), float("inf"))
```

## 2026-10 重寫

這次寫了三種，錯了兩次：

1. 又犯了 2022 年的錯：後序遞迴，**只比較節點和左右小孩**。`[5,4,6,null,null,3,7]` 每對父子都對，但 3 在 5 的右子樹裡卻比 5 小，回傳 `True`，答案是 `False`。
2. 改成後序回傳 `(是否合法, 子樹最小值, 子樹最大值)`，檢查 `左子樹最大 < 節點 < 右子樹最小`，過了。
3. 再寫一次上面的上下界版本，也過了。
4. 迭代中序版：`prev` 存的是上一個**值**，條件寫成 `if prev and curr.val <= prev`。上一個值剛好是 0 的時候 `prev` 是 falsy，檢查被跳過：`[0,null,0]` 回傳 `True`，答案是 `False`。
5. 改成 `prev` 存**節點**（節點物件一定是 truthy）就過了；更直接的寫法是 `prev is not None`。

```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        stack, prev, curr = [], None, root
        while curr or stack:
            while curr:
                stack.append(curr)
                curr = curr.left
            curr = stack.pop()
            if prev is not None and curr.val <= prev:
                return False
            prev = curr.val
            curr = curr.right
        return True
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。也可以中序遍歷檢查是否嚴格遞增。

## 要特別避免的錯誤

- 只比較節點和小孩不夠，孫子也可能違反祖先的範圍。
- 是嚴格大於、小於，相等的值不合法。

## 面試口說整理

BST 要整棵子樹都滿足大小關係，所以我往下傳一個合法範圍，往左走上界改成目前的值，往右走下界改成目前的值，每個節點都要嚴格在範圍內。時間 `O(n)`。
