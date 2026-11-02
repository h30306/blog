---
title: "LeetCode 968: Binary Tree Cameras"
summary: "LeetCode 968 note: post-order greedy with three states per node: has a camera, covered, not covered; place a camera only when a child is uncovered, and add one if the root is left uncovered"
description: "LeetCode 968 record from 2026-10-30"
date: 2026-10-30
tags: ["hard", "dynamic-programming", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-30
- Submissions: Wrong Answer ×3 → Accepted → Wrong Answer ×2 → Accepted

## Approach

Greedy intuition: **never put a camera on a leaf**. Putting it on the leaf's parent is better, since it covers the leaf, the parent and the grandparent. So decide bottom-up (post-order, [Tree]({{< relref "/algorithm/Tree" >}}) Template 7), with each node returning one of three states:

| State | Meaning |
|---|---|
| Camera | the node has a camera |
| Covered | no camera, but a child's camera covers it |
| Not covered | left for the parent to handle |

Rules, in this order:

1. If any child is **not covered**, this node must have a camera.
2. Otherwise, if any child **has a camera**, this node is covered.
3. Otherwise, this node is not covered and the parent must handle it.

A null child counts as "covered", so a leaf returns "not covered" and the camera goes to its parent. If the root ends up not covered, no parent can help, so add one camera.

## My Attempts

Five wrong answers:

1. Used only two states (`True` / `False`, needs cover or not). That merges "covered by a child's camera" with "not covered", and an uncovered root was never handled: `[0]` returned 0, the answer is 1. The second submission was nearly identical.
2. Added a special case "if the root is a leaf, add one": `[0,0,0,0,null,0,0,0]` returned 3, the answer is 2. Two states are not enough, and special cases cannot fix that.
3. Switching to three states passed.
4. In a later rewrite the rules were right but I forgot the extra camera for the root (`[0]` returned 0); then I wrote the root check as "covered" instead of "not covered". Fixing that passed.

## Solution

```python
class Solution:
    def minCameraCover(self, root: Optional[TreeNode]) -> int:
        CAMERA, COVERED, NOT_COVERED = 0, 1, 2
        self.count = 0

        def dfs(node):
            if not node:
                return COVERED
            left = dfs(node.left)
            right = dfs(node.right)
            if left == NOT_COVERED or right == NOT_COVERED:
                self.count += 1
                return CAMERA
            if left == CAMERA or right == CAMERA:
                return COVERED
            return NOT_COVERED

        if dfs(root) == NOT_COVERED:
            self.count += 1
        return self.count
```

My submissions returned a tuple of three booleans; a single state code says the same thing more readably.

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Two states are not enough; "covered without a camera" and "not covered" must be distinct.
- A null child must count as covered, or every leaf is forced to take a camera.
- Check rule 1 first: if one child is uncovered, the node needs a camera even if the other child has one.
- Add a camera if the root is left uncovered.

## Interview Explanation

I do a post-order greedy where each node returns one of three states: camera, covered, or not covered. Nulls count as covered, so leaves get no camera and defer to their parent. If any child is uncovered I place a camera; otherwise if any child has a camera the node is covered; otherwise it defers to its parent. If the root is uncovered at the end I add one camera. Time `O(n)`.
