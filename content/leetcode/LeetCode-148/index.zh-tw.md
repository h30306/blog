---
title: "LeetCode 148: Sort List"
summary: "LeetCode 148 解題筆記：用快慢指針切成兩半，遞迴排序後合併；O(n log n)，不需要額外陣列"
description: "2022-11-17 的 LeetCode 148 解題紀錄"
date: 2022-11-17
tags: ["medium", "linked-list", "two-pointers", "divide-and-conquer", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-17
- 提交紀錄：Accepted → Time Limit Exceeded ×3 → Accepted ×2

## 解題思路

串列不能隨機存取，最適合的是 merge sort（[Merge Sort]({{< relref "/algorithm/Merge-Sort" >}}) 模板三）：

1. 快慢指針找到中點，從中間切斷（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板三）。快指針從 `head.next` 開始，兩個節點時才會切成一個、一個。
2. 兩半各自遞迴排好。
3. 用 dummy 合併兩條已排序的串列。

## 我的嘗試

2022 年第一次 AC 的是插入排序（`O(n²)`，當時剛好沒超時）；之後幾版改成兩兩交換值的寫法，也是 `O(n²)`，三次都 TLE。2026 年重寫成 merge sort 才是正確的複雜度。

## 正確解法

```python
class Solution:
    def sortList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if not head or not head.next:
            return head
        slow, fast = head, head.next
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
        mid, slow.next = slow.next, None
        left, right = self.sortList(head), self.sortList(mid)
        tail = dummy = ListNode()
        while left and right:
            if left.val <= right.val:
                tail.next, left = left, left.next
            else:
                tail.next, right = right, right.next
            tail = tail.next
        tail.next = left or right
        return dummy.next
```

## 複雜度

時間 `O(n log n)`，空間 `O(log n)`（遞迴深度）。

## 要特別避免的錯誤

- 快指針從 `head.next` 開始，不然兩個節點時切不開，會無限遞迴。
- 切斷時要把 `slow.next` 設成 `None`。

## 面試口說整理

串列適合 merge sort：我用快慢指針找中點切成兩半，遞迴排好兩半再用 dummy 合併。時間 `O(n log n)`，只有遞迴的 `O(log n)` 空間。
