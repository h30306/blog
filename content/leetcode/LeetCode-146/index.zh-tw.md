---
title: "LeetCode 146: LRU Cache"
summary: "LeetCode 146 解題筆記：雜湊表找節點、雙向鏈結串列維護使用順序；get 和更新既有的 key 都要移到最前面"
description: "2026-10-31 的 LeetCode 146 解題紀錄"
date: 2026-10-31
tags: ["medium", "hash-table", "linked-list", "design", "doubly-linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-31
- 提交紀錄：Accepted → Wrong Answer → Accepted ×2

## 解題思路

要 `get`、`put` 都是 `O(1)`：

- **雜湊表**：`key → 節點`，`O(1)` 找到節點。
- **雙向鏈結串列**：越前面越新。用 head、tail 兩個哨兵節點，任何節點都可以 `O(1)` 拿掉，再插到 head 後面。

操作：

- `get(key)`：不存在回傳 -1；存在就把節點移到最前面，回傳值。
- `put(key, value)`：已存在就更新值**並移到最前面**；不存在就建節點放最前面，超過容量時拿掉 tail 前面那個（最久沒用的），也從雜湊表刪掉。節點裡要存 `key`，刪的時候才知道要刪雜湊表的哪一筆。

## 我的嘗試

1. 一次通過。
2. 同一天重寫：`put` 已存在的 key 時只更新值，**沒有移到最前面**。例如容量 2：`put(1,1)`、`put(2,2)`、`put(1,10)`、`put(3,3)`，應該淘汰 2，結果淘汰了 1，之後 `get(1)` 回傳 -1，答案是 10。
3. 補上移動就過了，晚上又重寫一次也一次通過。

## 正確解法

```python
class Node:
    def __init__(self, key=0, val=0):
        self.key = key
        self.val = val
        self.prev = None
        self.next = None

class LRUCache:
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache = {}
        self.head = Node()
        self.tail = Node()
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev

    def _add_to_front(self, node):
        node.prev = self.head
        node.next = self.head.next
        self.head.next.prev = node
        self.head.next = node

    def get(self, key: int) -> int:
        if key not in self.cache:
            return -1
        node = self.cache[key]
        self._remove(node)
        self._add_to_front(node)
        return node.val

    def put(self, key: int, value: int) -> None:
        if key in self.cache:
            node = self.cache[key]
            node.val = value
            self._remove(node)
            self._add_to_front(node)
            return
        node = Node(key, value)
        self.cache[key] = node
        self._add_to_front(node)
        if len(self.cache) > self.capacity:
            lru = self.tail.prev
            self._remove(lru)
            del self.cache[lru.key]
```

## 複雜度

每個操作 `O(1)`，空間 `O(capacity)`。

## 要特別避免的錯誤

- 更新既有的 key 也算「使用」，要移到最前面。
- 節點要存 `key`，淘汰時才能從雜湊表刪掉。
- 用兩個哨兵節點，就不用處理串列為空或只有一個節點的特例。
- `_add_to_front` 裡的指標順序：先設好新節點的 `prev`、`next`，再改舊節點，不然會失去 `head.next` 的參考。

## 面試口說整理

我用雜湊表加雙向鏈結串列：雜湊表從 key 找到節點，串列維護使用順序，前面最新、後面最舊，用兩個哨兵節點。`get` 和更新既有的 key 都把節點移到最前面；新 key 插到最前面，超過容量就刪掉 tail 前面的節點，並用節點裡存的 key 從雜湊表刪掉。每個操作都是 `O(1)`。Python 也可以用 `OrderedDict` 的 `move_to_end` 和 `popitem(last=False)`，但面試通常要自己實作。
