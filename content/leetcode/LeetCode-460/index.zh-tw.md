---
title: "LeetCode 460: LFU Cache"
summary: "LeetCode 460 解題筆記：key → 節點、freq → 雙向鏈結串列，再記一個 min_freq；同頻率裡用 LRU 決定淘汰誰"
description: "2026-10-31 的 LeetCode 460 解題紀錄"
date: 2026-10-31
tags: ["hard", "hash-table", "linked-list", "design", "doubly-linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-31
- 提交紀錄：Accepted → Wrong Answer → Accepted

## 解題思路

LFU 淘汰「使用次數最少」的 key，次數一樣時淘汰其中最久沒用的。要 `O(1)`：

- `key_to_node`：`key → 節點`，節點存 `key`、`val`、`freq`。
- `freq_to_list`：`freq → 雙向鏈結串列`，每條串列就是那個頻率的 LRU（新的放前面）。
- `min_freq`：目前最小的頻率，淘汰時直接去這條串列的尾巴拿。

**增加一個節點的頻率**（`get` 和更新既有的 key 都要做）：

1. 從 `freq` 的串列拿掉。
2. 如果這條串列空了，而且 `freq == min_freq`，`min_freq += 1`。
3. `freq += 1`，放進新頻率串列的最前面。

**插入新 key**：容量滿了先淘汰 `min_freq` 串列的尾巴；新節點 `freq = 1`，`min_freq = 1`。

`min_freq` 只會在兩個地方變：增加頻率時加一，插入新 key 時重設為 1，所以都是 `O(1)`。

## 我的嘗試

1. 10-31 一次通過。
2. 11-01 重寫，錯了一次，有兩個錯：
   - 判斷串列空了寫成 `self.freq_to_node[node.freq] == 0`，拿**串列物件**和 0 比，永遠是 `False`，`min_freq` 永遠不會往上加。例如容量 1：`put(1,1)`、`get(1)`、`get(1)`、`put(2,2)`：兩次 `get` 之後頻率 1 的串列已經空了，但 `min_freq` 還是 1，`put(2,2)` 要淘汰時去空串列拿 `tail.prev`，拿到的是 head 哨兵，接著存取 `None.next` 就當掉了。應該比 `.count == 0`。
   - 新節點忘了設 `freq = 1`，停在 0。
3. 兩個都修好就過了。

## 正確解法

```python
class Node:
    def __init__(self, key=0, val=0):
        self.key = key
        self.val = val
        self.freq = 1
        self.prev = None
        self.next = None

class DLinkedList:
    def __init__(self):
        self.head = Node()
        self.tail = Node()
        self.head.next = self.tail
        self.tail.prev = self.head
        self.size = 0

    def remove(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev
        self.size -= 1

    def add_to_front(self, node):
        node.prev = self.head
        node.next = self.head.next
        self.head.next.prev = node
        self.head.next = node
        self.size += 1

class LFUCache:
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.key_to_node = {}
        self.freq_to_list = defaultdict(DLinkedList)
        self.min_freq = 0

    def _touch(self, node):
        lst = self.freq_to_list[node.freq]
        lst.remove(node)
        if lst.size == 0 and node.freq == self.min_freq:
            self.min_freq += 1
        node.freq += 1
        self.freq_to_list[node.freq].add_to_front(node)

    def get(self, key: int) -> int:
        if key not in self.key_to_node:
            return -1
        node = self.key_to_node[key]
        self._touch(node)
        return node.val

    def put(self, key: int, value: int) -> None:
        if key in self.key_to_node:
            node = self.key_to_node[key]
            node.val = value
            self._touch(node)
            return
        if len(self.key_to_node) == self.capacity:
            lst = self.freq_to_list[self.min_freq]
            evicted = lst.tail.prev
            lst.remove(evicted)
            del self.key_to_node[evicted.key]
        node = Node(key, value)
        self.key_to_node[key] = node
        self.freq_to_list[1].add_to_front(node)
        self.min_freq = 1
```

## 複雜度

每個操作 `O(1)`，空間 `O(capacity)`。

## 要特別避免的錯誤

- 串列是不是空的要看它的 `size`，不是拿物件和 0 比。
- 新節點的頻率是 1，插入後 `min_freq` 一定變回 1。
- 只有「拿掉的節點剛好在 `min_freq` 串列、而且那條串列空了」時，`min_freq` 才加一。
- `get` 和 `put` 既有的 key 要共用同一個「增加頻率」的函式，避免兩邊寫得不一樣。

## 面試口說整理

我用兩個雜湊表：key 對到節點，頻率對到一條雙向鏈結串列，每條串列內部是 LRU 順序，再記一個 `min_freq`。`get` 或更新既有的 key 時把節點從舊頻率的串列移到新頻率的串列前面，如果舊串列空了而且它是 `min_freq`，就把 `min_freq` 加一。插入新 key 時容量滿就淘汰 `min_freq` 串列的尾巴，新節點頻率 1，`min_freq` 重設為 1。每個操作都是 `O(1)`。
