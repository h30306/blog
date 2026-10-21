---
title: "LeetCode 783: Minimum Distance Between BST Nodes"
summary: "LeetCode 783 解題筆記：BST 的中序是由小到大，最小差一定出現在中序相鄰的兩個值之間；記住前一個值逐一比較"
description: "2022-09-06 的 LeetCode 783 解題紀錄"
date: 2022-09-06
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-search-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-06
- 提交紀錄：Runtime Error → Accepted ×3 → Wrong Answer ×2 → Runtime Error → Wrong Answer ×6 → Runtime Error → Wrong Answer ×4 → Accepted

## 解題思路

BST 的中序遍歷是排序好的序列，排序後最接近的兩個數一定相鄰（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。中序走的時候記住前一個值，跟目前的值相減更新答案。這題和 LC 530 是同一題。

## 我的嘗試

這題提交了 19 次，幾乎都卡在同一個誤解：以為最小差一定出現在**父節點和小孩之間**，所以遞迴時拿節點跟左右小孩（或子樹回傳的值）比。但最接近的兩個值是中序遍歷裡相鄰的兩個，不一定是父子。例如 `[3, None, 8, 4]`：3 和 4 不是父子，差是 1，這版回傳 4。另外初始值用了 `-inf` / `inf` 做減法，有幾版直接回傳了 `inf`。

## 正確解法

```python
class Solution:
    def minDiffInBST(self, root: Optional[TreeNode]) -> int:
        best, prev = float("inf"), None
        stack, cur = [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            if prev is not None:
                best = min(best, cur.val - prev)
            prev = cur.val
            cur = cur.right
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 最接近的兩個值不一定是父子，要比中序相鄰的值。

## 面試口說整理

BST 中序是排序的，最小差一定在相鄰的兩個值之間，所以我中序遍歷時記住前一個值，每次相減更新最小值。時間 `O(n)`。
