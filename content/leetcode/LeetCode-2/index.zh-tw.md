---
title: "LeetCode 2: Add Two Numbers"
summary: "LeetCode 2 解題筆記：位數是反著存的，從頭開始逐位相加帶進位；迴圈跑到兩條都走完而且沒有進位為止"
description: "2022-02-19 的 LeetCode 2 解題紀錄"
date: 2022-02-19
tags: ["medium", "linked-list", "math", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-02-19
- 提交紀錄：Runtime Error ×14 → Wrong Answer → Accepted → Runtime Error ×3 → Wrong Answer ×3 → Accepted ×2

## 解題思路

數字的個位數在頭，剛好可以從頭開始加（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板一）。用 dummy 接答案，每一位是 `(a + b + carry) % 10`，新的進位是 `// 10`。迴圈條件寫成 `l1 or l2 or carry`，一次處理「長度不同」和「最後還有進位」兩種情況。

## 我的嘗試

這是我 2022 年 2 月第一次刷 LeetCode 時寫的，24 次提交：

- 前面十幾次 RE 是還不熟 `ListNode`：直接對串列用 `''.join`、把數字轉成字串再反轉，或在 `None` 上取 `.val`。
- 會用串列之後，一版接答案的指標就是 dummy 本身，最後 `return res.next` 已經不是頭了，回傳空的。
- 一版最後的進位沒有處理，`[6] + [7]`：答案 `[3, 1]`，回傳 `[3]`。

## 正確解法

```python
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        tail = dummy = ListNode()
        carry = 0
        while l1 or l2 or carry:
            s = carry + (l1.val if l1 else 0) + (l2.val if l2 else 0)
            carry, digit = divmod(s, 10)
            tail.next = tail = ListNode(digit)
            l1 = l1.next if l1 else None
            l2 = l2.next if l2 else None
        return dummy.next
```

## 複雜度

時間 `O(max(m, n))`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 最後的進位也要變成一個節點。
- 接答案的指標跟 dummy 要分開，不然回傳時找不到頭。

## 面試口說整理

位數反著存，所以我從頭逐位相加，維護進位，用 dummy 接出答案。迴圈跑到兩條都結束而且沒有進位，所以長度不同和最後進位都不用另外處理。時間 `O(max(m, n))`。
