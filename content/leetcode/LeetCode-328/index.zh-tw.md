---
title: "LeetCode 328: Odd Even Linked List"
summary: "LeetCode 328 解題筆記：奇數位置和偶數位置各接成一條串列，最後奇數串列接上偶數串列的頭；記得把偶數串列的尾巴斷開"
description: "2026-11-01 的 LeetCode 328 解題紀錄"
date: 2026-11-01
tags: ["medium", "linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-11-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

依**位置**（不是值）分成奇數位置和偶數位置兩條串列，保持原本的相對順序，最後把偶數串列接在奇數串列後面。

## 我的嘗試

一次通過。我用兩個 dummy head 分別收集，最後把偶數串列的尾巴設成 `None`（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板一）：

```python
class Solution:
    def oddEvenList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        odd_dummy, even_dummy = ListNode(), ListNode()
        o, e = odd_dummy, even_dummy
        curr, i = head, 1
        while curr:
            if i % 2:
                o.next = curr
                o = curr
            else:
                e.next = curr
                e = curr
            curr = curr.next
            i += 1
        e.next = None
        o.next = even_dummy.next
        return odd_dummy.next
```

## 正確解法：不用 dummy，兩個指標交錯前進

```python
class Solution:
    def oddEvenList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if not head:
            return None
        odd, even = head, head.next
        even_head = even
        while even and even.next:
            odd.next = even.next
            odd = odd.next
            even.next = odd.next
            even = even.next
        odd.next = even_head
        return head
```

## 複雜度

時間 `O(n)`，額外空間 `O(1)`。

## 要特別避免的錯誤

- 偶數串列最後一個節點的 `next` 可能還指向原本的某個奇數節點，不斷開會變成環。
- 分的是位置，不是節點的值。

## 面試口說整理

我把奇數位置和偶數位置的節點分別串成兩條串列，維持原本順序，最後奇數串列的尾巴接上偶數串列的頭，偶數串列的尾巴設成 `None`。只改指標，時間 `O(n)`，空間 `O(1)`。
