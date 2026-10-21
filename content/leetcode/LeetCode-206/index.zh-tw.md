---
title: "LeetCode 206: Reverse Linked List"
summary: "LeetCode 206 解題筆記：prev / cur / nxt 三個指標，先記住下一個，再把 cur.next 指回 prev"
description: "2022-08-21 的 LeetCode 206 解題紀錄"
date: 2022-08-21
tags: ["easy", "linked-list", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Runtime Error → Accepted → Wrong Answer → Accepted ×2

## 解題思路

一個一個把 `cur.next` 指回前一個節點（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板二）。改指標之前要先把 `cur.next` 存起來，不然就找不到後面的節點了。最後 `prev` 是新的頭；空串列時 `prev` 是 `None`，也正確。

## 我的嘗試

第一版用了沒有定義的變數（NameError）；重寫時一版沒處理空串列，`[]` 時取 `head.next` 報錯。

## 正確解法

```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        prev, cur = None, head
        while cur:
            nxt = cur.next
            cur.next = prev
            prev, cur = cur, nxt
        return prev
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 先存 `cur.next` 再改。
- 空串列不要特判出錯：迴圈不會執行，直接回傳 `None`。

## 面試口說整理

我用 `prev`、`cur` 兩個指標，每一步先存下一個節點，再把 `cur.next` 指向 `prev`，兩個指標往前移。最後 `prev` 就是新的頭。時間 `O(n)`、空間 `O(1)`。
