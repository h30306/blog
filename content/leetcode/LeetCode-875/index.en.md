---
title: "LeetCode 875: Koko Eating Bananas"
summary: "LeetCode 875 note: binary search the speed for the smallest k with total hours <= h, continuing left even when the hours equal h"
description: "LeetCode 875 record from 2022-10-28"
date: 2022-10-28
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-28
- Submissions: Wrong Answer ×9 → Runtime Error → Wrong Answer ×3 → Accepted ×2 → Wrong Answer → Accepted ×3

## Approach

Faster speeds take fewer hours, which is monotonic, so binary search the answer ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 2). Find the **smallest** `k` with `sum(ceil(p / k)) <= h`:

- Hours `<= h`: `k` works, but something smaller might too, so `r = mid`.
- Hours `> h`: too slow, `l = mid + 1`.

The speed ranges over `[1, max(piles)]`.

## My Attempts

This took 19 submissions, all about the search direction and stopping condition:

- Returning as soon as the hours equaled `h`, although a smaller speed might also work: `[4]`, `h = 5` needs only speed 1; it returned 4.
- After a few changes the direction flipped: moving left on `times < h` and right otherwise (equality included), discarding a feasible answer: `[7]`, `h = 2` should be 4; it returned 7.

## Solution

```python
class Solution:
    def minEatingSpeed(self, piles: List[int], h: int) -> int:
        l, r = 1, max(piles)
        while l < r:
            mid = (l + r) // 2
            hours = sum((p + mid - 1) // mid for p in piles)
            if hours <= h:
                r = mid
            else:
                l = mid + 1
        return l
```

## Complexity

Time `O(n log M)` with `M` the largest pile, space `O(1)`.

## Mistakes to Avoid

- Hours equal to `h` does not make the speed minimal; keep searching left.
- Ceiling division in integers: `(p + k - 1) // k`.

## Interview Explanation

Speed and hours are monotonic, so I binary search the speed: within `h` hours search left for something smaller, otherwise go right, over `1` to the largest pile. Time `O(n log M)`.
