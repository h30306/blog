---
title: "LeetCode 138: Copy List with Random Pointer"
summary: "LeetCode 138 note: the first pass maps old nodes to new ones, the second wires next and random; seed the dictionary with None -> None"
description: "LeetCode 138 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "hash-table", "linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-29
- Submissions: Wrong Answer → Time Limit Exceeded → Accepted ×2

## Approach

`random` can point to a node not yet created, so make two passes ([Linked List]({{< relref "/algorithm/Linked-List" >}}), Others):

1. First pass: create a new node for each old one and store `old -> new`.
2. Second pass: the new node's `next` is `d[old.next]` and its `random` is `d[old.random]`.

Seed the dictionary with `None: None` so `None` pointers need no special case.

## My Attempts

Attempt 1 hard-coded the example's answer, which of course failed. Attempt 2 used the dictionary approach but forgot `cur = cur.next` in the second loop (TLE); adding it passed.

## Solution

```python
class Solution:
    def copyRandomList(self, head: 'Optional[Node]') -> 'Optional[Node]':
        d = {None: None}
        cur = head
        while cur:
            d[cur] = Node(cur.val)
            cur = cur.next
        cur = head
        while cur:
            d[cur].next = d[cur.next]
            d[cur].random = d[cur.random]
            cur = cur.next
        return d[head]
```

## Complexity

Time `O(n)`, space `O(n)`. Interleaving each new node after its old node gives `O(1)` extra space.

## Mistakes to Avoid

- The second loop must also advance `cur`.
- Key the dictionary by node, not value (values can repeat).

## Interview Explanation

`random` may point at a node not created yet, so one pass maps each old node to a new one and a second pass wires `next` and `random`, with `None` mapped to `None` to avoid special cases. Time and space `O(n)`.
