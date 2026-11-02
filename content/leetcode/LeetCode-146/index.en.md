---
title: "LeetCode 146: LRU Cache"
summary: "LeetCode 146 note: a hash map finds nodes and a doubly linked list keeps the usage order; both get and updating an existing key must move the node to the front"
description: "LeetCode 146 record from 2026-10-31"
date: 2026-10-31
tags: ["medium", "hash-table", "linked-list", "design", "doubly-linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-31
- Submissions: Accepted → Wrong Answer → Accepted ×2

## Approach

Both `get` and `put` must be `O(1)`:

- A **hash map** `key → node` finds a node in `O(1)`.
- A **doubly linked list** keeps the usage order, newest first. With head and tail sentinels, any node can be unlinked in `O(1)` and inserted after head.

Operations:

- `get(key)`: return -1 if missing; otherwise move the node to the front and return its value.
- `put(key, value)`: if the key exists, update the value **and move it to the front**; otherwise create a node at the front, and if over capacity remove the node before tail (least recently used) and delete it from the map. Each node stores its `key` so eviction knows which map entry to delete.

## My Attempts

1. Accepted on the first try.
2. In a rewrite the same day, `put` on an existing key updated the value but **did not move it to the front**. With capacity 2: `put(1,1)`, `put(2,2)`, `put(1,10)`, `put(3,3)` should evict 2, but it evicted 1, and `get(1)` then returned -1 instead of 10.
3. Adding the move passed; another rewrite that evening also passed on the first try.

## Solution

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

## Complexity

`O(1)` per operation, `O(capacity)` space.

## Mistakes to Avoid

- Updating an existing key is a "use" and must move it to the front.
- Store the `key` in each node so eviction can delete it from the map.
- Two sentinels remove the special cases for an empty or one-node list.
- Pointer order in `_add_to_front`: set the new node's `prev` and `next` first, then update the old nodes, or the reference to `head.next` is lost.

## Interview Explanation

I combine a hash map with a doubly linked list: the map finds a node by key, and the list keeps usage order, newest at the front, with two sentinels. `get` and updating an existing key move the node to the front; a new key goes to the front, and if over capacity I remove the node before tail and delete its key, stored in the node, from the map. Every operation is `O(1)`. In Python `OrderedDict` with `move_to_end` and `popitem(last=False)` also works, but interviews usually expect the manual version.
