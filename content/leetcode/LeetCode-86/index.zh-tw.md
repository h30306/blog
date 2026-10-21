---
title: "LeetCode 86: Partition List"
summary: "LeetCode 86 解題筆記：兩個 dummy 分別接小於 x 和大於等於 x 的節點，最後接起來，第二段的尾巴設成 None"
description: "2022-10-26 的 LeetCode 86 解題紀錄"
date: 2022-10-26
tags: ["medium", "linked-list", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-26
- 提交紀錄：Runtime Error → Wrong Answer → Accepted ×2 → Runtime Error → Wrong Answer → Accepted

## 解題思路

要保持原本的相對順序，所以照順序掃一次，小於 `x` 的接到第一個 dummy 後面、其他接到第二個 dummy 後面（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板一）。最後第一段的尾巴接上第二段的頭，**第二段的尾巴要設成 `None`**，不然可能還連著原本串列的節點，形成環。

## 我的嘗試

第一版直接移動 dummy 本身當尾巴，最後回傳 `l1.next` 時已經不是頭，`[1]`、`x = 2` 回傳空的。之後重寫時一版用了沒定義的變數 `target`，一版沒處理全部都在同一段的情況（空串列時報錯）。

## 正確解法

```python
class Solution:
    def partition(self, head: Optional[ListNode], x: int) -> Optional[ListNode]:
        small = s = ListNode()
        big = b = ListNode()
        while head:
            if head.val < x:
                s.next = s = head
            else:
                b.next = b = head
            head = head.next
        b.next = None
        s.next = big.next
        return small.next
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- dummy 和移動的尾巴指標要分開。
- 第二段的尾巴設成 `None`。

## 面試口說整理

我用兩個 dummy，依序把小於 `x` 的節點接到第一條、其他接到第二條，最後兩條接起來並把結尾設成 `None`。原本的順序保留了。時間 `O(n)`。
