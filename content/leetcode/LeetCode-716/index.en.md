---
title: "LeetCode 716: Max Stack"
summary: "LeetCode 716 note: store unique ids on both the stack and the heap, record deletions by id, and discard deleted entries lazily; tracking values cannot tell duplicates apart"
description: "LeetCode 716 record from 2026-09-14"
date: 2026-09-14
tags: ["hard", "stack", "heap", "design", "lazy-deletion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-14
- Submissions: Wrong Answer ×2 → Time Limit Exceeded → Accepted ×2

## Approach

Support normal stack operations plus `peekMax` and `popMax`. `popMax` removes an element from the **middle**, which neither a stack nor a heap can do directly.

Use **lazy deletion**, as in the Heap post:

- On push, give each element an increasing **id** and put it on both the stack (`(value, id)`) and a max-heap (`(-value, -id)`).
- `pop` and `popMax` only add the id to a `deleted` set.
- Before `top` and `pop`, pop deleted entries off the stack; before `peekMax` and `popMax`, pop deleted entries off the heap.

The heap uses `(-value, -id)`: on equal values, the larger id (pushed later, higher on the stack) comes out first, matching "remove the top-most maximum".

## My Attempts

### Wrong Answer ×2: recording deletions by value

```python
self.deleted[val] += 1          # one val removed via the heap
self.stack_deleted[val] += 1    # one val removed via the stack
```

A value can appear several times, and counting "one 2 deleted" **cannot tell which 2 was deleted**. Counterexample:

```text
push 1, push 2, popMax, push 3, push 2, top
```

`popMax` deletes the first 2, but it stays on the stack, buried under the 3 pushed later. The newly pushed 2 is on top, `top` sees "a 2 was deleted", throws away this **valid** 2, and returns 3. The correct answer is 2.

### Time Limit Exceeded: ids, but an inverted condition

After switching to ids, `pop` and `top` became:

```python
remove_idx = self.count - 1
while remove_idx not in self.delete:      # should be "in"
    remove_idx -= 1
```

The condition was inverted, and it walked back one index at a time, so it timed out. Storing `(value, id)` on the stack and popping tops whose id is deleted passed.

## Solution

```python
import heapq

class MaxStack:

    def __init__(self):
        self.stack = []          # (value, id)
        self.heap = []           # (-value, -id)
        self.deleted = set()
        self.next_id = 0

    def push(self, x: int) -> None:
        self.stack.append((x, self.next_id))
        heapq.heappush(self.heap, (-x, -self.next_id))
        self.next_id += 1

    def _clean_stack(self) -> None:
        while self.stack[-1][1] in self.deleted:
            self.stack.pop()

    def _clean_heap(self) -> None:
        while -self.heap[0][1] in self.deleted:
            heapq.heappop(self.heap)

    def pop(self) -> int:
        self._clean_stack()
        x, i = self.stack.pop()
        self.deleted.add(i)
        return x

    def top(self) -> int:
        self._clean_stack()
        return self.stack[-1][0]

    def peekMax(self) -> int:
        self._clean_heap()
        return -self.heap[0][0]

    def popMax(self) -> int:
        self._clean_heap()
        neg_x, neg_i = heapq.heappop(self.heap)
        self.deleted.add(-neg_i)
        return -neg_x
```

The problem guarantees the stack is non-empty for `pop`, `top`, `peekMax`, and `popMax`, so cleaning needs no empty check: as long as some element is not deleted, cleaning stops on it.

The first accepted version still had a `print(self.heap)` inside the `peekMax` loop; the last version removed it.

## Complexity

`push`, `pop`, `peekMax`, and `popMax` are amortized `O(log n)`; `top` is amortized `O(1)`. Space `O(n)`.

## Mistakes to Avoid

- Recording deletions by value: duplicates cannot be told apart.
- Removing the wrong copy on equal maxima: the heap needs `-id` so later pushes come out first.
- Inverting the condition when discarding stale entries.

## Interview Explanation

`popMax` removes from the middle, so I use lazy deletion: each element gets a unique id and goes on both a stack and a max-heap ordered by `(-value, -id)`, so the top-most copy of the maximum comes out first. Deleting only adds the id to a set, and queries first discard deleted entries from the relevant top. It must track ids, not values, because values repeat. Each operation is amortized `O(log n)`.
