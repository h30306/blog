---
title: "LeetCode 92: Reverse Linked List II"
summary: "LeetCode 92 解題筆記：dummy 走到 left 的前一個節點，再把後面的節點一個一個搬到它後面，搬 right - left 次"
description: "2022-11-26 的 LeetCode 92 解題紀錄"
date: 2022-11-26
tags: ["medium", "linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-26
- 提交紀錄：Accepted ×2 → Wrong Answer → Accepted

## 解題思路

先用 dummy 走到第 `left - 1` 個節點 `pre`（`left = 1` 時就是 dummy）。`cur = pre.next` 是要反轉這段的第一個節點，它最後會變成這段的尾巴。之後重複 `right - left` 次：把 `cur` 後面那個節點拿出來，插到 `pre` 後面（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板二）。

## 我的嘗試

前兩次 AC。之後重寫成「切成三段、反轉中間、再接回去」，但接回去時接的是原本這段的第一個節點 `middle`（反轉後它變成尾巴），應該接反轉後的頭 `prev`。例如 `[8, 4]`、`left = 1`、`right = 2`：答案 `[4, 8]`，回傳 `[8]`。

## 正確解法

```python
class Solution:
    def reverseBetween(self, head: Optional[ListNode], left: int, right: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        pre = dummy
        for _ in range(left - 1):
            pre = pre.next
        cur = pre.next
        for _ in range(right - left):
            nxt = cur.next                           # 拿出 cur 後面那個
            cur.next = nxt.next
            nxt.next = pre.next                      # 插到 pre 後面
            pre.next = nxt
        return dummy.next
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `left = 1` 時頭會換掉，所以從 dummy 出發。
- `cur` 一直是同一個節點，只是越來越往後。

## 面試口說整理

我用 dummy 走到 `left` 的前一個節點，然後重複把這段裡的下一個節點搬到最前面，搬 `right - left` 次，這段就反轉了。只走一次，時間 `O(n)`。
