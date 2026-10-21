---
title: "LeetCode 226: Invert Binary Tree"
summary: "LeetCode 226 解題筆記：每個節點交換左右小孩；用同時指定，避免先改掉的那邊被拿來用"
description: "2022-08-21 的 LeetCode 226 解題紀錄"
date: 2022-08-21
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Runtime Error ×4 → Accepted ×3 → Runtime Error → Accepted → Wrong Answer → Accepted ×2

## 解題思路

每個節點把左右子樹交換，再對兩邊遞迴（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。用 `root.left, root.right = 右, 左` 同時指定：右邊兩個值會先算好，才不會發生「左邊改完之後，右邊拿到的是已經被改過的左邊」。

## 我的嘗試

前幾版回傳的不是樹（例如回傳了一個 list），或沒處理空樹。之後有一版分成兩行：

```text
root.left = invert(root.right)
root.right = invert(root.left)   # 這裡的 root.left 已經是新的
```

第二行用到的是已經被改過的左子樹，原本的左子樹不見了。例如 `[1, 4]`：答案 `[1, None, 4]`，回傳 `[1]`。

## 正確解法

```python
class Solution:
    def invertTree(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        if root:
            root.left, root.right = self.invertTree(root.right), self.invertTree(root.left)
        return root
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 分兩行寫時，第二行用到的 `root.left` 已經是新的值。

## 面試口說整理

我對每個節點交換左右子樹，再遞迴處理兩邊，用同時指定避免覆蓋。時間 `O(n)`。
