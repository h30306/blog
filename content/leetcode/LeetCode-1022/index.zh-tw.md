---
title: "LeetCode 1022: Sum of Root To Leaf Binary Numbers"
summary: "LeetCode 1022 解題筆記：往下走時目前的數字乘 2 加上節點的值，到葉子時加進總和"
description: "2022-09-27 的 LeetCode 1022 解題紀錄"
date: 2022-09-27
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
第一次嘗試：2022-09-27
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Runtime Error → Wrong Answer ×3 → Accepted → Runtime Error ×4 → Accepted → Wrong Answer ×2 → Accepted → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Accepted

## 解題思路

跟 LC 129 一樣，只是二進位：`num = num * 2 + node.val`（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。到葉子時加進總和。

## 我的嘗試

這題 2022 年提交了 21 次，大多是用字串記路徑時出錯：

- 在 `None` 的位置結算路徑：每個葉子有兩個 `None` 小孩，**同一條路徑被算了兩次**，又只對最後總和除以 2，只有一個小孩的節點就會算錯。例如 `[1, 1, 0, 0]`：答案 `6 + 2 = 8`，回傳 9。
- 空字串 `int('', 2)` 報錯（ValueError），或字串和整數相加（TypeError）。

## 正確解法

```python
class Solution:
    def sumRootToLeaf(self, root: Optional[TreeNode]) -> int:
        def dfs(node, num):
            if not node:
                return 0
            num = num * 2 + node.val
            if not node.left and not node.right:
                return num
            return dfs(node.left, num) + dfs(node.right, num)
        return dfs(root, 0)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 只在葉子結算，走到 `None` 時不能算一條路徑。

## 面試口說整理

我往下遞迴時把目前的數字左移一位再加上節點的值，到葉子時回傳，左右兩邊加起來就是總和。時間 `O(n)`。
