---
title: "LeetCode 589: N-ary Tree Preorder Traversal"
summary: "LeetCode 589 解題筆記：N 叉樹的前序，先記錄自己，再依序處理每個小孩；遞迴結果要用 extend 攤平，不是 append 一個 list"
description: "2022-08-27 的 LeetCode 589 解題紀錄"
date: 2022-08-27
tags: ["easy", "stack", "tree", "depth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-27
- 提交紀錄：Runtime Error → Accepted ×2 → Runtime Error ×2 → Wrong Answer ×4 → Runtime Error ×2 → Accepted → Runtime Error → Wrong Answer → Accepted ×5 → Runtime Error → Accepted ×4

## 解題思路

前序是先自己、再依序每個小孩（[Tree]({{< relref "/algorithm/Tree" >}})）。迭代版用 stack：彈出就記錄，小孩**反著**推進去，第一個小孩才會先處理。

## 我的嘗試

這題提交了 24 次，主要是遞迴結果的形狀不對：

- 寫成 `[root.val] + list(map(self.preorder, root.children))`，每個小孩的結果是一個 list，**被整個放進去**，變成巢狀的 `[1, [8]]`，答案是 `[1, 8]`。
- 改成只取每個小孩結果的第一個元素 `[0]`，更深的節點就不見了：`[8, None, 3, None, 8]` 回傳 `[8, 3]`，答案是 `[8, 3, 8]`。
- 之後試了很多種攤平的寫法，最後用迴圈 `extend` 才過。

## 正確解法

```python
class Solution:
    def preorder(self, root: 'Node') -> List[int]:
        res, stack = [], [root] if root else []
        while stack:
            node = stack.pop()
            res.append(node.val)
            stack.extend(reversed(node.children))
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 遞迴寫法要把小孩的結果攤平：`[root.val] + 每個小孩的結果接起來`。
- 迭代時小孩要反著推進 stack。

## 面試口說整理

前序是先自己再依序每個小孩。我用 stack，彈出就記錄，再把小孩反著推進去，第一個小孩就會先被處理。時間 `O(n)`。
