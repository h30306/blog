---
title: "LeetCode 82: Remove Duplicates from Sorted List II"
summary: "LeetCode 82 解題筆記：重複的值要全部刪掉，頭也可能被刪，所以用 dummy；發現重複就一路跳到不同的值，再讓 prev.next 接過去"
description: "2022-10-26 的 LeetCode 82 解題紀錄"
date: 2022-10-26
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
第一次嘗試：2022-10-26
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted → Wrong Answer → Accepted → Runtime Error ×2 → Accepted ×3

## 解題思路

跟 LC 83 不同，重複的值**一個都不留**，頭也可能被刪，所以用 dummy（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板一）：

- `prev` 是最後一個確定留下來的節點。
- `cur = prev.next`。如果 `cur` 跟下一個一樣，就一路往後跳過所有同樣的值，再讓 `prev.next` 指向第一個不同的節點（`prev` 不動，那個節點還要再檢查）。
- 沒有重複就 `prev` 往前走。

## 我的嘗試

2022 年提交了 16 次：

- 前幾版沒有 dummy、沒有處理空串列，`[]` 時取 `None.next` 報錯；有一版連回傳值都沒寫。
- 加了 dummy 之後，一版最後回傳 `prev.next`：`prev` 已經往後移了，回傳的不是頭。例如 `[1, 2]`：答案 `[1, 2]`，回傳 `[2]`。
- 一版內層 `while` 沒檢查 `cur.next`，`[1, 1]` 時報錯。

## 正確解法

```python
class Solution:
    def deleteDuplicates(self, head: Optional[ListNode]) -> Optional[ListNode]:
        dummy = prev = ListNode(0, head)
        while prev.next:
            cur = prev.next
            if cur.next and cur.val == cur.next.val:
                while cur.next and cur.val == cur.next.val:
                    cur = cur.next
                prev.next = cur.next                 # 整段重複的都跳過
            else:
                prev = prev.next
        return dummy.next
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 跳過重複之後 `prev` 不要前進，新的 `prev.next` 也可能是重複的。
- 回傳 `dummy.next`，不是 `prev.next`。

## 面試口說整理

重複的全部刪，頭也可能被刪，所以我用 dummy，`prev` 是最後確定保留的節點。看到重複就跳到下一個不同的值，讓 `prev.next` 直接接過去；沒有重複才讓 `prev` 前進。時間 `O(n)`。
