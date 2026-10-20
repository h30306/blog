---
title: "Queue 與設計題"
summary: "環狀佇列、交錯迭代器、FIFO 配對加上取消，以及設計題常用的資料結構組合"
description: "演算法學習"
date: 2026-10-20
tags: ["queue", "design", "iterator", "lazy-deletion"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

設計題要你實作一個 class，每個方法都有時間複雜度的要求。解題的關鍵是**先把每個操作需要什麼列出來，再挑能同時滿足的資料結構組合**。

| 需求 | 資料結構 |
|---|---|
| 先進先出 | `deque` |
| 判斷存不存在、取消 | `set` / `dict` |
| 隨時拿最大 / 最小 | heap |
| 中間刪除、更新 | lazy deletion，或 dict 記錄目前有效的值 |
| 固定容量、重複使用空間 | 環狀陣列 |

## 模板一：環狀佇列

用固定大小的陣列，加上 `head`（第一個元素的位置）和 `count`（元素數量），位置都對容量取模：

```python
class CircularQueue:
    def __init__(self, k):
        self.buf = [0] * k
        self.head = self.count = 0

    def push(self, x):
        if self.count == len(self.buf):
            return False
        self.buf[(self.head + self.count) % len(self.buf)] = x
        self.count += 1
        return True

    def pop(self):
        if self.count == 0:
            return False
        self.head = (self.head + 1) % len(self.buf)
        self.count -= 1
        return True
```

### 主要參數說明：

- 用 `head + count` 而不是 `head + tail` 兩個指標：不用另外處理「空」和「滿」時兩個指標重疊的歧義。
- 最後一個元素在 `(head + count - 1) % k`（LC 622）。

## 模板二：多個來源交錯輸出

把每個來源放進一個 queue，輪到誰就從誰拿；拿完還有剩就放回 queue 尾端：

```python
from collections import deque

q = deque(iter(v) for v in sources if v)     # 每個來源一個 iterator
def next_value():
    it = q.popleft()
    x = next(it)
    ...                                       # 還有剩就 q.append(it)
```

LC 281 是兩個來源的版本。用 queue 存「還沒用完的來源」，可以直接推廣到 `k` 個。

## 模板三：FIFO 配對 + 取消

兩邊各一個 queue，配對時兩邊各拿最早的一個。取消時不從 queue 中間刪除，只記到 `canceled` 集合，**配對前再把隊頭已取消的丟掉**（lazy deletion）：

```python
while riders and riders[0] in canceled:
    canceled.discard(riders.popleft())
```

判斷「這個人還在不在等」要用 set，不要對 deque 用 `in`，那是 `O(n)`（LC 3829）。

## 已經寫過的設計題

| 題目 | 資料結構組合 | 文章 |
|---|---|---|
| LC 716 Max Stack | stack + heap + 唯一 id 的 lazy deletion | Stack |
| LC 3815、3885 | dict + heap 的 lazy deletion | Heap |
| LC 2102 | 雙 heap | Heap |
| LC 3508 Implement Router | deque + set + 每個目的地的有序時間陣列 | Binary Search |
| LC 3709 | 前綴和 + bisect | Binary Search |

## 常見錯誤

- 對 deque 或 list 用 `in` 判斷存在：`O(n)`。
- 環狀陣列的最後一個位置算錯，忘記減 1 再取模。
- 迭代器的 `hasNext` 有副作用：可以這樣寫，但要確保連續呼叫多次結果一樣。

## 相關 LeetCode

- `LC 622` Design Circular Queue
- `LC 281` Zigzag Iterator
- `LC 3829` Design Ride Sharing System
- `LC 1290` Convert Binary Number in a Linked List to Integer
