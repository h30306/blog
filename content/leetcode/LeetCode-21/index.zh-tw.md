---
title: "LeetCode 21: Merge Two Sorted Lists"
summary: "LeetCode 21 解題筆記：dummy node，以及 Python 變數為什麼不是 copy"
description: "2026-10-18 merge sort 練習梯子的 LeetCode 21 紀錄"
date: 2026-10-18
tags: ["easy", "linked-list", "two-pointers", "merge-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-10-18
來源：Merge sort 練習梯子，LC 148 和 LC 23 的前置題

## 解題思路

跟陣列的 merge 一樣，每次取兩條 list 隊頭比較小的那個接到結果後面。Linked list 只要改 `next` 指標，不需要暫存陣列。

用 dummy node 當結果的開頭，就不用特別處理「第一個節點是誰」。

## 我的第一版

```python
dummy = tail = ListNode()

while list1 or list2:
    if not list1 or (list2 and list2.val < list1.val):
        tail.next = list2
        list2 = list2.next
    else:
        tail.next = list1
        list1 = list1.next
    tail = tail.next

return dummy.next
```

結果正確，判斷順序也對：先檢查 `not list1`，確定存在才讀 `.val`。可以改進的是：其中一條用完以後，另一條剩下的部分本來就有序，可以整段一次接上。

## 當時的疑問：`dummy = tail = ListNode()` 不是 deep copy 嗎？

不是，**任何 copy 都沒有發生**。這行只建立一個節點，讓 `dummy` 和 `tail` 兩個名字都指向它。

關鍵是分清楚兩種操作：

| 操作 | 例子 | 會影響共用同一個物件的名字嗎 |
|---|---|---|
| 改物件 | `tail.next = x`、`lst.append(x)`、`a[i] = x` | 會 |
| 換指向 | `tail = tail.next`、`x = ...` | 不會 |

第一次 `tail.next = list1` 時，`tail` 和 `dummy` 指向同一個節點，所以 `dummy.next` 也接上了。之後 `tail = tail.next` 只是把 `tail` 移走，`dummy` 一直留在開頭。

`a = b = 1` 其實也是指向同一個物件，只是 int 不可變，沒有「改物件」的操作，所以觀察不到共用。

刷題最常踩到的版本是建 DP 表：

```python
dp = [[0] * 3] * 2                 # 兩列是同一個 list
dp = [[0] * 3 for _ in range(2)]   # 每列各建一個
```

## 正確解法

```python
class Solution:
    def mergeTwoLists(self, list1: ListNode | None, list2: ListNode | None) -> ListNode | None:
        dummy = tail = ListNode()
        while list1 and list2:
            if list2.val < list1.val:
                tail.next = list2
                list2 = list2.next
            else:
                tail.next = list1
                list1 = list1.next
            tail = tail.next
        tail.next = list1 or list2
        return dummy.next
```

## 複雜度

時間 `O(m + n)`，空間 `O(1)`。只改指標，不建新節點。

## 要特別避免的錯誤

- 先讀 `.val` 才檢查節點是否存在。
- 以為 `dummy = tail = ...` 會產生兩個節點。

## 面試口說整理

我用 dummy node 當結果的開頭，`tail` 指向結果的尾巴。每次比較兩條 list 的隊頭，把比較小的接到 `tail` 後面再往前移。其中一條用完時，另一條剩下的部分已經有序，直接整段接上。時間 `O(m + n)`，只改指標，額外空間 `O(1)`。
