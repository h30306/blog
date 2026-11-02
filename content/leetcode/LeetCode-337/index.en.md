---
title: "LeetCode 337: House Robber III"
summary: "LeetCode 337 note: tree DP where each node returns the best (rob it, skip it) pair; not robbing alternate levels"
description: "LeetCode 337 record from 2022-11-16"
date: 2022-11-16
tags: ["medium", "dynamic-programming", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-16
- Submissions: Wrong Answer ×2 → Runtime Error ×2 → Accepted → Wrong Answer → Accepted ×2
- 2026-10-30 rewrite: Wrong Answer → Time Limit Exceeded → Accepted ×2

## Approach

Adjacent (parent-child) nodes cannot both be robbed. Each node returns two values ([Tree]({{< relref "/algorithm/Tree" >}}) Template 7):

- `rob`: rob it, so children are skipped: `val + left.skip + right.skip`.
- `skip`: skip it, so each child takes its better option: `max(left) + max(right)`.

The answer is the larger of the root's two values.

## My Attempts

Attempt 1 robbed either all odd or all even levels, but the best choice may skip two levels: for `[1, 2, 3, 8]`, robbing 8 and 3 gives 11, while the level approach got 9. Switching to recursion, one version returned nothing and one did invalid arithmetic on tuples (TypeError).

## Solution

```python
class Solution:
    def rob(self, root: Optional[TreeNode]) -> int:
        def dfs(node):
            if not node:
                return 0, 0                          # (搶它, 不搶它)
            lr, ls = dfs(node.left)
            rr, rs = dfs(node.right)
            return node.val + ls + rs, max(lr, ls) + max(rr, rs)
        return max(dfs(root))
```

## 2026-10 Rewrite

This time I started with a recursion carrying a state, then switched to returning two values as above:

1. `dfs(node, rob)`, where `rob` says whether the parent was robbed. I left nothing after the final `return`, so it returned `None`.
2. With `dfs(root, False)` filled in the answers were right but it got **TLE**: with no memoization both the rob and skip branches call the children again, so the same `(node, state)` is recomputed many times, growing exponentially with depth.
3. Adding `@cache` passed. `TreeNode` hashes by object identity by default, so it works as a key directly.
4. Then the version above: each node returns `[skip, rob]`, with `rob = val + left[0] + right[0]` and `skip = max(left) + max(right)`, in a single pass; also accepted.

Version 4 is version 3 without the cache, returning both states at once, so the extra space drops from an `O(n)` cache to the `O(h)` recursion depth.

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Summing odd and even levels is not enough: the best choice may skip two levels in a row.

## Interview Explanation

This is tree DP: each node returns its best totals when robbed and when skipped; robbing excludes the children, skipping lets each child choose its better option, and the root takes the larger. Time `O(n)`.
