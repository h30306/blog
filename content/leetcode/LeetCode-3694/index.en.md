---
title: "LeetCode 3694: Distinct Points Reachable After Substring Removal"
summary: "LeetCode 3694 note: the endpoint is the total displacement minus the removed segment's displacement; a length-k window tracks that segment and each endpoint goes into a set"
description: "LeetCode 3694 record from 2025-12-27"
date: 2025-12-27
tags: ["medium", "sliding-window", "prefix-sum", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-12-27
- Submissions: Wrong Answer → Accepted ×2

## Approach

Moves add up as vectors, so order does not affect the endpoint. After removing a length-`k` substring:

```text
endpoint = displacement of the whole string − displacement of the removed segment
```

Compute the total displacement, then maintain "displacement inside the window" with a fixed window of length `k`. Each window gives one endpoint for a `set`, and the answer is the set's size.

## My Attempts

Attempt 1 recorded endpoints inside `if i - k >= 0`, i.e. only after the window was full **and had already dropped an element**, which skipped the first window (removing `s[0..k-1]`). For `s = "UL"`, `k = 1`: removing `U` leaves `L` at `(-1, 0)` and removing `L` leaves `U` at `(0, 1)`, so the answer is 2; it only recorded the second and returned 1.

Separating "drop an element" from "record the endpoint", with the recording condition `i - k + 1 >= 0`, passed.

## Solution

```python
class Solution:
    def distinctPoints(self, s: str, k: int) -> int:
        move = {"U": (0, 1), "D": (0, -1), "L": (-1, 0), "R": (1, 0)}
        total_x = sum(move[c][0] for c in s)
        total_y = sum(move[c][1] for c in s)

        wx = wy = 0                                # displacement inside the window
        points = set()
        for i, c in enumerate(s):
            wx += move[c][0]
            wy += move[c][1]
            if i >= k:
                out = s[i - k]
                wx -= move[out][0]
                wy -= move[out][1]
            if i >= k - 1:                         # the first window ends at i == k - 1
                points.add((total_x - wx, total_y - wy))
        return len(points)
```

With `k == n` there is a single window ending at `(0, 0)`, with no special case needed.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Skipping the first window: record when `i >= k - 1` and drop when `i >= k`; keep the two conditions separate.

## Interview Explanation

Moves are vector additions, so the endpoint after removing a segment is the total displacement minus that segment's. I compute the total, then a length-`k` sliding window tracks the window's displacement and each window adds one endpoint to a `set`. The first window must be recorded at `i == k - 1`. Time `O(n)`.
