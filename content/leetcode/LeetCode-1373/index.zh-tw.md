---
title: "LeetCode 1373: Maximum Sum BST in Binary Tree"
summary: "LeetCode 1373 解題筆記：後序遍歷回傳 (總和, 最小值, 最大值, 是不是 BST)；左子樹的最大值 < 自己 < 右子樹的最小值才是 BST"
description: "2026-09-10 的 LeetCode 1373 解題紀錄"
date: 2026-09-10
tags: ["hard", "dynamic-programming", "tree-dp", "binary-search-tree", "depth-first-search", "tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-10
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

判斷一個子樹是不是 BST，需要知道左右子樹的**範圍**。後序遍歷，每個節點回傳 `(sum, lo, hi, is_bst)`：

- 空節點：`(0, +inf, -inf, True)`，這樣任何值都能通過比較。
- `is_bst` = 左右都是 BST，而且 **左子樹的最大值 `<` `node.val` `<` 右子樹的最小值**。
- 是 BST：總和是左 + 右 + 自己，更新答案；範圍是 `(min(lo_left, val), max(hi_right, val))`。
- 不是：回傳 `is_bst = False`，父節點一定也不是。

答案至少是 0（空的子樹）。

## 我的嘗試

第一版每個子樹只回傳了最大值，跟右子樹比較時用的是右子樹的**最大值**，應該是右子樹的**最小值**。例如這棵樹：`2` 的右孩子是 `8`、`8` 的左孩子是 `-2`。`-2 < 2`，整棵不是 BST；答案是右子樹 `8 + (-2) = 6`。這版用 `2 < 8`（右子樹最大值）判斷，把整棵當成 BST，回傳 8。

改成同時回傳最小值和最大值就 AC 了。

## 正確解法

```python
class Solution:
    def maxSumBST(self, root: Optional[TreeNode]) -> int:
        best = 0

        def dfs(node: Optional[TreeNode]):
            nonlocal best
            if not node:
                return 0, float("inf"), float("-inf"), True
            ls, llo, lhi, lok = dfs(node.left)
            rs, rlo, rhi, rok = dfs(node.right)
            if lok and rok and lhi < node.val < rlo:   # 左邊最大 < 自己 < 右邊最小
                total = ls + rs + node.val
                best = max(best, total)
                return total, min(llo, node.val), max(rhi, node.val), True
            return 0, 0, 0, False

        dfs(root)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 跟右子樹的最大值比：要比的是右子樹的最小值。
- 空節點的範圍是 `(+inf, -inf)`，不然葉子沒辦法通過比較。
- 答案可能是 0：所有的 BST 和都是負的時候，選空的子樹。

## 面試口說整理

我用後序遍歷，每個節點回傳子樹的總和、最小值、最大值和是不是 BST。左右都是 BST，而且左子樹的最大值小於自己、右子樹的最小值大於自己，這個子樹才是 BST，這時更新答案。空節點回傳正無限大和負無限大當範圍。時間 `O(n)`。
