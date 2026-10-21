---
title: "LeetCode 671: Second Minimum Node In a Binary Tree"
summary: "LeetCode 671 解題筆記：根就是最小值；第二小值是整棵樹裡第一個比根大的最小值，值等於根的子樹才需要往下找"
description: "2022-08-29 的 LeetCode 671 解題紀錄"
date: 2022-08-29
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
第一次嘗試：2022-08-29
- 提交紀錄：Wrong Answer ×4 → Accepted ×3 → Wrong Answer ×6 → Accepted ×3

## 解題思路

這棵樹的特性是每個節點的值等於兩個小孩中較小的那個，所以**根就是最小值**。第二小值就是所有節點中「比根大」的最小值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）：

- 節點值比根大：它的子樹裡不會有更小的了（小孩不會比它小），直接回傳它。
- 節點值等於根：答案可能在它的子樹裡，繼續往下找。

## 我的嘗試

前幾版只看根的兩個小孩，取 `max(左, 右)`，但第二小值可能在更深的地方。例如 `[2, 2, 6, 3, 2]`：左小孩 2 下面有 3，答案 3，回傳 6。之後幾版沒處理「所有值都一樣」或「只有一個節點」，回傳了 `inf` 或根的值，而不是 `-1`。

## 正確解法

```python
class Solution:
    def findSecondMinimumValue(self, root: Optional[TreeNode]) -> int:
        def find(node):
            if not node:
                return -1
            if node.val > root.val:
                return node.val
            l, r = find(node.left), find(node.right)
            if l == -1 or r == -1:
                return max(l, r)
            return min(l, r)
        return find(root)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 第二小值可能在很深的地方，不能只看根的兩個小孩。
- 全部的值都一樣時回傳 `-1`。

## 面試口說整理

根一定是最小值，所以我找比根大的最小值：遇到比根大的節點直接回傳，等於根的才往下找，最後左右取較小的有效值。時間 `O(n)`。
