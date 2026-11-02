---
title: "LeetCode 25: Reverse Nodes in k-Group"
summary: "LeetCode 25 解題筆記：先數長度決定要翻幾組，每組翻 k 個節點；dummy head 讓第一組不用特判，翻完原本的頭變成這組的尾"
description: "2026-11-01 的 LeetCode 25 解題紀錄"
date: 2026-11-01
tags: ["hard", "linked-list", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-11-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

先數串列長度，`n // k` 就是要翻的組數，最後不滿 `k` 個的不翻。

用 dummy head（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板一），`curr` 指向「上一組的尾巴」：

1. 把 `curr.next` 開始的 `k` 個節點反轉（模板二）。反轉後，原本這組的頭變成尾巴。
2. `curr.next` 接到反轉後的新頭，新尾巴接到下一組的開頭。
3. `curr` 移到這組的新尾巴，處理下一組。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def reverseKGroup(self, head: Optional[ListNode], k: int) -> Optional[ListNode]:
        n = 0
        node = head
        while node:
            n += 1
            node = node.next

        dummy = ListNode(0, head)
        curr = dummy
        for _ in range(n // k):
            group_head = curr.next
            prev, node = None, group_head
            for _ in range(k):
                nxt = node.next
                node.next = prev
                prev = node
                node = nxt
            curr.next = prev            # 這組的新頭
            group_head.next = node      # 新尾巴接到下一組
            curr = group_head
        return dummy.next
```

我當時把反轉寫成一個回傳 `(新頭, 新尾, 下一組開頭)` 的 helper，意思一樣。

## 複雜度

時間 `O(n)`，額外空間 `O(1)`。

## 要特別避免的錯誤

- 最後不滿 `k` 個不能翻，先數長度最簡單；也可以每組先往前探 `k` 步確認夠長。
- 反轉後原本的頭變成尾，要記住它，下一組才接得上。
- 用 dummy head，第一組才不用特別處理新的 `head`。

## 面試口說整理

我先數長度，知道要翻幾組。用 dummy head，`curr` 指向上一組的尾巴，每次把後面 `k` 個節點反轉，再把上一組的尾接到新頭、這組原本的頭（現在是尾）接到下一組，然後 `curr` 移到這組的尾。時間 `O(n)`，空間 `O(1)`。
