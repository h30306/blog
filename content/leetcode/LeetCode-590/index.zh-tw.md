---
title: "LeetCode 590: N-ary Tree Postorder Traversal"
summary: "LeetCode 590 解題筆記：後序是先每個小孩再自己；迭代時可以做「根、小孩由右到左」的前序再整個反轉"
description: "2022-08-27 的 LeetCode 590 解題紀錄"
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
- 提交紀錄：Runtime Error → Accepted ×5

## 解題思路

後序是先依序處理每個小孩、最後才是自己（[Tree]({{< relref "/algorithm/Tree" >}})）。迭代的小技巧：「根、最後一個小孩、……、第一個小孩」的順序反轉過來，剛好就是後序。所以用 stack 彈出就記錄、小孩**照順序**推進去，最後反轉。

## 我的嘗試

第一版用了沒定義的變數；之後都是遞迴寫法，一次就過了。

## 正確解法

```python
class Solution:
    def postorder(self, root: 'Node') -> List[int]:
        res, stack = [], [root] if root else []
        while stack:
            node = stack.pop()
            res.append(node.val)
            stack.extend(node.children)
        return res[::-1]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 反轉技巧的前提是小孩照原本的順序推進 stack。

## 面試口說整理

後序反過來看是「根、最後一個小孩到第一個小孩」，所以我用 stack 做這個順序的遍歷，最後把結果反轉。時間 `O(n)`。
