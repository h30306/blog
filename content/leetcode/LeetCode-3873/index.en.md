---
title: "LeetCode 3873: Maximum Points Activated with One Addition"
summary: "LeetCode 3873 note: merge points sharing an x or y into components; a new point joins at most two of them, so the answer is the two largest plus 1"
description: "LeetCode 3873 record from 2026-07-29"
date: 2026-07-29
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
First Attempt: 2026-07-29
- Submissions: Time Limit Exceeded → Wrong Answer → Accepted ×2

## Approach

Activation spreads along "same x or same y" until it stops, so activating one point activates its whole component. Group the points with Union-Find first.

A new point `(x, y)` joins one component through its x and one through its y, **at most two**. Pick the two largest, A and B: take x from some point in A and y from some point in B. That coordinate must be empty, because a point there would connect to both A and B, making them one component. With one component, the answer is its size plus 1.

Do not compare all pairs; keep the first point seen for each x (and each y) in a dictionary and merge later points into it ([Union-Find]({{< relref "/algorithm/Union-Find" >}}), merge through the first representative).

## My Attempts

1. **Attempt 1** compared every pair, `O(n²)`, TLE.
2. **Attempt 2** gathered points by x and by y into sets, but merged with `union(i - 1, i)`, **using loop indices instead of the points in the set**. For `[[0, 0], [1, 2], [3, 3], [3, 0]]`, `(0, 0)`, `(3, 0)`, `(3, 3)` form one component and `(1, 2)` another, so the answer is 5; it returned 4.
3. Merging the set's elements passed; switching to a first-seen dictionary was faster.

## Solution

```python
class Solution:
    def maxActivated(self, points: List[List[int]]) -> int:
        n = len(points)
        parent = list(range(n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        first_x, first_y = {}, {}
        for i, (x, y) in enumerate(points):
            for first, key in ((first_x, x), (first_y, y)):
                if key in first:
                    parent[find(i)] = find(first[key])
                else:
                    first[key] = i
        sizes = sorted(Counter(find(i) for i in range(n)).values(), reverse=True)
        return sum(sizes[:2]) + 1
```

## Complexity

Time `O(n · α(n) + n log n)`, space `O(n)`.

## Mistakes to Avoid

- Do not compare all pairs; use a dictionary of representatives.
- Merge the elements in the set, not loop indices.

## Interview Explanation

Activation spreads through a whole component, so I merge points sharing an x or a y with Union-Find, using a dictionary of the first point per coordinate. A new point reaches at most one component through x and one through y, and combining x and y from two different components always gives an empty spot, so the answer is the two largest components plus 1. Time `O(n log n)`.
