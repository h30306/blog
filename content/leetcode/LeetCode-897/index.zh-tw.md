---
title: "LeetCode 897: Increasing Order Search Tree"
summary: "LeetCode 897 解題筆記：中序遍歷，依序把節點接到一條只有右小孩的鏈上，左小孩設成 None；dummy 和移動的尾巴要分開"
description: "2022-09-25 的 LeetCode 897 解題紀錄"
date: 2022-09-25
tags: ["easy", "stack", "tree", "depth-first-search", "binary-search-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-25
- 提交紀錄：Accepted ×2 → Runtime Error ×3 → Wrong Answer ×4 → Accepted ×2

## 解題思路

中序遍歷會由小到大拿到節點（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。用一個 dummy 和尾巴指標 `tail`：每拿到一個節點就接到 `tail.right`，把它的 `left` 設成 `None`，`tail` 往後移。最後回傳 `dummy.right`。

## 我的嘗試

前幾版對 `None` 取屬性。之後的錯都在 dummy：**直接移動 dummy 當尾巴**，最後回傳的 `dummy.right` 是最後一個節點的右邊（`None`），例如 `[7]` 回傳空的、`[6, 0]` 只剩 `[6]`。

## 正確解法

```python
class Solution:
    def increasingBST(self, root: TreeNode) -> TreeNode:
        dummy = tail = TreeNode()
        stack, cur = [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            cur.left = None
            tail.right = tail = cur
            cur = cur.right
        return dummy.right
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 移動的是 `tail`，`dummy` 要留在原地，才能回傳頭。
- 設 `cur.left = None` 不會影響遍歷：它的左子樹已經處理完了。

## 面試口說整理

我用迭代的中序遍歷由小到大拿節點，把每個節點接到尾巴的右邊並清掉左小孩，最後回傳 dummy 的右邊。時間 `O(n)`。
