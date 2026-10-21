---
title: "LeetCode 203: Remove Linked List Elements"
summary: "LeetCode 203 解題筆記：頭節點也可能要刪，用 dummy head 讓每次刪除都變成刪 cur.next；刪完不要前進"
description: "2022-08-21 的 LeetCode 203 解題紀錄"
date: 2022-08-21
tags: ["easy", "linked-list", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Time Limit Exceeded → Runtime Error ×2 → Wrong Answer ×2 → Time Limit Exceeded → Wrong Answer → Runtime Error → Time Limit Exceeded ×2 → Accepted ×3

## 解題思路

頭節點也可能等於 `val`，所以在前面接一個 dummy（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板一）。之後只看 `cur.next`：要刪就跳過它，**`cur` 不動**（新的 `cur.next` 也可能要刪）；不用刪才往前走。

## 我的嘗試

2022 年第一次寫這題花了 13 次提交，問題集中在三種：

- **TLE**：第一版只在 `if` 裡移動 `cur`，不需要刪的時候不會前進，例如 `[1]`、`val = 3` 就無限迴圈。
- **RE / WA**：檢查的是 `cur.val`，刪的卻是 `cur.next`。`cur.next` 是 `None` 時取 `.next` 報錯；就算不報錯，**頭節點本身也永遠刪不掉**，例如 `[3]`、`val = 3` 回傳 `[3]`。後來改成檢查 `cur.next.val`，又沒有處理頭節點和 `cur.next` 是 `None` 的情況。

加上 dummy、只看 `cur.next` 之後就 AC 了。

## 正確解法

```python
class Solution:
    def removeElements(self, head: Optional[ListNode], val: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        cur = dummy
        while cur.next:
            if cur.next.val == val:
                cur.next = cur.next.next
            else:
                cur = cur.next
        return dummy.next
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 頭節點也可能要刪，用 dummy。
- 刪除之後 `cur` 不要前進。

## 面試口說整理

我在前面接一個 dummy，只檢查 `cur.next`：等於 `val` 就跳過它、`cur` 不動，否則往前走。最後回傳 `dummy.next`。時間 `O(n)`。
