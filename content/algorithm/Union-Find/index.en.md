---
title: "Union Find"
summary: "Introduction to Union Find"
description: "Algorithm Learning"
date: 2025-04-28
tags: ["algorithm"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Union-Find (also known as Disjoint Set Union, DSU) is a data structure used to efficiently track a collection of disjoint (non-overlapping) sets.  
It supports two main operations:
- **Find**: Determine which set a particular element belongs to.
- **Union**: Merge two sets together.

To optimize performance, we often use **Path Compression** and **Union by Rank** (or **Union by Size**) to reduce the time complexity of these operations nearly to constant time.

### When to Use Union-Find vs. DFS/BFS

- Use **Union-Find** when:
  - You need to **dynamically merge** groups or track **connectivity**.
  - You need to answer **whether two nodes are in the same component**.
  - Problems ask you to **process edges one by one**, such as in Kruskal’s algorithm for MST.
  - You're dealing with **offline** processing (batch queries on connectivity).

- Use **DFS/BFS** when:
  - You need to **explore all reachable nodes** from a starting point.
  - You need to **process a graph with full traversal** (e.g., component labeling, traversal order).
  - You need to **handle weighted graphs**, shortest paths, or directions (where Union-Find doesn't help).

> In short:
> - If the problem involves **dynamic merging or querying group membership**, choose **Union-Find**.
> - If the problem is about **exploring structure or traversal**, go with **DFS/BFS**.

---

✅ A good rule of thumb:  
If you're repeatedly asking “are these two things connected?” or “can I merge them?”, think Union-Find.  
If you're exploring “what can I reach from here?”, think DFS/BFS.

## Core Idea

The core idea of the Union-Find algorithm is:

1. Use the `union(x, y)` operation to merge two disjoint sets into a single set.
2. Use the `find(x)` operation to locate the representative (root) of the set that contains `x`.
3. To check whether two elements belong to the same set, compare their roots using `find`.

With **Path Compression** and **Union by Rank** (or **Union by Size**),  
the time complexity for both `find` and `union` operations becomes:

```
O(α(n))
```

Where **α(n)** is the [Inverse Ackermann Function](https://en.wikipedia.org/wiki/Ackermann_function#Inverse),  
which grows extremely slowly and is effectively **constant** for all practical input sizes (α(n) ≤ 4 for n ≤ 2^65536).  

Thus, Union-Find with optimizations is considered **almost O(1)** per operation in real-world usage.

> ✅ Without optimization, the worst-case time for `find` can be O(n),  
> but with optimization, it becomes nearly constant.

### Example

Given 10 individuals: `a, b, c, d, e, f, g, h, i, j`  
With the following relations:

```
a - b  
b - d  
c - e  
c - f  
g - h  
h - i
```

After applying the union operations, we end up with the following disjoint sets:

```
{a, b, d}  
{c, e, f}  
{g, h, i}  
{j}
```

## Basic Implementation (Without Optimization)

### Step 1: Initialize Parent Array

We start by assigning each element as its own parent.  
This array will be used to trace the set each element belongs to.

```python
class UnionFind:
    def __init__(self, size: int):
        self.parent: list[int] = list(range(size))
```

### Step 2: Implement `find`

The `find(i)` function returns the root (representative) of the element `i`.  
We recursively call `find(parent[i])` until we reach the root.

```python
def find(self, i: int) -> int:
    if self.parent[i] == i:
        return i
    return self.find(self.parent[i])
```

### Step 3: Implement `union`

The `union(i, j)` function merges the sets that contain `i` and `j`, if they are different.

```python
def union(self, i: int, j: int):
    root_i = self.find(i)
    root_j = self.find(j)

    if root_i == root_j:
        return  # already in the same set

    self.parent[root_i] = root_j
```

### Full Basic Implementation (No Optimization)

```python
class UnionFind:
    def __init__(self, size: int):
        self.parent = list(range(size))

    def find(self, i: int) -> int:
        if self.parent[i] == i:
            return i
        return self.find(self.parent[i])

    def union(self, i: int, j: int):
        root_i = self.find(i)
        root_j = self.find(j)

        if root_i == root_j:
            return

        self.parent[root_i] = root_j
```

In the worst-case scenario, this structure can degrade into a linked list (e.g., `D → C → B → A`),  
resulting in **O(n)** time complexity for a single `find`.

---

## Path Compression

**Path Compression** optimizes the `find()` operation by flattening the structure of the tree.  
Each node visited during `find(x)` will directly point to the root.  
This effectively reduces the depth of the tree and accelerates future queries.

```python
def find(self, i: int) -> int:
    if self.parent[i] != i:
        self.parent[i] = self.find(self.parent[i])
    return self.parent[i]
```

> Now `find()` operates in nearly O(1) amortized time.

---

## Union by Rank

**Union by Rank** keeps track of the tree "depth" using a `rank` array.  
When performing a union, always attach the tree with lower rank under the higher one.

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        if self.rank[root_x] < self.rank[root_y]:
            self.parent[root_x] = root_y
        elif self.rank[root_x] > self.rank[root_y]:
            self.parent[root_y] = root_x
        else:
            self.parent[root_y] = root_x
            self.rank[root_x] += 1
```

> 📌 `rank` is not the real tree height after path compression, but it works well as a heuristic.

---

## Union by Size

**Union by Size** is another optimization strategy.  
Instead of comparing depth (rank), we compare the number of elements in the tree.

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.size = [1] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        if self.size[root_x] < self.size[root_y]:
            self.parent[root_x] = root_y
            self.size[root_y] += self.size[root_x]
        else:
            self.parent[root_y] = root_x
            self.size[root_x] += self.size[root_y]
```

> Compared to rank, size gives a more accurate estimate of subtree weight, which may work better in some scenarios.


## Template

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [1] * n  # can represent size or rank depending on strategy

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # path compression
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        # Union by size
        if self.rank[root_x] < self.rank[root_y]:
            self.parent[root_x] = root_y
            self.rank[root_y] += self.rank[root_x]
        else:
            self.parent[root_y] = root_x
            self.rank[root_x] += self.rank[root_y]
```

---

## Explanation of the Key Parameters:

- `parent[i]`: Represents the parent node of node `i`. Initially, each node is its own parent.
- `find(x)`: Returns the root of node `x`, and compresses the path so future queries are faster.
- `union(x, y)`: Merges the sets that contain `x` and `y`, using either size or rank to balance the tree.
- `rank[i]`: Represents either the height (rank) or size of the tree rooted at `i`, used to optimize merging.

---

## Examples

### LeetCode