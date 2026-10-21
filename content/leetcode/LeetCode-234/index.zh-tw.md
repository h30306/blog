---
title: "LeetCode 234: Palindrome Linked List"
summary: "LeetCode 234 解題筆記：快慢指針找中點，反轉後半段，再從兩端往中間比；O(1) 額外空間"
description: "2022-08-22 的 LeetCode 234 解題紀錄"
date: 2022-08-22
tags: ["easy", "linked-list", "two-pointers", "stack", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-22
- 提交紀錄：Runtime Error → Time Limit Exceeded → Accepted ×2

## 解題思路

串列不能從後面往前走，所以把**後半段反轉**（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板二、三）：

1. 快慢指針找中點。
2. 從中點開始反轉後半段。
3. 一個從頭、一個從反轉後的頭，一起往後比；後半段走完就結束（奇數長度時中間那個不用比）。

## 我的嘗試

第一版語法錯誤；第二版的迴圈指標沒有前進，`[1]` 就無限迴圈 TLE。我當時 AC 的版本是先把值存進 list 再比，這裡改成 `O(1)` 空間的做法。

## 正確解法

```python
class Solution:
    def isPalindrome(self, head: Optional[ListNode]) -> bool:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
        prev = None
        while slow:                                  # 反轉後半段
            slow.next, prev, slow = prev, slow, slow.next
        while prev:
            if prev.val != head.val:
                return False
            prev, head = prev.next, head.next
        return True
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只比到後半段結束，前半段的尾巴還連著中間那個節點。
- 這個做法會改到原串列；如果不能改，就要先複製值到陣列（`O(n)` 空間）。

## 面試口說整理

我用快慢指針找到中點，把後半段反轉，然後從頭和反轉後的頭一起往後比。全部相同就是回文。時間 `O(n)`、額外空間 `O(1)`。
