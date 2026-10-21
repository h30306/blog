---
title: "LeetCode 222: Count Complete Tree Nodes"
summary: "LeetCode 222 解題筆記：完全二元樹，左右兩邊的最左高度相同代表那一邊是滿的，直接用 2^h - 1；O(log² n)"
description: "2022-11-18 的 LeetCode 222 解題紀錄"
date: 2022-11-18
tags: ["medium", "binary-search", "bit-manipulation", "tree", "binary-tree"]
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
- 提交紀錄：Runtime Error → Accepted ×3 → Restrictions Failed → Accepted

## 解題思路

完全二元樹的性質：比較右子樹的最左深度和左子樹的最左深度（[Tree]({{< relref "/algorithm/Tree" >}})）：

- 一樣深：左子樹是**滿的**，節點數是 `2^h - 1`，加上根，再遞迴算右子樹。
- 右邊比較淺：右子樹是滿的（高度少一），再遞迴算左子樹。

每層只往一邊遞迴，每次算高度 `O(log n)`，總共 `O(log² n)`。

## 我的嘗試

2022 年第一版變數沒定義，之後用一般的遍歷數節點（`O(n)`）就過了。2026 年重寫時改成比較最左和最右的高度：一樣高代表整棵樹是滿的，直接用公式，不然就遞迴左右兩邊，也是 `O(log² n)`。這裡的寫法改成比較左右子樹的最左深度，每層只遞迴一邊。

## 正確解法

```python
class Solution:
    def countNodes(self, root: Optional[TreeNode]) -> int:
        def depth(node):
            d = 0
            while node:
                d, node = d + 1, node.left
            return d
        if not root:
            return 0
        l, r = depth(root.left), depth(root.right)
        if l == r:                                   # 左子樹是滿的
            return (1 << l) + self.countNodes(root.right)
        return (1 << r) + self.countNodes(root.left)    # 右子樹是滿的
```

## 複雜度

時間 `O(log² n)`，空間 `O(log n)`。

## 要特別避免的錯誤

- `1 << h` 已經包含了根：`2^h - 1` 個子樹節點加上 1 個根。

## 面試口說整理

完全二元樹的左右子樹一定有一邊是滿的。我比較兩邊的最左深度，滿的那邊直接用公式算，另一邊遞迴。每層只走一邊，時間 `O(log² n)`。
