---
title: "LeetCode 19: Remove Nth Node From End of List"
summary: "LeetCode 19 解題筆記：從 dummy 出發，快指針先走 n + 1 步，再一起走到底，慢指針停在要刪的前一個"
description: "2022-10-20 的 LeetCode 19 解題紀錄"
date: 2022-10-20
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
第一次嘗試：2022-10-20
- 提交紀錄：Accepted → Runtime Error → Accepted ×2 → Runtime Error ×2 → Wrong Answer ×4 → Accepted → Runtime Error

## 解題思路

快指針先走，兩個指標之間保持固定的距離，快的走到底時慢的就在倒數第 `n` 個的前一個（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板四）。從 **dummy** 出發，刪頭節點（`n` 等於長度）時也不用特判。

## 我的嘗試

第一次就 AC 了，但之後重寫時刪頭的情況一直出錯：沒有 dummy，所以要特判「快指針先走 `n` 步就到底」的情況，我試了 `return []`、`ListNode([])`、`ListNode(None)`、`ListNode(0)`，都不是空串列。例如 `[3]`、`n = 1`：答案是空串列。加上 dummy 就不用特判了。

## 正確解法

```python
class Solution:
    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        fast = slow = dummy
        for _ in range(n + 1):
            fast = fast.next
        while fast:
            fast, slow = fast.next, slow.next
        slow.next = slow.next.next
        return dummy.next
```

## 複雜度

時間 `O(n)`，空間 `O(1)`，只走一次。

## 要特別避免的錯誤

- 刪掉的是頭時，要回傳 `None`（空串列），不是 `[]`、`ListNode([])` 或 `ListNode(0)`。
- 從 dummy 出發，就不用另外處理刪頭的情況。

## 面試口說整理

我從 dummy 出發，讓快指針先走 `n + 1` 步，再兩個一起走，快的走到 `None` 時慢的就在要刪的前一個，直接跳過它。只走一次，時間 `O(n)`。
