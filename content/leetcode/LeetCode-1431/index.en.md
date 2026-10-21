---
title: "LeetCode 1431: Kids With the Greatest Number of Candies"
summary: "LeetCode 1431 note: compute the maximum once; a kid is True when their candies plus the extra reach >= the maximum, since a tie counts"
description: "LeetCode 1431 record from 2025-03-18"
date: 2025-03-18
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-03-18
- Submissions: Wrong Answer → Accepted ×2

## Approach

Give all the extra candies to one kid; they have the most if they reach at least the original maximum ([Array]({{< relref "/algorithm/Array" >}}) Template 3). Several kids can tie for the most, so **a tie counts**.

## My Attempts

Attempt 1 used `>`, **so ties did not count**. For `candies = [3]`, `extraCandies = 0`, the only kid already has the most, so the answer is `[True]`; it returned `[False]`. Changing to `>=` passed; the third submission moved `max(candies)` out of the loop.

## Solution

```python
class Solution:
    def kidsWithCandies(self, candies: List[int], extraCandies: int) -> List[bool]:
        top = max(candies)
        return [c + extraCandies >= top for c in candies]
```

## Complexity

Time `O(n)`, space `O(n)` for the output.

## Mistakes to Avoid

- Use `>=`; a tie counts as the most.
- Compute the maximum once instead of inside the comprehension (that would be `O(n²)`).

## Interview Explanation

I compute the maximum once; each kid with the extra candies is True when they are no less than it, ties included. Time `O(n)`.
