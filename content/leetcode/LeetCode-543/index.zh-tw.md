---
title: "LeetCode 543: Diameter of Binary Tree"
summary: "LeetCode 543 解題筆記：直徑可能不經過根；後序回傳高度，同時在每個節點用「左高 + 右高」更新答案；算的是邊數"
description: "2022-08-25 的 LeetCode 543 解題紀錄"
date: 2022-08-25
tags: ["easy", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-25
- 提交紀錄：Runtime Error ×5 → Wrong Answer ×3 → Runtime Error → Wrong Answer ×12 → Runtime Error ×2 → Accepted → Time Limit Exceeded → Accepted

## 解題思路

經過某個節點的最長路徑長度（邊數）是 `左子樹高度 + 右子樹高度`（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一、五）。最長的那條**不一定經過根**，所以每個節點都要算一次取最大。後序遞迴回傳高度，順便更新答案。

## 我的嘗試

這題 2022 年提交了 26 次，錯誤主要有三種：

- **只看根**：`maxDepth(root.left) + maxDepth(root.right)`。最長路徑不經過根時就錯，例如 `[5, None, 8, 1, 7, 1, 2, 6]`：最長路徑在右子樹裡，長度 4，回傳 3。
- **回傳單邊的高度**：`max(左高, 右高)`，例如 `[4, 4, 8]` 回傳 1，答案是 2。
- **把節點數當成邊數**：只有一個節點 `[1]` 回傳 1，答案是 0。

## 正確解法

```python
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        best = 0
        def height(node):
            nonlocal best
            if not node:
                return 0
            l, r = height(node.left), height(node.right)
            best = max(best, l + r)                  # 經過這個節點的最長路徑
            return 1 + max(l, r)
        height(root)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 直徑是邊數，不是節點數。
- 不一定經過根，每個節點都要更新。

## 面試口說整理

直徑不一定經過根，所以我用後序回傳每個子樹的高度，同時在每個節點用左右高度相加更新答案。只走一次，時間 `O(n)`。
