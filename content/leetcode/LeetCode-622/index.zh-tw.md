---
title: "LeetCode 622: Design Circular Queue"
summary: "LeetCode 622 解題筆記：固定大小陣列加上 head 和 count，位置都對容量取模，空和滿用 count 判斷"
description: "2026-09-14 的 LeetCode 622 解題紀錄"
date: 2026-09-14
tags: ["medium", "queue", "design", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-09-14
- 提交紀錄：Accepted（一次通過）

## 解題思路

環狀佇列用一個固定大小 `k` 的陣列，空間用完之後從頭開始重複使用。

只需要兩個變數：

- `head`：第一個元素的位置。
- `count`：目前有幾個元素。

其他位置都能算出來：

| 要找的位置 | 公式 |
|---|---|
| 下一個要寫入的位置 | `(head + count) % k` |
| 最後一個元素 | `(head + count - 1) % k` |
| 出隊後的新 head | `(head + 1) % k` |

用 `count` 判斷空和滿，就不會遇到「`head == tail` 時到底是空還是滿」的問題。

## 我的解法

```python
class MyCircularQueue:

    def __init__(self, k: int):
        self.buf = [0] * k
        self.head = 0
        self.count = 0

    def enQueue(self, value: int) -> bool:
        if self.isFull():
            return False
        self.buf[(self.head + self.count) % len(self.buf)] = value
        self.count += 1
        return True

    def deQueue(self) -> bool:
        if self.isEmpty():
            return False
        self.head = (self.head + 1) % len(self.buf)
        self.count -= 1
        return True

    def Front(self) -> int:
        return -1 if self.isEmpty() else self.buf[self.head]

    def Rear(self) -> int:
        return -1 if self.isEmpty() else self.buf[(self.head + self.count - 1) % len(self.buf)]

    def isEmpty(self) -> bool:
        return self.count == 0

    def isFull(self) -> bool:
        return self.count == len(self.buf)
```

## 複雜度

每個操作 `O(1)`，空間 `O(k)`。

## 要特別避免的錯誤

- 用 `head` 和 `tail` 兩個指標，卻沒有額外記錄數量：空和滿時兩個指標都相等，分不出來。
- `Rear` 的位置忘記減 1。
- 出隊時去清空陣列的值：不需要，之後寫入會直接覆蓋。

## 面試口說整理

我用一個大小為 `k` 的陣列，加上第一個元素的位置 `head` 和元素數量 `count`。入隊寫在 `(head + count) % k`，出隊把 `head` 往後移一格並取模，最後一個元素在 `(head + count - 1) % k`。空和滿直接看 `count`，所以不會有兩個指標重疊時的歧義。每個操作都是 `O(1)`。
