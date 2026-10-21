---
title: "LeetCode 143: Reorder List"
summary: "LeetCode 143 解題筆記：找中點、反轉後半段、兩條交錯合併；前半段的尾巴要切斷"
description: "2022-10-29 的 LeetCode 143 解題紀錄"
date: 2022-10-29
tags: ["medium", "linked-list", "two-pointers", "stack", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-29
- 提交紀錄：Runtime Error ×3 → Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted → Time Limit Exceeded → Accepted ×3

## 解題思路

頭、尾、第二個、倒數第二個……交錯，等於把後半段反轉之後跟前半段交錯合併（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板二、三）：

1. 快慢指針找中點，從中點後面切斷。
2. 反轉後半段。
3. 兩條交錯合併，前半段長度大於等於後半段。

## 我的嘗試

2022 年提交了 14 次。這題要組合三個操作，我把它拆成三個函式，但一直有小錯：

- 找中點時寫成 `while fast and fast.next.next`，只有一個節點時 `fast.next` 是 `None` 就報錯，例如 `[8]`。
- 反轉後回傳 `prev.next` 而不是 `prev`，少了一個節點。
- 一版沒有切斷前半段，合併時連回後半段形成環，`[9, 1]` 就跑不完。

## 正確解法

```python
class Solution:
    def reorderList(self, head: Optional[ListNode]) -> None:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
        second, slow.next = slow.next, None          # 切斷前半段
        prev = None
        while second:                                # 反轉後半段
            second.next, prev, second = prev, second, second.next
        first, second = head, prev
        while second:                                # 交錯合併
            n1, n2 = first.next, second.next
            first.next, second.next = second, n1
            first, second = n1, n2
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 一定要切斷前半段，不然合併時會連回後半段，形成環。
- 題目要原地修改，不用回傳。

## 面試口說整理

我用快慢指針找到中點切成兩半，把後半段反轉，再把兩條交錯接起來。全部原地完成，時間 `O(n)`、空間 `O(1)`。
