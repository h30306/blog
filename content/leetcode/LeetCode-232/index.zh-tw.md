---
title: "LeetCode 232: Implement Queue using Stacks"
summary: "LeetCode 232 解題筆記：兩個 stack：in 負責 push，out 空的時候才把 in 全部倒過去，均攤 O(1)"
description: "2022-08-22 的 LeetCode 232 解題紀錄"
date: 2022-08-22
tags: ["easy", "stack", "design", "queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

`inbox` 負責 `push`，`outbox` 負責 `pop` 和 `peek`（[Queue and Design]({{< relref "/algorithm/Queue-and-Design" >}})）。`outbox` 是空的時候，把 `inbox` 的元素全部 `pop` 進 `outbox`，順序就反過來，最早進來的在頂端。每個元素最多搬一次，所以均攤 `O(1)`。**`outbox` 不是空的時不能倒**，不然順序會亂。

## 我的嘗試

一次 AC，但當時直接用 list 的 `pop(0)` 當 queue，**沒有照題目用兩個 stack**，而且 `pop(0)` 是 `O(n)`。

## 正確解法

```python
class MyQueue:
    def __init__(self):
        self.inbox, self.outbox = [], []

    def push(self, x: int) -> None:
        self.inbox.append(x)

    def _move(self):
        if not self.outbox:
            while self.inbox:
                self.outbox.append(self.inbox.pop())

    def pop(self) -> int:
        self._move()
        return self.outbox.pop()

    def peek(self) -> int:
        self._move()
        return self.outbox[-1]

    def empty(self) -> bool:
        return not self.inbox and not self.outbox
```

## 複雜度

均攤 `O(1)`，空間 `O(n)`。

## 要特別避免的錯誤

- `outbox` 空的時候才搬。
- `empty` 要兩個 stack 都是空的。

## 面試口說整理

我用兩個 stack，push 都放進第一個，pop 和 peek 從第二個拿；第二個空的時候才把第一個全部倒過去，順序剛好反過來變成 FIFO。每個元素最多搬一次，均攤 `O(1)`。
