---
title: "LeetCode 1028: Recover a Tree From Preorder Traversal"
summary: "LeetCode 1028 note: a stack holds the path from the root to the current node, so its length is the depth"
description: "LeetCode 1028 record from 2026-09-12"
date: 2026-09-12
tags: ["hard", "tree", "binary-tree", "dfs", "stack", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-12
- Submissions: Accepted (recursion) → Accepted (stack) → Accepted (recursion, rewritten)

## Approach

The string is "`D` dashes + a number", where `D` is the node depth, in preorder.

For each `(depth, value)` you read, decide which node it hangs under: **its parent is the node of depth `D - 1` on the current path.**

## Solution 1: a stack holding the current path

Keep the path from the root to the current node in a stack. Then the stack length is the depth the next node should have:

1. Read the depth `depth` and the value.
2. Pop until the stack length equals `depth`; the top is now the parent.
3. Attach to the left if the parent has no left child, otherwise to the right (a single child is guaranteed to be the left one).
4. Push the new node.

```python
class Solution:
    def recoverFromPreorder(self, traversal: str) -> Optional[TreeNode]:
        stack = []
        i, n = 0, len(traversal)
        while i < n:
            depth = 0
            while i < n and traversal[i] == "-":
                depth += 1
                i += 1

            val = 0
            while i < n and traversal[i].isdigit():
                val = val * 10 + int(traversal[i])
                i += 1

            node = TreeNode(val)
            while len(stack) > depth:
                stack.pop()
            if stack:
                if stack[-1].left:
                    stack[-1].right = node
                else:
                    stack[-1].left = node
            stack.append(node)

        return stack[0]
```

## Solution 2: recursion with an expected depth

`dfs(d)` peeks at the next run of dashes. If it is not `d`, the next node does not belong here, so it returns `None` **without consuming anything**. Otherwise it reads the value, builds the node, and recurses for the left and right subtrees.

```python
class Solution:
    def recoverFromPreorder(self, traversal: str) -> Optional[TreeNode]:
        self.i = 0
        n = len(traversal)

        def dfs(expected_depth: int) -> Optional[TreeNode]:
            j, dashes = self.i, 0
            while j < n and traversal[j] == "-":
                j += 1
                dashes += 1
            if dashes != expected_depth:
                return None                      # peek only; self.i is unchanged

            self.i = j
            val = 0
            while self.i < n and traversal[self.i].isdigit():
                val = val * 10 + int(traversal[self.i])
                self.i += 1

            node = TreeNode(val)
            node.left = dfs(expected_depth + 1)
            node.right = dfs(expected_depth + 1)
            return node

        return dfs(0)
```

The key is **peeking with a temporary `j`** and updating `self.i` only when the depth matches.

## Complexity

Both solutions run in `O(len(traversal))` time and `O(h)` space.

## Mistakes to Avoid

- Reading a single digit: values go up to `10^9`, so read until a non-digit.
- In the recursive version, moving the pointer before the depth check, which swallows characters.
- Popping too far in the stack version: pop until the length **equals** the depth.

## Interview Explanation

The string is preorder and the dash count is the depth. I keep the root-to-current path in a stack, so its length is the next node's depth: for each node, I pop until the stack length equals its depth, the top is the parent, and the node goes left if the parent has no left child, otherwise right. Then I push it. Each character is read once, so time is linear in the string length.
