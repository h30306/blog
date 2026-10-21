---
title: "LeetCode 141: Linked List Cycle"
summary: "LeetCode 141 解題筆記：Floyd 判圈，快指針一次兩步、慢指針一次一步，有環就一定會相遇；兩個都要從自己的位置往前走"
description: "2022-08-20 的 LeetCode 141 解題紀錄"
date: 2022-08-20
tags: ["easy", "hash-table", "linked-list", "two-pointers", "floyds-cycle-finding-algorithm"]
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
- 提交紀錄：Time Limit Exceeded ×3 → Wrong Answer → Accepted → Runtime Error ×3 → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error ×2 → Accepted ×2 → Runtime Error ×3 → Accepted

## 解題思路

有環的話，進入環之後快指針每一步都比慢指針多拉近 1 格，一定會追上；沒有環的話快指針會先走到 `None`（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板三）。

## 我的嘗試

這題 2022 年提交了 19 次：

- **TLE**：寫成 `slow = head.next`、`fast = head.next.next`，**每次都從 `head` 重算**，兩個指標永遠停在同一個地方。例如 `[3, 3]` 成環時一直跑不完。
- **RE**：空串列或沒有環時取了 `None.next`，例如 `[]` 和 `[3, 3, 5]`。
- 把條件改成 `while fast and fast.next`、指標從自己的位置往前走就 AC 了。

## 正確解法

```python
class Solution:
    def hasCycle(self, head: Optional[ListNode]) -> bool:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
            if slow is fast:
                return True
        return False
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 每一步是 `slow.next`、`fast.next.next`，不是從 `head` 重新算。
- 空串列和只有一個節點時，`while` 條件直接擋掉。

## 面試口說整理

我用快慢指針，快的一次兩步、慢的一次一步。有環的話快的一定會在環裡追上慢的；快的走到 `None` 就代表沒有環。時間 `O(n)`、空間 `O(1)`。
