---
title: "LeetCode 117: Populating Next Right Pointers in Each Node II"
summary: "LeetCode 117 note: connect next pointers level by level with BFS; for a non-perfect tree, looking only at the neighbour's children breaks the chain"
description: "LeetCode 117 record from 2022-11-18"
date: 2022-11-18
tags: ["medium", "linked-list", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-18
- Submissions: Wrong Answer → Runtime Error → Wrong Answer → Accepted

## Approach

Each node's `next` must point to the node on its right in the same level. Process the tree level by level with BFS ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2): while handling a level, the next node in the queue is the one to the right, so every node except the last one in its level gets `node.next = q[0]`.

## My Attempts

In 2022 I wrote three recursive versions and none passed:

- The idea was to wire the children while standing on `root`: the right child links to a child of `root.next`. But **`root.next` may have no children**, and then the search should continue to `root.next.next`; my code gave up. For `[1,2,3,4,null,5,6,7,8,null,null,null,9]`, node 8 should skip childless 5 and link to 6's child 9, but it got `None`.
- One submission typed `node` instead of `root`, a Runtime Error.

On 2026-10-24 I switched to BFS and passed on the first try.

## Solution

```python
class Solution:
    def connect(self, root: 'Node') -> 'Node':
        if not root:
            return None
        q = deque([root])
        while q:
            n = len(q)
            for i in range(n):
                node = q.popleft()
                if i < n - 1:
                    node.next = q[0]
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
        return root
```

## Follow-up: O(1) extra space

Once a level's `next` pointers are set, the level is a linked list. Walk it and chain the next level's children with a dummy head ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 1):

```python
class Solution:
    def connect(self, root: 'Node') -> 'Node':
        head = root
        while head:
            dummy = tail = Node(0)
            cur = head
            while cur:
                for child in (cur.left, cur.right):
                    if child:
                        tail.next = child
                        tail = child
                cur = cur.next
            head = dummy.next
        return root
```

## Complexity

BFS: time `O(n)`, space `O(w)` for the widest level. Linked-list version: time `O(n)`, extra space `O(1)`.

## Mistakes to Avoid

- In a non-perfect tree the neighbour may have no children; keep moving right until a node with children is found.
- Do not link the last node of a level to the first node of the next level.

## Interview Explanation

I process the tree level by level with BFS. Within a level the next node in the queue is the right neighbour, so every node but the last gets `node.next = q[0]`; that is `O(n)` time. For `O(1)` space, I walk the previous level through its `next` pointers as a linked list and chain the next level's children with a dummy head.
