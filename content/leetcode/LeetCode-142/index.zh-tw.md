---
title: "LeetCode 142: Linked List Cycle II"
summary: "LeetCode 142 解題筆記：快慢指針相遇後，一個回到 head，兩個都一次一步，再相遇的地方就是環的入口"
description: "2022-11-14 的 LeetCode 142 解題紀錄"
date: 2022-11-14
tags: ["medium", "hash-table", "linked-list", "two-pointers", "floyds-cycle-finding-algorithm"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-14
- 提交紀錄：Accepted ×2

## 解題思路

先用快慢指針找到相遇點（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板三）。設頭到入口距離 `a`、入口到相遇點 `b`、環長 `c`：慢的走了 `a + b`、快的走了兩倍，多走的 `a + b` 是環長的整數倍，所以 `a = k·c - b`。

也就是從相遇點再走 `a` 步會回到入口。讓一個指標回到 `head`，兩個都一次一步，會同時到達入口。

## 我的解法

```python
class Solution:
    def detectCycle(self, head: Optional[ListNode]) -> Optional[ListNode]:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
            if slow is fast:
                slow = head
                while slow is not fast:
                    slow, fast = slow.next, fast.next
                return slow
        return None
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 第二階段兩個指標都一次一步。
- 也可以用集合記走過的節點，但那是 `O(n)` 空間。

## 面試口說整理

先用快慢指針找到相遇點；推導可知從頭到入口的距離，等於從相遇點繼續走到入口的距離（模環長），所以讓一個指標回到頭，兩個一起一次一步，再相遇的就是入口。時間 `O(n)`、空間 `O(1)`。
