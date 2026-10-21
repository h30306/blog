---
title: "LeetCode 876: Middle of the Linked List"
summary: "LeetCode 876 解題筆記：快指針一次兩步、慢指針一次一步，快的走到底時慢的在中間；偶數長度時停在偏右的中點"
description: "2022-09-20 的 LeetCode 876 解題紀錄"
date: 2022-09-20
tags: ["easy", "linked-list", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-20
- 提交紀錄：Runtime Error ×3 → Accepted ×3 → Time Limit Exceeded → Runtime Error → Wrong Answer → Accepted

## 解題思路

快指針的速度是慢指針的兩倍，快的走完時慢的剛好走一半（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板三）。條件用 `while fast and fast.next`：偶數長度時會多走一步，`slow` 停在兩個中點的第二個，剛好是題目要的。

## 我的嘗試

第一次寫時先把值存進 list 再取中間，index 算錯了幾次（偶數長度用了 `/` 得到浮點數，奇數長度又多加了 1），而且回傳的是值、不是節點。之後改寫成兩個指標時：

- 一版迴圈裡沒有移動 `node`，還直接取 `node.next.next`，`[3]` 時報錯。
- 一版先更新 `middle = node.next` 再走兩步，多走了一格，`[7, 1, 7, 2]` 回傳 `[2]`，答案是 `[7, 2]`。

## 正確解法

```python
class Solution:
    def middleNode(self, head: Optional[ListNode]) -> Optional[ListNode]:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
        return slow
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 偶數長度要停在第二個中點，迴圈條件決定停在哪一個。

## 面試口說整理

快指針一次兩步、慢指針一次一步，快的走到底時慢的就在中間；用 `fast and fast.next` 當條件，偶數長度時剛好停在第二個中點。時間 `O(n)`。
