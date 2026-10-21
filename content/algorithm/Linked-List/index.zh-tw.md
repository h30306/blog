---
title: "Linked List 鏈結串列"
summary: "Dummy head、反轉（整條、一段、一半）、快慢指針找中點與環、間隔 n 的雙指針、兩兩交換、兩條串列相遇，以及用雜湊表複製帶 random 指標的串列"
description: "演算法學習"
date: 2026-10-21
tags: ["linked-list", "two-pointers"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

鏈結串列的題目很少需要特別的演算法，難的是**指標操作的順序**：先改了哪一個指標，就可能弄丟後面的節點。幾個固定的工具：

| 工具 | 解決什麼 | 例子 |
|---|---|---|
| Dummy head | 頭節點可能被刪掉或換掉 | 刪除特定值、刪除重複、刪倒數第 n 個 |
| 反轉 | 從後面往前看 | 整條反轉、反轉一段、回文、重新排列 |
| 快慢指針 | 找中點、判斷有沒有環 | 中間節點、環的入口、排序時切一半 |
| 間隔固定的雙指針 | 從尾端數回來 | 刪倒數第 n 個、旋轉 |
| 兩條串列換頭走 | 長度不同時對齊 | 兩條串列的交點 |

## 模板一：Dummy head

頭節點可能被刪掉時，在前面接一個假的節點，所有刪除都變成「刪 `cur.next`」，不用特判頭：

```python
dummy = ListNode(0, head)
cur = dummy
while cur.next:
    if 要刪(cur.next):
        cur.next = cur.next.next         # 刪掉之後 cur 不要動，下一個也可能要刪
    else:
        cur = cur.next
return dummy.next
```

- **刪除特定值**（LC 203）、**刪除重複只留一個**（LC 83）、**重複的全部刪掉**（LC 82）。
- **分成小於 / 大於等於兩段**（LC 86）：兩個 dummy 各接一段，最後接起來，記得把第二段的尾巴設成 `None`。
- **兩個數相加**（LC 2）：dummy 接上每一位的結果，`carry` 處理到兩條都走完、而且沒有進位為止。

## 模板二：反轉

```python
prev, cur = None, head
while cur:
    nxt = cur.next                       # 先記住下一個，不然改完 cur.next 就找不到了
    cur.next = prev
    prev, cur = cur, nxt
return prev                              # 新的頭
```

- **整條反轉**（LC 206）：上面的程式。
- **反轉一段**（LC 92）：先走到第 `left - 1` 個節點 `pre`，再把後面的節點一個一個「搬到 `pre` 後面」，搬 `right - left` 次。
- **回文**（LC 234）：快慢指針找到中點，反轉後半段，再從兩端往中間比。
- **重新排列成頭尾交錯**（LC 143）：找中點、反轉後半段、兩條交錯合併。
- **刪掉右邊有更大值的節點**（LC 2487）：從右往左看只要保留「目前最大值」，可以反轉後掃一次，或用單調棧。

## 模板三：快慢指針

```python
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
# 偶數長度時 slow 停在中間偏右的那個
```

- **中間節點**（LC 876）：上面的程式。
- **有沒有環**（LC 141）：有環的話 `fast` 一定會追上 `slow`；兩個指標都要從**自己的位置**往前走，不是每次從 `head` 重新算。
- **環的入口**（LC 142）：相遇之後，一個指標回到 `head`，兩個都一次走一步，再相遇的地方就是入口。
- **排序**（LC 148）：用快慢指針切一半，遞迴排好再合併，見 [Merge Sort]({{< relref "/algorithm/Merge-Sort" >}})。
- **轉成平衡的 BST**（LC 109）：中點當根，左右兩半遞迴。

## 模板四：間隔固定的雙指針

```python
fast = slow = dummy
for _ in range(n + 1):                   # 讓 fast 先走 n + 1 步
    fast = fast.next
while fast:
    fast, slow = fast.next, slow.next
slow.next = slow.next.next               # slow 停在要刪的前一個
```

- **刪倒數第 `n` 個**（LC 19）：上面的程式，從 dummy 出發才能刪掉頭。
- **往右旋轉 `k` 格**（LC 61）：先算長度，`k %= n`，新的尾巴是第 `n - k` 個節點。

## 模板五：兩兩交換

```python
prev = dummy
while prev.next and prev.next.next:
    a, b = prev.next, prev.next.next
    prev.next, a.next, b.next = b, b.next, a   # 右邊先全部算好，再一起指定
    prev = a
```

- **兩兩交換節點**（LC 24）：交換的是節點，不是值。

## 模板六：兩條串列換頭走

```python
a, b = headA, headB
while a is not b:
    a = a.next if a else headB           # 走完自己的就走對方的
    b = b.next if b else headA
return a                                 # 交點，或兩個都走到 None
```

兩個指標都走 `lenA + lenB` 步，一定會同時到達交點；沒有交點時同時到 `None`（LC 160）。

## 其他

- **複製帶 random 的串列**（LC 138）：第一次走過建立「舊節點 → 新節點」的字典，第二次接上 `next` 和 `random`。
- **只給要刪的節點**（LC 237）：把下一個節點的值複製過來，再刪掉下一個節點。
- **樹的每層用 `next` 串起來**（LC 116）：完美二元樹時，用上一層已經接好的 `next` 走過這一層，`O(1)` 額外空間。
- **自己實作 HashSet**（LC 705）：固定數量的桶子，每個桶子放一個 list（或串列）處理碰撞。

## 主要參數說明

- `while cur.next` 和 `while cur` 的差別：要刪 `cur.next` 時用前者，只是走過每個節點用後者。
- 改指標之前，先把之後還要用的節點存到變數裡。

## 複雜度

這些操作都是走過串列常數次，時間 `O(n)`，額外空間 `O(1)`（LC 138 的字典是 `O(n)`）。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **沒處理空串列**：`head` 是 `None` 時直接取 `head.next`，Runtime Error（LC 83、141、19 等很多題）。
- **刪掉節點之後指標沒有動**：`if` 裡刪了節點，`else` 卻沒有前進，或刪了之後又往前跳過一個，結果 TLE 或漏刪（LC 203）。
- **快慢指針每次從 `head` 重算**：寫成 `slow = head.next`，兩個指標永遠在原地，TLE（LC 141）。
- **同時指定時順序錯**：交換節點時把 `node.next` 先改掉，後面的 `node.next.next` 指到錯的地方（LC 24）。
- **直接把例子的答案寫死**（LC 138）。

## 相關 LeetCode

- `LC 203` Remove Linked List Elements
- `LC 206` Reverse Linked List
- `LC 234` Palindrome Linked List
- `LC 92` Reverse Linked List II
- `LC 24` Swap Nodes in Pairs
- `LC 160` Intersection of Two Linked Lists
- `LC 141` Linked List Cycle
- `LC 142` Linked List Cycle II
- `LC 876` Middle of the Linked List
- `LC 148` Sort List
- `LC 109` Convert Sorted List to Binary Search Tree
- `LC 83` Remove Duplicates from Sorted List
- `LC 82` Remove Duplicates from Sorted List II
- `LC 138` Copy List with Random Pointer
- `LC 237` Delete Node in a Linked List
- `LC 2487` Remove Nodes From Linked List
- `LC 2` Add Two Numbers
- `LC 86` Partition List
- `LC 143` Reorder List
- `LC 61` Rotate List
- `LC 19` Remove Nth Node From End of List
- `LC 116` Populating Next Right Pointers in Each Node
- `LC 705` Design HashSet
