---
title: "LeetCode 281: Zigzag Iterator"
summary: "LeetCode 281 解題筆記：queue 裡放還沒用完的來源，輪流取一個，還有剩就放回尾端；可以直接推廣到 k 個"
description: "2026-04-29 的 LeetCode 281 解題紀錄"
date: 2026-04-29
tags: ["medium", "queue", "design", "iterator"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-29
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩個陣列輪流各輸出一個；其中一個用完後，剩下的全部從另一個輸出。

## 我的解法：兩個 deque 加上輪到誰的旗標

```python
def hasNext(self) -> bool:
    if self.next_pop == "v1":
        if self.queue1:
            return True
        elif self.queue2:
            self.next_pop = "v2"
            return True
        return False
    ...
```

`hasNext` 裡面順便處理「輪到的那邊已經空了，就換另一邊」。可以 AC，但兩邊的邏輯是重複的，而且 Follow-up 問「如果有 `k` 個陣列呢？」時就要改很多。

## 更好的做法：queue 裡放來源

queue 裡放「還有元素的來源」和它目前讀到的位置。每次 `next` 取出隊頭的來源，讀一個值；這個來源還有剩，就放回 queue 尾端：

```python
from collections import deque

class ZigzagIterator:
    def __init__(self, v1: List[int], v2: List[int]):
        self.q = deque((v, 0) for v in (v1, v2) if v)

    def next(self) -> int:
        v, i = self.q.popleft()
        if i + 1 < len(v):
            self.q.append((v, i + 1))
        return v[i]

    def hasNext(self) -> bool:
        return bool(self.q)
```

要支援 `k` 個陣列，只要建構時把 `k` 個來源都放進 queue。`hasNext` 也不再有副作用。

## 複雜度

`next` 和 `hasNext` 都是 `O(1)`，空間 `O(k)`，不算原本的陣列。

## 要特別避免的錯誤

- 空的陣列也放進 queue：之後 `next` 會讀到越界。
- `hasNext` 有副作用：連續呼叫多次時，必須確保結果不變。

## 面試口說整理

我用一個 queue 存還有元素的來源和目前的位置。每次 `next` 從隊頭的來源取一個值，還有剩就放回尾端，這樣就自然輪流輸出，用完的來源也自動被移除。`hasNext` 只要看 queue 是不是空的。要推廣到 `k` 個陣列，只要把 `k` 個來源都放進 queue，每個操作都是 `O(1)`。
