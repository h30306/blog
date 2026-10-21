---
title: "Tree Traversal and Common Techniques"
summary: "DFS return values, BFS level order, BST bounds, climbing to the LCA, tree diameter, and leaf trimming"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["tree", "binary-tree", "dfs", "bfs", "bst"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

A tree is a connected graph with no cycles, so tree problems fall into two groups:

- **Binary tree problems**: you get a `TreeNode` with at most two children and use recursion or level-order traversal.
- **General tree problems**: you get `edges`. It is really an undirected graph, handled with BFS, DFS, or leaf trimming.

When you read a problem, ask three questions:

1. **What does each node need from its subtrees?** → DFS return value (post-order).
2. **Does the answer depend on the level?** → BFS level order.
3. **Is the input a list of `edges`?** → treat it as an undirected graph: add both directions and use `seen` or `parent` to avoid walking back.

## Template 1: DFS Return Value (Post-order)

The most common tree template. Get the left and right results first, then combine them:

```python
def dfs(node):
    if not node:
        return 0                      # base value for an empty node
    left = dfs(node.left)
    right = dfs(node.right)
    return node.val + left + right    # answer for this subtree
```

### Key Parameters:

- **Design the return value**: it can be a tuple such as `(depth, answer node)`. LC 865 returns `(depth, node)` and finishes in one DFS.
- **Global answer**: if the answer is not the root's return value, such as the best split among all subtree sums, update an outer variable or collect values in a list during the DFS.
- **Do not modify the input**: writing subtree sums back into `node.val` passes, but it destroys the input. Store them separately in an interview.

## Template 2: BFS Level Order

Use it when the answer depends on levels: level sums, the last level, completeness checks:

```python
from collections import deque

def bfs(root):
    q = deque([root])
    level = 0
    while q:
        level += 1
        for _ in range(len(q)):       # number of nodes on this level
            node = q.popleft()
            # process node
            if node.left:
                q.append(node.left)
            if node.right:
                q.append(node.right)
```

### Key Parameters:

- Compute `len(q)` **before** the inner loop so it covers exactly one level.
- **Do not push `None` into the queue** unless the problem needs it. LC 958 does: a tree is complete exactly when no node appears after the first `None`.
- Iterative BFS avoids recursion depth issues, unlike "one recursive call per level".

## Template 3: BST Bounds

A BST guarantees left subtree < root < right subtree. Many BST problems recurse with bounds in `O(n)`:

```python
def build(bound):                     # LC 1008: build a BST from preorder
    nonlocal i
    if i == len(preorder) or preorder[i] > bound:
        return None
    root = TreeNode(preorder[i])
    i += 1
    root.left = build(root.val)       # left subtree values must be < root.val
    root.right = build(bound)         # right subtree keeps the outer bound
    return root
```

Splitting the array into "smaller than root" and "larger than root" and recursing also passes, but it degrades to `O(n^2)` on sorted input.

## Template 4: Climbing to the Common Ancestor (LCA)

When you need the path between two nodes, move both up to a shared ancestor:

```python
# with parent pointers or a parent map
while a != b:
    if depth[a] > depth[b]:
        a = parent[a]
    else:
        b = parent[b]
```

- **Heap-numbered complete binary tree** (root 1, children `2v` and `2v+1`): the parent is `v // 2`, and the larger value is always at the same depth or deeper, so `x //= 2` on the larger one works (LC 2509).
- **LCA of many nodes**: move the whole set up one level at a time until one node is left (the BFS solution of LC 865).

## Template 5: Trees as Graphs, BFS Distances and Diameter

For problems that give `edges`, build an undirected adjacency list first:

```python
from collections import deque

def bfs(start):
    dist = [-1] * n
    dist[start] = 0
    q = deque([start])
    while q:
        u = q.popleft()
        for v in adj[u]:
            if dist[v] == -1:
                dist[v] = dist[u] + 1
                q.append(v)
    return u, dist                    # the last popped u is farthest from start
```

**Tree diameter**: BFS from any node to find the farthest node `a`, then BFS from `a` to find the farthest node `b`. `dist(a, b)` is the diameter.

Related facts: **for any node, at least one of the two diameter endpoints is a farthest node from it** (LC 3313). Joining two trees with one edge gives a minimum diameter of `max(d1, d2, ceil(d1/2) + ceil(d2/2) + 1)` (LC 3203).

## Template 6: Leaf Trimming (Topological Sort on a Tree)

Peel leaves (degree 1) layer by layer from the outside in, to find the center or delete unneeded branches:

```python
q = deque(i for i in range(n) if deg[i] == 1 and can_remove(i))
while q:
    u = q.popleft()
    removed[u] = True
    for v in adj[u]:
        if not removed[v]:
            deg[v] -= 1
            if deg[v] == 1 and can_remove(v):
                q.append(v)
```

LC 2603 first trims coin-free leaves, then trims exactly two more layers; the remaining edges form the path that must be walked. LC 310 Minimum Height Trees uses the same template.

## Template 7: Tree DP (Post-order Subtree Summaries)

When each node needs facts about its subtree, a post-order traversal returns a "summary" and each parent combines its children's summaries:

- **Largest BST subtree sum** (LC 1373): return `(sum, min, max, is_bst)`. A node is a BST root when the left subtree's **max** `<` its value `<` the right subtree's **min**; a non-BST child makes the parent's check fail.
- **Max product of three costs in a subtree** (LC 2973): only the three largest and two smallest values matter, so each subtree returns just those 5, merged by sorting and truncating.

## Template 8: Iterative traversals (pre-order, in-order, post-order)

All three recursive traversals can be simulated with a stack:

```python
# in-order: push while going left, record on pop, then turn right
stack, cur = [], root
while cur or stack:
    while cur:
        stack.append(cur)
        cur = cur.left
    cur = stack.pop()
    visit(cur)
    cur = cur.right

# post-order: push back with a flag on the first pop, record on the second
stack = [(root, False)]
while stack:
    node, done = stack.pop()
    if not node:
        continue
    if done:
        visit(node)
    else:
        stack += [(node, True), (node.right, False), (node.left, False)]   # left pushed last, handled first
```

- **Pre-order** (LC 144): record on pop, pushing right before left.
- **In-order** (LC 94): the first snippet; a BST's in-order is ascending, so the k-th smallest (LC 230), minimum difference (LC 530, 783), modes (LC 501) and flattening into a chain (LC 897) all work on the fly.
- **Post-order** (LC 145): the second snippet. N-ary post-order (LC 590) can run "root, children right to left" and reverse the result.

## Template 9: Building a tree from traversals

The pre-order (or post-order) decides **which node is the root**, and the in-order decides **which nodes go left and right**:

```python
pos = {v: i for i, v in enumerate(inorder)}
it = iter(preorder)                      # for post-order use reversed(postorder)
def build(lo, hi):                       # an in-order range
    if lo > hi:
        return None
    root = TreeNode(next(it))
    root.left = build(lo, pos[root.val] - 1)     # with post-order, build the right subtree first
    root.right = build(pos[root.val] + 1, hi)
    return root
```

- **Pre-order + in-order** (LC 105), **in-order + post-order** (LC 106).
- **Sorted array / sorted list to a balanced BST** (LC 108, 109): the middle element is the root.

## Complexity

- DFS, BFS, and leaf trimming are all `O(n)`: each node and edge is handled a constant number of times.
- Recursion depth equals the tree height. Python's default limit is about 1000, so a chain-shaped tree with `n >= 10^4` needs care: switch to iteration or raise the limit with `sys.setrecursionlimit`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Pushing `None` children into the next level**: it creates a fake last level with sum 0 (LC 1161).
- **Treating a global property as local**: complete left and right subtrees do not make the whole tree complete (LC 958).
- **Adding only one direction for `edges`**: tree edges are almost always undirected (LC 1377).
- **Adding the wrong thing to `seen`**: `seen.add(second)` instead of `seen.add(vertex)`.
- **Copy-pasting code for two trees**: the second tree's `seen` still used the first tree's size `n`, which overflows when `m > n` (LC 3203).
- **Renaming a function but not its recursive call**: `dfs` still called `bfs`.
- **Time is up but the node could still move**: probability problems must separate "stopped at the target" from "passing through the target" (LC 1377).

- **Looking only at the root or only at parent-child pairs**: a diameter through the root only (LC 543), balance checked only at the root (LC 110), a BST compared only with children (LC 98), a subtree matched only two levels deep (LC 572).
- **Unhandled empty trees**: most Runtime Errors read `root.left` while `root` was `None`.
- **Treating the empty side as a leaf when only one child exists**: the minimum depth became 1 (LC 111).
- **Comparing a node with an integer or a boolean**: `root == targetSum` (LC 112), `node.val == self.isUnivalTree(...)` (LC 965).
- **Swapping children in two lines**: the second line used the already-replaced left subtree (LC 226).
- **Pruning early even though values can be negative** (LC 113).
- **Collecting left-to-right leaves with BFS**: BFS goes level by level, not left to right (LC 872).

## Related LeetCode

- `LC 958` Check Completeness of a Binary Tree
- `LC 1008` Construct Binary Search Tree from Preorder Traversal
- `LC 1161` Maximum Level Sum of a Binary Tree
- `LC 865` Smallest Subtree with all the Deepest Nodes
- `LC 1339` Maximum Product of Splitted Binary Tree
- `LC 2196` Create Binary Tree From Descriptions
- `LC 2236` Root Equals Sum of Children
- `LC 987` Vertical Order Traversal of a Binary Tree
- `LC 1028` Recover a Tree From Preorder Traversal
- `LC 2509` Cycle Length Queries in a Tree
- `LC 3820` Pythagorean Distance Nodes in a Tree
- `LC 1377` Frog Position After T Seconds
- `LC 2421` Number of Good Paths
- `LC 2603` Collect Coins in a Tree
- `LC 3313` Find the Last Marked Nodes in Tree
- `LC 3203` Find Minimum Diameter After Merging Two Trees
- `LC 1373` Maximum Sum BST in Binary Tree
- `LC 2973` Find Number of Coins to Place in Tree Nodes
- `LC 94` Binary Tree Inorder Traversal
- `LC 144` Binary Tree Preorder Traversal
- `LC 145` Binary Tree Postorder Traversal
- `LC 102` Binary Tree Level Order Traversal
- `LC 107` Binary Tree Level Order Traversal II
- `LC 103` Binary Tree Zigzag Level Order Traversal
- `LC 199` Binary Tree Right Side View
- `LC 637` Average of Levels in Binary Tree
- `LC 104` Maximum Depth of Binary Tree
- `LC 111` Minimum Depth of Binary Tree
- `LC 559` Maximum Depth of N-ary Tree
- `LC 589` N-ary Tree Preorder Traversal
- `LC 590` N-ary Tree Postorder Traversal
- `LC 226` Invert Binary Tree
- `LC 100` Same Tree
- `LC 101` Symmetric Tree
- `LC 572` Subtree of Another Tree
- `LC 110` Balanced Binary Tree
- `LC 112` Path Sum
- `LC 113` Path Sum II
- `LC 129` Sum Root to Leaf Numbers
- `LC 257` Binary Tree Paths
- `LC 404` Sum of Left Leaves
- `LC 1022` Sum of Root To Leaf Binary Numbers
- `LC 988` Smallest String Starting From Leaf
- `LC 543` Diameter of Binary Tree
- `LC 563` Binary Tree Tilt
- `LC 965` Univalued Binary Tree
- `LC 671` Second Minimum Node In a Binary Tree
- `LC 872` Leaf-Similar Trees
- `LC 993` Cousins in Binary Tree
- `LC 1448` Count Good Nodes in Binary Tree
- `LC 337` House Robber III
- `LC 2331` Evaluate Boolean Binary Tree
- `LC 222` Count Complete Tree Nodes
- `LC 1379` Find a Corresponding Node of a Binary Tree in a Clone of That Tree
- `LC 98` Validate Binary Search Tree
- `LC 108` Convert Sorted Array to Binary Search Tree
- `LC 230` Kth Smallest Element in a BST
- `LC 235` Lowest Common Ancestor of a Binary Search Tree
- `LC 236` Lowest Common Ancestor of a Binary Tree
- `LC 530` Minimum Absolute Difference in BST
- `LC 783` Minimum Distance Between BST Nodes
- `LC 938` Range Sum of BST
- `LC 501` Find Mode in Binary Search Tree
- `LC 653` Two Sum IV - Input is a BST
- `LC 700` Search in a Binary Search Tree
- `LC 703` Kth Largest Element in a Stream
- `LC 897` Increasing Order Search Tree
- `LC 105` Construct Binary Tree from Preorder and Inorder Traversal
- `LC 106` Construct Binary Tree from Inorder and Postorder Traversal
- `LC 606` Construct String from Binary Tree
- `LC 116` Populating Next Right Pointers in Each Node
- `LC 109` Convert Sorted List to Binary Search Tree
