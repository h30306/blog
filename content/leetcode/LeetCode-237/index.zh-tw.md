---
title: "LeetCode 237: Delete Node in a Linked List"
summary: "LeetCode 237 解題筆記：拿不到前一個節點，就把下一個節點的值複製過來，再刪掉下一個節點"
description: "2022-08-22 的 LeetCode 237 解題紀錄"
date: 2022-08-22
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
第一次嘗試：2022-08-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

只給要刪的節點、拿不到前一個，所以沒辦法讓前一個跳過它。換個方式：**把下一個節點的值複製到自己，再刪掉下一個節點**（[Linked List]({{< relref "/algorithm/Linked-List" >}})「其他」）。題目保證要刪的不是最後一個，所以下一個一定存在。

## 我的解法

```python
class Solution:
    def deleteNode(self, node):
        node.val = node.next.val
        node.next = node.next.next
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 這招只在「不是最後一個節點」時可行。

## 面試口說整理

拿不到前一個節點就沒辦法真的刪掉自己，所以我把下一個節點的值複製過來，再跳過下一個節點，效果等同刪掉自己。時間 `O(1)`。
