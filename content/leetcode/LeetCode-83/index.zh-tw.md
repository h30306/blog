---
title: "LeetCode 83: Remove Duplicates from Sorted List"
summary: "LeetCode 83 解題筆記：已排序，重複的一定相鄰；cur 跟 cur.next 一樣就跳過 cur.next，不一樣才前進"
description: "2022-07-20 的 LeetCode 83 解題紀錄"
date: 2022-07-20
tags: ["easy", "linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-07-20
- 提交紀錄：Runtime Error ×2 → Time Limit Exceeded ×2 → Accepted → Runtime Error → Wrong Answer ×2 → Accepted → Runtime Error ×2 → Accepted ×4 → Runtime Error → Accepted ×2

## 解題思路

已排序的串列重複的值一定相鄰。`cur.next` 跟 `cur` 一樣就把它跳過，**`cur` 不動**（下一個也可能一樣）；不一樣才往前走（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板一）。頭節點一定會留下，所以不需要 dummy。

## 我的嘗試

這是我 2022 年 7 月最早寫的幾題之一，18 次提交裡大部分是還不熟悉 `ListNode`：

- 一開始用了 `self.val`、把值和節點拿來比（`head.val != head.next`），也回傳了 list 而不是節點，RE 和 TLE。
- 之後空串列時回傳 `ListNode(None)` 或 `ListNode(0)`，多了一個節點（WA）；或沒有檢查 `cur.next`，`[3, 3]` 時報錯。

## 正確解法

```python
class Solution:
    def deleteDuplicates(self, head: Optional[ListNode]) -> Optional[ListNode]:
        cur = head
        while cur and cur.next:
            if cur.val == cur.next.val:
                cur.next = cur.next.next
            else:
                cur = cur.next
        return head
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 空串列要回傳 `None`，不是 `ListNode(None)` 或 `ListNode(0)`。
- 比較的是 `cur.val` 和 `cur.next.val`，不是值和節點。

## 面試口說整理

串列已排序，重複的值一定相鄰，所以 `cur.next` 跟 `cur` 一樣就跳過，不一樣才往前走。時間 `O(n)`、空間 `O(1)`。
