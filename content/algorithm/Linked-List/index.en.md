---
title: "Linked List"
summary: "Dummy heads, reversal (whole list, a range, half), fast and slow pointers for middles and cycles, two pointers n apart, pairwise swaps, two lists meeting, and copying a list with random pointers via a hash map"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["linked-list", "two-pointers"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Linked list problems rarely need a special algorithm; the hard part is **the order of pointer updates**: change the wrong pointer first and the rest of the list is lost. A few fixed tools:

| Tool | Solves | Examples |
|---|---|---|
| Dummy head | The head may be deleted or replaced | Remove a value, remove duplicates, remove the n-th from the end |
| Reversal | Looking from the back | Reverse all, reverse a range, palindrome, reorder |
| Fast and slow pointers | Find the middle, detect a cycle | Middle node, cycle entry, halving for sort |
| Two pointers a fixed gap apart | Counting from the tail | Remove the n-th from the end, rotate |
| Two lists switching heads | Aligning different lengths | Intersection of two lists |

## Template 1: Dummy head

When the head might be deleted, put a fake node in front so every deletion becomes "delete `cur.next`", with no special case for the head:

```python
dummy = ListNode(0, head)
cur = dummy
while cur.next:
    if should_delete(cur.next):
        cur.next = cur.next.next         # stay put: the next one may need deleting too
    else:
        cur = cur.next
return dummy.next
```

- **Remove a value** (LC 203), **remove duplicates keeping one** (LC 83), **remove every duplicated value** (LC 82).
- **Split into less-than / greater-or-equal** (LC 86): two dummies collect each part, joined at the end; set the second part's tail to `None`.
- **Add two numbers** (LC 2): the dummy collects each digit, and `carry` continues until both lists end and no carry remains.

## Template 2: Reversal

```python
prev, cur = None, head
while cur:
    nxt = cur.next                       # save the next node before overwriting cur.next
    cur.next = prev
    prev, cur = cur, nxt
return prev                              # the new head
```

- **Reverse the whole list** (LC 206): the code above.
- **Reverse a range** (LC 92): walk to node `left - 1`, `pre`, then move the following nodes one by one "to just after `pre`", `right - left` times.
- **Palindrome** (LC 234): find the middle with fast and slow pointers, reverse the second half, compare from both ends.
- **Reorder head-tail alternately** (LC 143): find the middle, reverse the second half, merge the two alternately.
- **Remove nodes with a larger value to the right** (LC 2487): from the right only the running maximum matters, so reverse and scan once, or use a monotonic stack.

## Template 3: Fast and slow pointers

```python
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
# with an even length, slow stops at the right-middle node
```

- **Middle node** (LC 876): the code above.
- **Cycle detection** (LC 141): with a cycle, `fast` must catch `slow`; both advance from **their own positions**, not recomputed from `head` each time.
- **Cycle entry** (LC 142): after they meet, send one pointer back to `head` and step both one at a time; they meet again at the entry.
- **Sorting** (LC 148): split in half with fast and slow pointers, sort recursively, and merge; see [Merge Sort]({{< relref "/algorithm/Merge-Sort" >}}).
- **Balanced BST from a sorted list** (LC 109): the middle becomes the root, and each half recurses.

## Template 4: Two pointers a fixed gap apart

```python
fast = slow = dummy
for _ in range(n + 1):                   # fast goes n + 1 steps ahead
    fast = fast.next
while fast:
    fast, slow = fast.next, slow.next
slow.next = slow.next.next               # slow stops just before the node to delete
```

- **Remove the n-th node from the end** (LC 19): the code above; starting from the dummy allows deleting the head.
- **Rotate right by `k`** (LC 61): count the length, `k %= n`, and the new tail is node `n - k`.

## Template 5: Pairwise swaps

```python
prev = dummy
while prev.next and prev.next.next:
    a, b = prev.next, prev.next.next
    prev.next, a.next, b.next = b, b.next, a   # the right side is evaluated first, then assigned together
    prev = a
```

- **Swap nodes in pairs** (LC 24): swap the nodes, not the values.

## Template 6: Two lists switching heads

```python
a, b = headA, headB
while a is not b:
    a = a.next if a else headB           # after your own list, walk the other one
    b = b.next if b else headA
return a                                 # the intersection, or both reach None
```

Both pointers travel `lenA + lenB` steps and reach the intersection together; with no intersection they reach `None` together (LC 160).

## Others

- **Copy a list with random pointers** (LC 138): the first pass builds an "old node -> new node" dictionary, the second wires `next` and `random`.
- **Delete a node given only that node** (LC 237): copy the next node's value over, then delete the next node.
- **Link each tree level with `next`** (LC 116): in a perfect binary tree, walk a level using the `next` pointers already set on the level above, with `O(1)` extra space.
- **Implement a HashSet** (LC 705): a fixed number of buckets, each a list (or linked list) to handle collisions.

## Key Parameters

- `while cur.next` versus `while cur`: use the former when deleting `cur.next`, the latter when just visiting every node.
- Before changing a pointer, save any node you still need in a variable.

## Complexity

These operations walk the list a constant number of times: time `O(n)`, extra space `O(1)` (LC 138's dictionary is `O(n)`).

## Common Mistakes

These are mistakes I actually made while practicing:

- **Not handling an empty list**: reading `head.next` when `head` is `None`, Runtime Error (LC 83, 141, 19 and many others).
- **Not advancing after a deletion**: deleting inside the `if` with no advance in the `else`, or skipping one extra node after deleting, causing TLE or missed deletions (LC 203).
- **Recomputing fast and slow from `head`**: `slow = head.next` keeps both pointers in place forever, TLE (LC 141).
- **Wrong order in a multiple assignment**: changing `node.next` first while swapping, so the later `node.next.next` pointed at the wrong node (LC 24).
- **Hard-coding the example's answer** (LC 138).

## Related LeetCode

- `LC 203` Remove Linked List Elements
- `LC 206` Reverse Linked List
- `LC 234` Palindrome Linked List
- `LC 92` Reverse Linked List II
- `LC 24` Swap Nodes in Pairs
- `LC 160` Intersection of Two Linked Lists
- `LC 141` Linked List Cycle
- `LC 142` Linked List Cycle II
- `LC 876` Middle of the Linked List
- `LC 148` Sort List
- `LC 109` Convert Sorted List to Binary Search Tree
- `LC 83` Remove Duplicates from Sorted List
- `LC 82` Remove Duplicates from Sorted List II
- `LC 138` Copy List with Random Pointer
- `LC 237` Delete Node in a Linked List
- `LC 2487` Remove Nodes From Linked List
- `LC 2` Add Two Numbers
- `LC 86` Partition List
- `LC 143` Reorder List
- `LC 61` Rotate List
- `LC 19` Remove Nth Node From End of List
- `LC 116` Populating Next Right Pointers in Each Node
- `LC 705` Design HashSet
