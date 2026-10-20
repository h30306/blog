---
title: "LeetCode 135: Candy"
summary: "LeetCode 135 note: one pass left to right for the left neighbor, one right to left for the right neighbor, and give each child the larger of the two"
description: "LeetCode 135 record from 2025-08-05"
date: 2025-08-05
tags: ["hard", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-08-05
- Submissions: Runtime Error ×3 → Accepted ×2 → Time Limit Exceeded → Accepted

## Approach

Each child's condition involves both neighbors, so handle each side separately ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 3):

- `left[i]`: left side only. Higher than the left neighbor means `left[i - 1] + 1`, otherwise 1.
- `right[i]`: right side only, computed right to left.
- Each child gets `max(left[i], right[i])`.

Both are necessary lower bounds: the increasing run on the left forces a minimum, and so does the run on the right, so the larger is the least possible.

## My Attempts

I started with divide and conquer: find the highest-rated child in a range, recurse on both halves, then give that child one more than any lower-rated neighbor.

| Version | Problem |
|---|---|
| First two REs | `ratings.index(max(ratings[left:right]))` searched the **whole array** for the maximum, possibly finding a position outside the range. `[2, 2]` gave 3 candies (answer 2) and `[4, 1, 2]` recursed forever |
| Third RE | Searched within the slice, but recursed right on `max_index < n - 1`; with the maximum at the range's right end it recursed into an empty range and `max()` failed on an empty sequence, e.g. `[0, 2, 4]` |
| Two ACs | Changed to `max_index < right - 1`, but took 6.5 s: on increasing ratings each level shrinks by one, `O(n²)` |
| TLE | Replaced the built-in `max` / `index` with a hand-written loop; still `O(n²)`, and the Python loop is slower |

## Solution

```python
class Solution:
    def candy(self, ratings: List[int]) -> int:
        n = len(ratings)
        left = [1] * n
        for i in range(1, n):
            if ratings[i] > ratings[i - 1]:
                left[i] = left[i - 1] + 1
        right = [1] * n
        for i in range(n - 2, -1, -1):
            if ratings[i] > ratings[i + 1]:
                right[i] = right[i + 1] + 1
        return sum(max(a, b) for a, b in zip(left, right))
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- When recursing on a subrange, search for positions within that subrange, not the whole array.
- Recursion bounds must use the subrange's right end, not the array's.
- Splitting at the maximum each level degrades to `O(n²)` on monotonic input.

## Interview Explanation

The condition involves both sides, so I make two passes: left to right, a child rated higher than the left neighbor gets one more than them; right to left, the same against the right neighbor. Each child takes the larger, since both are necessary lower bounds. Time `O(n)`.
