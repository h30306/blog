---
title: "LeetCode 889: Construct Binary Tree from Preorder and Postorder Traversal"
summary: "LeetCode 889 解題筆記：stack 存目前這條路徑，堆頂等於 postorder 的下一個就代表子樹完成要 pop；新節點先接左邊"
description: "2026-10-29 的 LeetCode 889 解題紀錄"
date: 2026-10-29
tags: ["medium", "array", "hash-table", "divide-and-conquer", "tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-29
- 提交紀錄：Accepted（一次通過）

## 解題思路

前序是「根、左、右」，後序是「左、右、根」。一個節點出現在後序裡，代表它的整棵子樹已經結束。

依序讀前序（[Tree]({{< relref "/algorithm/Tree" >}}) 模板九）：

- stack 存「目前這條從根往下的路徑」上、子樹還沒結束的節點。
- 讀到新節點前，先看堆頂是不是後序指標指到的值：是的話，這棵子樹已經完整，pop 掉，後序指標往前，一直重複。
- 新節點是堆頂的小孩：堆頂還沒有左小孩就接左邊，否則接右邊，然後推進 stack。

只有一個小孩的節點，前序加後序分不出是左還是右，題目接受任何一種答案，這個寫法一律接在左邊。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def constructFromPrePost(self, preorder: List[int], postorder: List[int]) -> Optional[TreeNode]:
        root = TreeNode(preorder[0])
        stack = [root]
        j = 0
        for val in preorder[1:]:
            node = TreeNode(val)
            while stack[-1].val == postorder[j]:
                stack.pop()
                j += 1
            if not stack[-1].left:
                stack[-1].left = node
            else:
                stack[-1].right = node
            stack.append(node)
        return root
```

遞迴的做法：`preorder[1]` 是左子樹的根，在後序裡找到它的位置，就知道左子樹的大小，再切開兩邊遞迴。用雜湊表記後序位置的話也是 `O(n)`。

## 複雜度

時間 `O(n)`：每個節點進出 stack 各一次。空間 `O(h)`。

## 要特別避免的錯誤

- pop 要在接上新節點**之前**做，用 `while`，可能一次結束好幾層子樹。
- 答案不唯一，不用特別處理只有一個小孩的情況。

## 面試口說整理

後序裡出現一個節點，代表它的子樹結束了。我依序讀前序，用 stack 存還沒結束的路徑；每讀一個新節點，先把堆頂等於後序目前值的節點 pop 掉，再把新節點接到堆頂，沒有左小孩就接左邊，否則接右邊。每個節點進出 stack 一次，時間 `O(n)`。
