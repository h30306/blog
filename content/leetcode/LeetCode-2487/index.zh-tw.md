---
title: "LeetCode 2487: Remove Nodes From Linked List"
summary: "LeetCode 2487 解題筆記：保留的節點從左到右是非遞增的；用單調棧，比新節點小的都彈掉，最後把棧裡的節點串起來"
description: "2024-05-06 的 LeetCode 2487 解題紀錄"
date: 2024-05-06
tags: ["medium", "linked-list", "stack", "recursion", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2024-05-06
- 提交紀錄：Accepted ×3

## 解題思路

一個節點留下來，代表右邊沒有比它大的。從左往右掃，用一個棧（[Stack]({{< relref "/algorithm/Stack" >}}) 的單調棧）：新節點進來時，棧頂比它小的節點右邊出現了更大的值，全部彈掉。最後棧裡由下到上是非遞增的，依序接起來就是答案（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板二提到的另一種做法是先反轉再掃）。

## 我的解法

```python
class Solution:
    def removeNodes(self, head: Optional[ListNode]) -> Optional[ListNode]:
        stack = []
        while head:
            while stack and stack[-1].val < head.val:
                stack.pop()
            stack.append(head)
            head = head.next
        for a, b in zip(stack, stack[1:]):
            a.next = b
        stack[-1].next = None
        return stack[0]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只彈掉**嚴格比較小**的，一樣大的要留下。
- 最後一個節點的 `next` 要設成 `None`。

## 面試口說整理

留下的節點右邊沒有更大的，所以我用單調棧：新節點進來時把比它小的都彈掉，最後棧裡的節點依序串起來就是答案。時間 `O(n)`。
