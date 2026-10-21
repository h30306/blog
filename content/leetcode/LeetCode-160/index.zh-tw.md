---
title: "LeetCode 160: Intersection of Two Linked Lists"
summary: "LeetCode 160 解題筆記：兩個指標走完自己的串列就換走對方的，都走 lenA + lenB 步，會同時到達交點或同時到 None"
description: "2022-08-20 的 LeetCode 160 解題紀錄"
date: 2022-08-20
tags: ["easy", "hash-table", "linked-list", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-20
- 提交紀錄：Runtime Error ×2 → Wrong Answer → Time Limit Exceeded → Runtime Error ×7 → Accepted ×2 → Wrong Answer ×2 → Accepted ×2 → Runtime Error → Time Limit Exceeded → Accepted ×2

## 解題思路

兩條串列交會後的部分是共用的。指標 `a` 走完 A 就接著走 B，`b` 走完 B 就接著走 A（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板六）。兩個都走了 `lenA + lenB` 步，所以會在交點同時相遇；沒有交點時會同時走到 `None`，迴圈也會停。

## 我的嘗試

這題 2022 年提交了 21 次：

- 一開始想把 A 的節點存進雜湊表，第一版用 dict 當 list 呼叫 `append`（RE）；改成集合之後，掃 B 的迴圈裡忘了讓 `B` 前進（TLE），回傳的也是 `True` / `False` 而不是節點。
- 改成換頭走的寫法後，有一版寫成 `B = B.next if B else B`：B 走完時換回自己（`None`），永遠走不到 A，例如 A 是 `[1, 3]`、B 是 `[3]`（共用 `[3]`）時回傳 `None`。

## 正確解法

```python
class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> Optional[ListNode]:
        a, b = headA, headB
        while a is not b:
            a = a.next if a else headB
            b = b.next if b else headA
        return a
```

## 複雜度

時間 `O(m + n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 比較的是節點本身（`is`），不是值。
- 走完自己的要換到**對方的頭**，不是自己的頭。

## 面試口說整理

我讓兩個指標各自走完自己的串列後換到對方的頭，兩個都走 `lenA + lenB` 步，所以一定會在交點同時到達，沒有交點就同時變成 `None`。時間 `O(m + n)`、空間 `O(1)`。
