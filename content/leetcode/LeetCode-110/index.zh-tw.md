---
title: "LeetCode 110: Balanced Binary Tree"
summary: "LeetCode 110 解題筆記：每一個節點的左右高度差都不能超過 1；後序回傳高度，不平衡時回傳 -1 一路傳上去"
description: "2022-08-16 的 LeetCode 110 解題紀錄"
date: 2022-08-16
tags: ["easy", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-16
- 提交紀錄：Wrong Answer → Runtime Error ×2 → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error ×2 → Accepted → Wrong Answer ×2 → Accepted ×2 → Runtime Error → Accepted → Time Limit Exceeded → Accepted ×2 → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error ×2

## 解題思路

平衡要求**每一個節點**都平衡，不只是根（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。後序回傳子樹的高度，一旦發現某個節點不平衡就回傳 `-1`，上面的節點看到 `-1` 直接往上傳，這樣只要走一次，`O(n)`。

## 我的嘗試

這題 2022 年提交了 18 次，2026 年重寫時又錯了 5 次：

- 很多次是空樹沒處理（`None.left`），或用了沒定義的變數。
- 有兩版**只檢查根**的左右高度差：`abs(depth(root.left) - depth(root.right)) <= 1`。例如 `[5, 5, 1, 5, None, 5, 3, 4]`：根兩邊高度差 1，但左子樹的根左邊有兩層、右邊是空的，答案 `False`，回傳 `True`。
- 2026 年的幾版都還是在空樹時出錯。

## 正確解法

```python
class Solution:
    def isBalanced(self, root: Optional[TreeNode]) -> bool:
        def height(node):
            if not node:
                return 0
            l, r = height(node.left), height(node.right)
            if l < 0 or r < 0 or abs(l - r) > 1:
                return -1                            # 已經不平衡
            return 1 + max(l, r)
        return height(root) >= 0
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 只檢查根的左右高度差不夠，下面的節點也要平衡。
- 每個節點都重新算高度是 `O(n²)`；用 `-1` 往上傳只要 `O(n)`。

## 面試口說整理

平衡要每個節點都平衡，所以我用後序回傳高度，發現不平衡就回傳 `-1` 一路往上傳，最後看根的結果是不是 `-1`。只走一次，時間 `O(n)`。
