---
title: "LeetCode 652: Find Duplicate Subtrees"
summary: "LeetCode 652 note: encode every subtree in post-order and report it on its second occurrence; string keys are O(n^2) worst case, (val, left id, right id) ids make it O(n)"
description: "LeetCode 652 record from 2026-10-26"
date: 2026-10-26
tags: ["medium", "hash-table", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-26
- Submissions: Accepted ×2

## Approach

Two subtrees are identical exactly when their encodings are equal. Do a post-order DFS ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1): get the left and right encodings first, build this node's encoding, and count it in a hash map ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 5, normalize then use as a key). When an encoding appears for the **second** time, add the node to the answer; later occurrences are ignored so nothing is reported twice.

The encoding must identify the structure uniquely, so null children are included.

## My Attempts

Both submissions passed on the first try:

1. 10-26: the encoding was the string `f"{val},{left},{right}"` with `#` for null.
2. 10-27: mapped `(val, left id, right id)` to an integer id instead, so the strings do not keep growing.

## Solution

```python
class Solution:
    def findDuplicateSubtrees(self, root: Optional[TreeNode]) -> List[Optional[TreeNode]]:
        tree_id = {}
        count = defaultdict(int)
        res = []

        def post(node):
            if not node:
                return 0
            key = (node.val, post(node.left), post(node.right))
            if key not in tree_id:
                tree_id[key] = len(tree_id) + 1
            uid = tree_id[key]
            count[uid] += 1
            if count[uid] == 2:
                res.append(node)
            return uid

        post(root)
        return res
```

## Complexity

| Encoding | Time |
|---|---|
| String | worst `O(n^2)`: each node's string is as long as its subtree |
| `(val, left id, right id)` → id | `O(n)`: each key is a fixed-size tuple |

Space is `O(n)` for both.

## Mistakes to Avoid

- Add the node on `== 2`, not `>= 2`, or the same shape is reported many times.
- In-order collides even with null markers: `[0,0]` and `[0,null,0]` both give `#,0,#,0,#`. Use pre-order or post-order.

## Interview Explanation

I encode every subtree in a post-order DFS, including nulls, count encodings in a hash map, and add a node when its encoding appears the second time. String encodings are `O(n^2)` in the worst case, so I map `(value, left id, right id)` to an integer id; each node then does constant work and the total is `O(n)`.
