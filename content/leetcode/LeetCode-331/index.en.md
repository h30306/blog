---
title: "LeetCode 331: Verify Preorder Serialization of a Binary Tree"
summary: "LeetCode 331 note: count open slots: start with 1, every node fills one, a non-null node opens two more; never go negative and end at exactly 0"
description: "LeetCode 331 record from 2026-10-25"
date: 2026-10-25
tags: ["medium", "string", "stack", "tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-25
- Submissions: Accepted (first try)

## Approach

There is no need to build the tree; just count how many open positions remain:

- Start with 1 position, for the root.
- Every node read, including `#`, fills 1 position.
- A non-null node opens 2 more positions, for its children.

If the count goes negative **midway**, there are more nodes than positions; after reading everything the count must be **exactly 0**, or some position is left empty.

For `9,#,#,1`: after `9,#,#` the positions are used up, and reading `1` makes the count -1, so the answer is `False`.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def isValidSerialization(self, preorder: str) -> bool:
        slots = 1
        for node in preorder.split(","):
            slots -= 1
            if slots < 0:
                return False
            if node != "#":
                slots += 2
        return slots == 0
```

## Complexity

Time `O(n)`, space `O(n)` for the `split` result (scanning characters directly gives `O(1)`).

## Mistakes to Avoid

- Subtract first, check for negative, and add 2 last. Adding 2 first accepts `#,1,#`, although the tree already ends at the first `#`.
- Check for exactly 0 at the end, not just "never negative".
- Values can have several digits, so split on commas rather than treating each character as a node.

## Interview Explanation

I count open slots instead of building the tree. There is one slot for the root, every node fills one, and a non-null node opens two. If the count goes negative midway it is invalid, and it must end at exactly zero. Time `O(n)`. A stack version that keeps collapsing "number, #, #" into one `#` also works: valid if a single `#` remains.
