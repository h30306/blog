---
title: "LeetCode 124: Binary Tree Maximum Path Sum"
summary: "LeetCode 124 解題筆記：DFS 回傳往下的一條鏈，在每個節點用「左鏈 + 自己 + 右鏈」更新答案；負的鏈要丟掉"
description: "2026-10-24 的 LeetCode 124 解題紀錄"
date: 2026-10-24
tags: ["hard", "dynamic-programming", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-24
- 提交紀錄：Wrong Answer ×4 → Accepted

## 解題思路

路徑可以在任何一個節點「轉彎」。用 DFS 回傳值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）：

- `dfs(node)` 回傳「從 `node` 往下走一條鏈」的最大和。往上回傳只能選一邊，因為路徑不能分叉。
- 在每個節點，用「左鏈 + 自己 + 右鏈」更新答案，這是在這裡轉彎的最大路徑。
- 子鏈是負的就不要拿，當成 0：`left = max(0, dfs(node.left))`。

答案初始值要是 `-inf`，因為所有值都可能是負的。

## 我的嘗試

錯了四次才過，都是負數處理的問題：

1. 沒有把負的鏈丟掉：`[-2,-5]` 回傳 -5，答案是 -2。根節點 -2 自己一個就是 -2，但更新答案時硬把左鏈 -5 加進去。
2. 多加一個候選 `node.val`：`[1,5,-3]` 回傳 5，答案是 6（5 → 1）。更新答案時還是硬加兩邊（`5 + 1 - 3 = 3`），沒有考慮只拿左邊。
3. 回傳值改成 `max(left + val, right + val, val)`，但更新答案時還是加兩邊：`[3,-4]` 回傳 -1，答案是 3。第四次交了一模一樣的程式碼。
4. 把左右鏈先用 `max(0, ...)` 截掉，才過。

## 正確解法

```python
class Solution:
    def maxPathSum(self, root: Optional[TreeNode]) -> int:
        best = -inf

        def dfs(node):
            nonlocal best
            if not node:
                return 0
            left = max(0, dfs(node.left))
            right = max(0, dfs(node.right))
            best = max(best, left + right + node.val)
            return max(left, right) + node.val

        dfs(root)
        return best
```

左右鏈已經截成非負，回傳 `max(left, right) + node.val` 就夠了。

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 往上回傳的是**一條鏈**（只能選一邊），更新答案的才是**兩邊加起來**。這兩個值不一樣。
- 子鏈是負的要當成 0，不然會被迫拿進來。
- 答案初始值用 `-inf`，不能用 0：全部是負數時答案是最大的那個負數。

## 面試口說整理

我用後序 DFS，每個節點回傳往下一條鏈的最大和，負的鏈直接當 0。在每個節點把左鏈、自己、右鏈加起來更新答案，這是在這個節點轉彎的最佳路徑；往上只回傳較大的一邊加自己，因為路徑不能分叉。答案從 `-inf` 開始，時間 `O(n)`，空間 `O(h)`。
