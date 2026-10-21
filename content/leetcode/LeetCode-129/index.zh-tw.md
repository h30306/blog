---
title: "LeetCode 129: Sum Root to Leaf Numbers"
summary: "LeetCode 129 解題筆記：往下走時目前的數字乘 10 加上節點的值，到葉子時加進總和"
description: "2022-11-18 的 LeetCode 129 解題紀錄"
date: 2022-11-18
tags: ["medium", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-18
- 提交紀錄：Accepted ×2 → Runtime Error → Accepted

## 解題思路

每往下一層，數字就多一位：`num = num * 10 + node.val`（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。到葉子時這條路徑的數字就完成了，加進總和。用整數算比轉成字串再接起來快。

## 我的嘗試

2024 年寫的時候一版沒處理「只有一邊有小孩」：遞迴進到 `None` 之後取 `node.left`，例如 `[9, 9]`（只有左小孩）報錯。

## 正確解法

```python
class Solution:
    def sumNumbers(self, root: Optional[TreeNode]) -> int:
        def dfs(node, num):
            if not node:
                return 0
            num = num * 10 + node.val
            if not node.left and not node.right:
                return num
            return dfs(node.left, num) + dfs(node.right, num)
        return dfs(root, 0)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 只有一邊有小孩時，空的那邊要回傳 0，不能對 `None` 取值。

## 面試口說整理

我往下遞迴時把目前的數字乘 10 再加上節點的值，到葉子時回傳這個數字，左右兩邊的結果加起來就是總和。時間 `O(n)`。
