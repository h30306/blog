---
title: "LeetCode 61: Rotate List"
summary: "LeetCode 61 解題筆記：先算長度並接成環，k %= n，從頭走 n - k - 1 步找到新的尾巴再斷開"
description: "2022-10-22 的 LeetCode 61 解題紀錄"
date: 2022-10-22
tags: ["medium", "linked-list", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-22
- 提交紀錄：Accepted ×2

## 解題思路

往右轉 `k` 格，等於把最後 `k` 個節點搬到前面。`k` 可能比長度大，先 `k %= n`（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板四）。

把尾巴接回頭形成環，從頭走 `n - k - 1` 步就是新的尾巴，它的下一個是新的頭，在這裡斷開。

## 我的解法

```python
class Solution:
    def rotateRight(self, head: Optional[ListNode], k: int) -> Optional[ListNode]:
        if not head:
            return None
        n, tail = 1, head
        while tail.next:
            n, tail = n + 1, tail.next
        k %= n
        if k == 0:
            return head
        tail.next = head                             # 接成環
        new_tail = head
        for _ in range(n - k - 1):
            new_tail = new_tail.next
        new_head, new_tail.next = new_tail.next, None
        return new_head
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `k` 要先對長度取餘數，不然會繞很多圈。
- 空串列和 `k % n == 0` 時直接回傳。

## 面試口說整理

我先算出長度和尾巴，把 `k` 對長度取餘數，再把尾巴接回頭形成環，從頭走 `n - k - 1` 步找到新的尾巴並斷開。時間 `O(n)`。
