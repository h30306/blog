---
title: "LeetCode 138: Copy List with Random Pointer"
summary: "LeetCode 138 解題筆記：第一次走過建立舊節點到新節點的字典，第二次接上 next 和 random；字典裡先放 None -> None"
description: "2022-10-29 的 LeetCode 138 解題紀錄"
date: 2022-10-29
tags: ["medium", "hash-table", "linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-29
- 提交紀錄：Wrong Answer → Time Limit Exceeded → Accepted ×2

## 解題思路

`random` 可能指到後面還沒建立的節點，所以分兩次走（[Linked List]({{< relref "/algorithm/Linked-List" >}})「其他」）：

1. 第一次：每個舊節點建一個新節點，存進字典 `old -> new`。
2. 第二次：新節點的 `next` 是 `d[old.next]`、`random` 是 `d[old.random]`。

字典裡先放 `None: None`，指標是 `None` 時就不用特判。

## 我的嘗試

第一版把範例的答案寫死了，當然 WA。第二版用了字典的做法，但第二個迴圈忘了 `cur = cur.next`，TLE；加上就 AC 了。

## 正確解法

```python
class Solution:
    def copyRandomList(self, head: 'Optional[Node]') -> 'Optional[Node]':
        d = {None: None}
        cur = head
        while cur:
            d[cur] = Node(cur.val)
            cur = cur.next
        cur = head
        while cur:
            d[cur].next = d[cur.next]
            d[cur].random = d[cur.random]
            cur = cur.next
        return d[head]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。也可以把新節點插在每個舊節點後面，做到 `O(1)` 額外空間。

## 要特別避免的錯誤

- 第二個迴圈也要讓 `cur` 前進。
- 字典的 key 是節點本身，不是值（值可能重複）。

## 面試口說整理

`random` 可能指向還沒建立的節點，所以我先走一次建立舊節點到新節點的對應，再走一次接上 `next` 和 `random`。字典先放 `None` 對 `None`，就不用特判。時間和空間都是 `O(n)`。
