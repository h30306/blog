---
title: "Stack and Monotonic Stack"
summary: "Parsing nested structures, simulations that interact with the previous element, monotonic stacks, greedy deletion for the smallest string, and a lazy-deletion Max Stack"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["stack", "monotonic-stack", "greedy", "simulation"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

A stack is last-in, first-out (LIFO): the most recently pushed element comes out first.

Signals:

- **Nested structures**: parentheses, `k[...]`, chemical formulas `(...)n`. Save the current state when a group opens and combine it back when the group closes.
- **A new element interacts with the previous surviving element**: merging, cancelling, colliding.
- **The first larger or smaller element to the left or right**: a monotonic stack.
- **Deleting characters to make a string lexicographically smallest**: a monotonic stack plus greed.

## Template 1: Parsing Nested Structures

On `[` or `(`, push the result accumulated so far and start a new level; on `]` or `)`, finish this level and attach it back to the previous one.

```python
stack = []
cur, num = "", 0
for ch in s:
    if ch.isdigit():
        num = num * 10 + int(ch)          # numbers can have several digits
    elif ch == "[":
        stack.append((cur, num))           # save the outer level's state
        cur, num = "", 0
    elif ch == "]":
        prev, k = stack.pop()
        cur = prev + cur * k               # finish this level, attach to the outer one
    else:
        cur += ch
```

LC 394 Decode String is exactly this template. LC 726 Number of Atoms is the same idea, with each level holding element counts.

### Key Parameters:

- **Numbers can have several digits**: never assume a single digit (LC 394, 726).
- **A closing parenthesis may have no number**: the multiplier is then 1 (LC 726).

## Template 2: Simulations That Interact with the Previous Element

A new element interacts only with the top of the stack, and may need to keep interacting with the new top afterwards:

```python
stack = []
for x in items:
    while stack and interacts(stack[-1], x):
        x = interaction_result(stack.pop(), x)   # merge, cancel, or decide who survives
        if x is None:
            break
    if x is not None:
        stack.append(x)
```

- LC 3834: equal neighbors merge into double, which may then equal the previous element.
- LC 2751: right-moving robots wait on the stack; a left-moving robot collides with them until one side is gone.
- LC 3703: the stack holds `(character, run length)`, and `k` `(` followed by `k` `)` disappear as a block.

## Template 3: Monotonic Stack

Keep the stack monotonic: before pushing a new element, pop everything that breaks the order:

```python
stack = []
for i in range(n - 1, -1, -1):             # right to left
    while stack and stack[-1] < nums[i]:
        stack.pop()                        # hidden behind nums[i] for everyone further left
    # now stack[-1] is the first element to the right of nums[i] that is larger
    stack.append(nums[i])
```

- LC 1944: everyone popped is visible; after popping, the taller person left on top is visible too.
- LC 4045: going right to left, the stack holds fleet speeds. A group faster than the fleet ahead eventually catches up and joins it; a group that is slower or equally fast forms its own fleet.

## Template 4: Deleting Characters for the Smallest String

Scan left to right; when the new character is smaller than the top and the top **can be restored later or is allowed to be deleted**, pop the top:

```python
for ch in s:
    while stack and stack[-1] > ch and can_delete(stack[-1]):
        delete(stack.pop())
    stack.append(ch)
```

"Can delete" depends on the problem:

| Problem | Requirement | Deletable when |
|---|---|---|
| LC 316 | keep **exactly one** of each letter | the letter appears again later; letters already on the stack are skipped |
| LC 3816 | keep **at least one** of each letter | the current string still has more than one of it; trailing duplicates are also removed at the end |

I once reused the 3816 approach on 316 and got a WA: 316 forbids keeping two copies of a letter, so a `seen` set must skip duplicates.

## Template 5: Max Stack with Lazy Deletion

`popMax` removes an element from the middle, which neither a stack nor a heap supports. Use the same lazy deletion as with heaps:

- Give each element a **unique id** and put it on both the stack and the heap.
- On deletion, only add the id to a `deleted` set.
- In `top` and `peekMax`, first pop any deleted elements off the top.

**Use ids, not values**: the same value can appear many times, and tracking values alone cannot tell which copy was deleted (LC 716).

### Extension: calculators and paths

- **Precedence of * and /** (LC 227): remember the previous operator and apply it at the next one: + and - push (negated for -), * and / combine with the top, and sum at the end.
- **Paths** (LC 71): after `split("/")`, skip empty pieces and `.`, pop on `..`, push the rest.
- **A single bracket type** (LC 1021): the stack only holds `(`, so a depth counter suffices.

## Complexity

- Each element is pushed and popped at most once, so Templates 1 to 4 are `O(n)`.
- Each Max Stack operation is amortized `O(log n)`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Assuming single-digit numbers** (LC 394).
- **Not defaulting the multiplier to 1 when no number follows a parenthesis** (LC 726).
- **Using an "at least one" solution on an "exactly one" problem** (LC 316).
- **Lazy deletion by value instead of id**: duplicates get deleted wrongly (LC 716).
- **Comparing only adjacent speeds**: fleet problems compare against the speed of the whole fleet ahead (LC 4045).
- **Deleting with repeated string `replace`**: each pass rescans the string, `O(n^2)` (LC 3703 took 5 seconds).
- **Popping an empty stack**: when `#` or `..` comes first (LC 844, 71).
- **Not skipping empty pieces and `.` from `split("/")`** (LC 71).
- **Treating each character as a token**: read multi-digit numbers fully (LC 227).
- **Dividing with `//`**: the problem truncates toward zero, which differs for negatives; use `int(a / b)` (LC 227).
- **Leftover deletions after the scan**: delete from the end (LC 402).
- **Comparing with the farthest asteroid instead of the nearest**: use the stack top (LC 735).
- **Two-pointer loops that never advance**: infinite loops (LC 844).

## Related LeetCode

- `LC 394` Decode String
- `LC 726` Number of Atoms
- `LC 3834` Merge Adjacent Equal Elements
- `LC 3703` Remove K-Balanced Substrings
- `LC 2751` Robot Collisions
- `LC 1944` Number of Visible People in a Queue
- `LC 4045` Count Robot Groups
- `LC 316` Remove Duplicate Letters
- `LC 3816` Lexicographically Smallest String After Deleting Duplicate Characters
- `LC 716` Max Stack
- `LC 2355` Maximum Number of Books You Can Take
- `LC 1021` Remove Outermost Parentheses
- `LC 1047` Remove All Adjacent Duplicates In String
- `LC 844` Backspace String Compare
- `LC 682` Baseball Game
- `LC 735` Asteroid Collision
- `LC 71` Simplify Path
- `LC 227` Basic Calculator II
- `LC 402` Remove K Digits
