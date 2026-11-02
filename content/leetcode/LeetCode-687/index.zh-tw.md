---
title: "LeetCode 687: Longest Univalue Path"
summary: "LeetCode 687 解題筆記：DFS 回傳往下同值的最長鏈（邊數），在每個節點用左 + 右更新答案"
description: "2026-10-24 的 LeetCode 687 解題紀錄"
date: 2026-10-24
tags: ["medium", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
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
- 提交紀錄：Wrong Answer ×2 → Accepted ×2

## 解題思路

和直徑（LC 543）一樣是 DFS 回傳值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一），只是多了「值要相同」的條件：

- `dfs(node)` 回傳從 `node` 往下、值都等於 `node.val` 的最長鏈（邊數）。
- 左小孩的值和自己相同，`left = dfs(node.left) + 1`，否則 `left = 0`。右邊一樣。
- 在 `node` 轉彎的路徑長度是 `left + right`，用來更新答案；往上回傳 `max(left, right)`。

## 我的嘗試

1. 遞迴時把 `node`（節點物件）當成父節點的值傳下去，`node.val == parent` 永遠是 `False`，每個節點都回傳 0：`[2,2]` 回傳 0，答案是 1。
2. 改成傳 `node.val`，但空樹時回傳 `0 - 1 = -1`，答案是 0。
3. 加上空樹判斷就過了。
4. 再改寫成直接數邊數、不用傳父節點值的版本，也過了。

## 正確解法

```python
class Solution:
    def longestUnivaluePath(self, root: Optional[TreeNode]) -> int:
        self.longest = 0

        def dfs(node):
            if not node:
                return 0
            left_len = dfs(node.left)
            right_len = dfs(node.right)
            left = left_len + 1 if node.left and node.left.val == node.val else 0
            right = right_len + 1 if node.right and node.right.val == node.val else 0
            self.longest = max(self.longest, left + right)
            return max(left, right)

        dfs(root)
        return self.longest
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 左右子樹都要遞迴，不能因為值不同就不往下走，下面可能有更長的同值路徑。
- 數的是**邊數**。用節點數算再減 1 的話，空樹會變成 -1。
- 傳值的時候傳 `node.val`，不要傳節點本身。

## 面試口說整理

這和直徑一樣，DFS 回傳往下的最長鏈，只是只有小孩的值和自己相同時才能接上，否則那邊是 0。在每個節點用左鏈加右鏈更新答案，往上回傳較長的一邊。答案數的是邊數，時間 `O(n)`。
