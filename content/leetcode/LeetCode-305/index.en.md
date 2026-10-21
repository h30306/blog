---
title: "LeetCode 305: Number of Islands II"
summary: "LeetCode 305 note: each new land cell adds an island, then merges with neighboring land, subtracting 1 per successful merge; skip repeated positions"
description: "LeetCode 305 record from 2026-10-15"
date: 2026-10-15
tags: ["hard", "union-find", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-15
- Submissions: Wrong Answer ×6 → Accepted → Wrong Answer → Accepted → Wrong Answer → Accepted ×2 → Wrong Answer → Accepted

## Approach

For each new land cell ([Union-Find]({{< relref "/algorithm/Union-Find" >}}), counting components):

1. Add 1 island (the cell starts as its own island).
2. Check the four neighbors; merge with any that are land, subtracting 1 **only when two different islands actually merge**.
3. A repeated cell changes nothing, but its answer is still recorded.

Counting how many neighbors are land is not enough, because those neighbors may already be one island, so Union-Find has to decide.

## My Attempts

| Version | Problem |
|---|---|
| First three | No Union-Find, just counting land neighbors. Attempt 1 left the count unchanged when touching land: on `1 × 3`, adding `(0, 2)`, `(0, 0)`, `(0, 1)` joins two islands at the end, answer 1, it returned 2; attempt 2 subtracted the neighbor count and returned 0; attempt 3 subtracted neighbors - 1, but on `2 × 2` the last cell's two neighbors were already one island, answer 1, it returned 0 |
| Attempts 4 and 5 | Union-Find, but repeated positions were not handled: adding a cell twice counted an extra island; attempt 5 skipped it but forgot to record an answer, so the result was too short |
| Attempt 6 | Recorded the answer but had no `continue`, so the cell was still counted again |
| AC | On a repeat, record the answer and `continue` |
| Later versions | Practicing `find` variants: one accidentally used the outer loop variable `x` inside `find`; one did a single `parent[a] = parent[parent[a]]` with no loop, returning a non-root past depth 2; one wrote path halving with `if` instead of `while`, and the island count even went negative |

## Solution

```python
class Solution:
    def numIslands2(self, m: int, n: int, positions: List[List[int]]) -> List[int]:
        parent = list(range(m * n))
        land = set()

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]      # path halving needs while
                x = parent[x]
            return x

        res, count = [], 0
        for r, c in positions:
            if (r, c) not in land:
                land.add((r, c))
                count += 1
                for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                    if (nr, nc) in land:
                        a, b = find(r * n + c), find(nr * n + nc)
                        if a != b:
                            parent[a] = b
                            count -= 1
            res.append(count)
        return res
```

`(nr, nc) in land` already implies the cell is in range, since only valid cells are ever added to `land`.

## Complexity

Time `O(m · n + k · α(m · n))` for `k` operations, space `O(m · n)`.

## Mistakes to Avoid

- A land neighbor is not necessarily a different island; check with `find`.
- Skip repeated positions, but still record the answer.
- Path halving must loop with `while` until the root.

## Interview Explanation

I maintain islands with Union-Find. Each new cell starts as a new island, then merges with neighboring land, and only an actual merge of two different roots subtracts 1. A repeated cell just records the current count. Each operation is nearly `O(1)`.
