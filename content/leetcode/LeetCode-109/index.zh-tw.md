---
title: "LeetCode 109: Convert Sorted List to Binary Search Tree"
summary: "LeetCode 109 解題筆記：快慢指針找中點當根，左右兩半遞迴建樹；高度自然平衡"
description: "2022-11-19 的 LeetCode 109 解題紀錄"
date: 2022-11-19
tags: ["medium", "linked-list", "divide-and-conquer", "tree", "binary-search-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-19
- 提交紀錄：Wrong Answer ×2 → Runtime Error ×3 → Accepted ×4

## 解題思路

平衡的 BST 根要在中間（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板三）：

1. 快慢指針找到中點，並記住中點的前一個節點，把左半邊切斷。
2. 中點當根，左半邊、右半邊各自遞迴。

每層都從中間切，左右兩邊的大小差最多 1，所以高度平衡。

## 我的嘗試

前兩版想用兩個指標從中間同時往左右長樹，但兩邊長度不一樣時用 `TreeNode(None)` 補空節點，結果多了值是 `None` 的節點，例如 `[1, 3]` 中序是 `[1, 3, None]`。之後改成遞迴切半才 AC。

## 正確解法

```python
class Solution:
    def sortedListToBST(self, head: Optional[ListNode]) -> Optional[TreeNode]:
        if not head:
            return None
        if not head.next:
            return TreeNode(head.val)
        prev, slow, fast = None, head, head
        while fast and fast.next:
            prev, slow, fast = slow, slow.next, fast.next.next
        prev.next = None                           # 切斷左半邊
        return TreeNode(slow.val, self.sortedListToBST(head), self.sortedListToBST(slow.next))
```

## 複雜度

時間 `O(n log n)`（每層找中點共 `O(n)`），空間 `O(log n)`。先轉成陣列可以做到 `O(n)` 時間。

## 要特別避免的錯誤

- 要記住中點的前一個節點，才能把左半邊切斷。
- 只剩一個節點時直接回傳，不然左半邊切不開。

## 面試口說整理

我用快慢指針找到中點當根，把左半邊從中點前面切斷，左右兩半遞迴建子樹。每次都從中間切，所以高度平衡。時間 `O(n log n)`。
