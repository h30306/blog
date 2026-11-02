---
title: "LeetCode 460: LFU Cache"
summary: "LeetCode 460 note: key → node, freq → doubly linked list, plus a min_freq; within the same frequency, LRU decides what to evict"
description: "LeetCode 460 record from 2026-10-31"
date: 2026-10-31
tags: ["hard", "hash-table", "linked-list", "design", "doubly-linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-31
- Submissions: Accepted → Wrong Answer → Accepted

## Approach

LFU evicts the key with the lowest use count, breaking ties by least recent use. For `O(1)`:

- `key_to_node`: `key → node`, where a node stores `key`, `val` and `freq`.
- `freq_to_list`: `freq → doubly linked list`; each list is an LRU list for that frequency (newest first).
- `min_freq`: the current minimum frequency, so eviction takes the tail of that list directly.

**Increasing a node's frequency** (for `get` and for updating an existing key):

1. Remove it from the `freq` list.
2. If that list is now empty and `freq == min_freq`, do `min_freq += 1`.
3. `freq += 1` and add it to the front of the new frequency's list.

**Inserting a new key**: if full, first evict the tail of the `min_freq` list; the new node has `freq = 1` and `min_freq = 1`.

`min_freq` changes in only two places, incremented when raising a frequency and reset to 1 on insert, so everything is `O(1)`.

## My Attempts

1. Accepted on the first try on 10-31.
2. A rewrite on 11-01 had one wrong answer with two bugs:
   - The empty-list check was written `self.freq_to_node[node.freq] == 0`, comparing the **list object** with 0, which is always `False`, so `min_freq` never increased. With capacity 1: `put(1,1)`, `get(1)`, `get(1)`, `put(2,2)`. After the two `get` calls the frequency-1 list is empty but `min_freq` is still 1, so `put(2,2)` evicts `tail.prev` from the empty list, gets the head sentinel, and then crashes on `None.next`. It should compare `.count == 0`.
   - The new node's `freq` was never set to 1 and stayed at 0.
3. Fixing both passed.

## Solution

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

## Complexity

`O(1)` per operation, `O(capacity)` space.

## Mistakes to Avoid

- Check whether a list is empty with its `size`, not by comparing the object with 0.
- A new node has frequency 1, and after an insert `min_freq` is always 1.
- `min_freq` increases only when the removed node was in the `min_freq` list and that list became empty.
- Share one "increase frequency" helper between `get` and `put` on an existing key so the two paths cannot diverge.

## Interview Explanation

I use two hash maps: key to node, and frequency to a doubly linked list kept in LRU order, plus a `min_freq`. On `get` or updating an existing key I move the node from its old frequency list to the front of the next one, and if the old list became empty and was `min_freq`, I increment `min_freq`. On a new key, if full I evict the tail of the `min_freq` list; the new node has frequency 1 and `min_freq` resets to 1. Every operation is `O(1)`.
