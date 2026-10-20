---
title: "LeetCode 23: Merge k Sorted Lists"
summary: "LeetCode 23 note: a heap that holds only k heads, and divide-and-conquer pairwise merging"
description: "LeetCode 23 record from the 2026-10-20 merge sort practice ladder"
date: 2026-10-20
tags: ["hard", "linked-list", "heap", "merge-sort", "divide-and-conquer"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-20
Source: extension of the merge sort practice ladder (high frequency)

## Approach

Let `N` be the total number of nodes and `k` the number of lists. The target is `O(N log k)`.

- **Heap**: each list is sorted, so the smallest remaining node is always the head of some list. The heap only needs the `k` heads.
- **Divide and conquer**: treat each list as one element and run merge sort over the lists. The merge step is LC 21.

## My Attempts

### Attempt 1: push every value into a heap

```python
pq = []
dummy = tail = ListNode()
for node in lists:
    while node:
        heapq.heappush(pq, node.val)
        node = node.next

while pq:
    node = heapq.heappop(pq)
    tail.next = ListNode(node)
    tail = tail.next

return dummy.next
```

It passes, but runs in `O(N log N)` time and `O(N)` space. It is equivalent to dumping all values, sorting them, and rebuilding the list, so it ignores that each list is already sorted. It also creates `N` new nodes, and `node = heappop(...)` actually holds a value, which is a misleading name.

### Attempt 2: divide and conquer

```python
def mergeAndSort(low: int, high: int):
    if high - low == 0:
        return None
    if high - low == 1:
        return list[low]          # should be lists[low]

    mid = (low + high) // 2
    return merge(mergeAndSort(low, mid), mergeAndSort(mid, high))
```

The structure is right except for one typo. `list` is a built-in type, and `list[low]` is valid type-hint syntax, so it **does not fail immediately**. The `AttributeError` only appears later when `merge` reads `.val`. When the error shows up somewhere other than where the bug is, it is the hardest kind to find.

A typo that produces an undefined name fails right away with `NameError`. A typo that happens to match an existing name (`list`, `dict`, `sum`, `max`, `id`) keeps running silently.

## Solution

### Divide and conquer (merge sort)

```python
class Solution:
    def mergeKLists(self, lists: list[ListNode | None]) -> ListNode | None:

        def merge(a: ListNode | None, b: ListNode | None) -> ListNode | None:   # LC 21
            dummy = tail = ListNode()
            while a and b:
                if a.val <= b.val:
                    tail.next = a
                    a = a.next
                else:
                    tail.next = b
                    b = b.next
                tail = tail.next
            tail.next = a or b
            return dummy.next

        def mergeAndSort(low: int, high: int) -> ListNode | None:
            if high - low == 0:
                return None                    # empty input; avoids infinite recursion
            if high - low == 1:
                return lists[low]
            mid = (low + high) // 2
            return merge(mergeAndSort(low, mid), mergeAndSort(mid, high))

        return mergeAndSort(0, len(lists))
```

### Heap with only k heads

```python
import heapq

class Solution:
    def mergeKLists(self, lists: list[ListNode | None]) -> ListNode | None:
        pq = []
        for i, node in enumerate(lists):
            if node:
                heapq.heappush(pq, (node.val, i, node))

        dummy = tail = ListNode()
        while pq:
            _, i, node = heapq.heappop(pq)
            tail.next = node                   # reuse the original node
            tail = tail.next
            if node.next:
                heapq.heappush(pq, (node.next.val, i, node.next))
        return dummy.next
```

The `i` in the middle of the tuple matters: on equal values, Python compares the next field, and comparing `ListNode` objects raises `TypeError`. Each list has at most one node in the heap at a time, so `i` is never repeated.

### Bottom-up iteration (O(1) space)

```python
k = len(lists)
if k == 0:
    return None
step = 1
while step < k:
    for i in range(0, k - step, step * 2):
        lists[i] = merge(lists[i], lists[i + step])
    step *= 2
return lists[0]
```

This modifies the input `lists`; mention it in an interview.

## Complexity

| Approach | Time | Space |
|---|---|---|
| Push every value into a heap | `O(N log N)` | `O(N)` |
| Heap with k heads | `O(N log k)` | `O(k)` |
| Divide and conquer, recursive | `O(N log k)` | `O(log k)` |
| Divide and conquer, bottom-up | `O(N log k)` | `O(1)` |
| Merge lists one by one | `O(N k)` | `O(1)` |

Divide and conquer has `log k` levels, and every node is merged once per level, so each level costs `O(N)`. When merging one list at a time, nodes from the first list are rescanned in every later merge, about `N k / 2` work in total.

## Mistakes to Avoid

- Only handling `high - low == 1`: with `lists = []`, `mergeAndSort(0, 0)` recurses forever.
- Leaving out a tie-breaker in the heap tuple.
- Naming a variable after a built-in.

## Interview Explanation

Each list is sorted, so there are two `O(N log k)` approaches. One keeps only the current head of each list in a heap: pop the smallest, attach it, and push its successor. The other is divide and conquer: treat the k lists as merge sort elements and merge them in pairs using LC 21, giving `log k` levels at `O(N)` each. If the lists arrive as streams and I cannot see them all at once, I would choose the heap, because it only needs the current head of each list.
