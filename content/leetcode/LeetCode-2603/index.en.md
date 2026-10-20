---
title: "LeetCode 2603: Collect Coins in a Tree"
summary: "LeetCode 2603 note: trim coin-free leaves, trim exactly two more layers, and walk each remaining edge twice"
description: "LeetCode 2603 record from 2026-06-26"
date: 2026-06-26
tags: ["hard", "tree", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-06-26
- Submissions: Wrong Answer ×2 → Accepted → Wrong Answer (resubmitted an old version) → Accepted

## Approach

You may start anywhere, collect every coin within distance 2 of your current node, and must return to the start.

The key fact: **the walk covers a subtree, and covering a subtree and returning uses every edge exactly twice.** So the answer is "number of required edges × 2".

Two rounds of leaf trimming find the required edges:

1. **Trim coin-free leaves**, in a chain: if removing one makes its neighbor a coin-free leaf, trim that too. Afterwards, every remaining leaf has a coin.
2. **Trim exactly two more layers of leaves**: standing two steps from a leaf collects its coin, so the outer two layers never need to be walked.

The remaining edge count times 2 is the answer.

## My Attempts

### Attempt 1: a `continue` disables the chain trimming

```python
while leaves:
    leaf = leaves.popleft()
    coins[leaf] = -1
    if coins[leaf]:          # just set to -1, always True
        continue
    ...
```

`coins[leaf]` is set to `-1` and then checked on the next line. `-1` is truthy, so every leaf hits `continue`, **neighbor degrees are never decremented**, and only the first layer is trimmed.

A debugging `print(neighbor, degree)` was also left in.

### Attempt 2: trimming neighbors that have coins

After removing the `continue`:

```python
if degree[neighbor] == 1:
    leaves.append(neighbor)      # no check for a coin
```

When a neighbor becomes a leaf, it is queued and trimmed whether or not it has a coin, **so nodes with coins get deleted**. The condition should be `degree[neighbor] == 1 and coins[neighbor] == 0`.

I later resubmitted the old version by accident, which explains the extra WA.

## Solution

```python
from collections import deque

class Solution:
    def collectTheCoins(self, coins: List[int], edges: List[List[int]]) -> int:
        n = len(coins)
        degree = [0] * n
        adj = [[] for _ in range(n)]
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)
            degree[u] += 1
            degree[v] += 1

        # Phase 1: trim coin-free leaves in a chain
        leaves = deque(i for i in range(n) if degree[i] == 1 and coins[i] == 0)
        while leaves:
            leaf = leaves.popleft()
            coins[leaf] = -1                     # mark as removed
            for nei in adj[leaf]:
                degree[nei] -= 1
                if degree[nei] == 1 and coins[nei] == 0:
                    leaves.append(nei)

        # Phase 2: trim exactly two layers of the remaining tree
        degree = [0] * n
        adj = [[] for _ in range(n)]
        for u, v in edges:
            if coins[u] == -1 or coins[v] == -1:
                continue
            adj[u].append(v)
            adj[v].append(u)
            degree[u] += 1
            degree[v] += 1

        leaves = deque(i for i in range(n) if degree[i] == 1)
        while leaves:
            leaf = leaves.popleft()
            coins[leaf] = -1                     # first layer
            for nei in adj[leaf]:
                degree[nei] -= 1
                if degree[nei] == 1:
                    coins[nei] = -1              # new leaf = second layer; stop here

        # Phase 3: count the remaining edges
        remaining = sum(1 for u, v in edges if coins[u] != -1 and coins[v] != -1)
        return remaining * 2
```

Phase 2 never pushes the second layer back into the queue, so it trims exactly two layers.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Checking a value right after overwriting it, which disables the whole branch.
- Forgetting to check the neighbor's coin during chain trimming.
- Continuing past the second layer: only two layers may be trimmed.
- Not making sure the editor holds the latest version before submitting.

## Interview Explanation

Collecting all coins and returning covers a subtree with every edge used twice, so the answer is twice the number of required edges. I first trim coin-free leaves in a chain, like a topological sort, so every remaining leaf has a coin. Since coins within distance 2 can be collected, I then trim exactly two more layers of leaves. The remaining edge count times 2 is the answer, in `O(n)` time.
