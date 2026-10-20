---
title: "LeetCode 1975: Maximum Matrix Sum"
summary: "LeetCode 1975 note: minus signs can travel anywhere in pairs but the parity of the negative count never changes; with an odd count, leave one on the smallest absolute value"
description: "LeetCode 1975 record from 2026-01-06"
date: 2026-01-06
tags: ["medium", "greedy", "matrix", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-06
- Submissions: Accepted (first try)

## Approach

Multiplying two adjacent cells by -1:

- With one negative next to a positive, the minus sign "moves" next door. Repeating along a path, a minus sign can reach any cell.
- Two minus signs meeting cancel at once.
- Every operation flips two cells, so **the parity of the negative count never changes** (a 0 can absorb a sign).

So with an even count everything becomes positive and the answer is the sum of absolute values; with an odd count one negative must remain, placed on the smallest absolute value, giving `sum - 2 × smallest`. A 0 makes the smallest 0, which handles itself.

## My Solution

```python
class Solution:
    def maxMatrixSum(self, matrix: List[List[int]]) -> int:
        total, smallest, neg = 0, inf, 0
        for row in matrix:
            for x in row:
                total += abs(x)
                smallest = min(smallest, abs(x))
                neg += x < 0
        return total if neg % 2 == 0 else total - 2 * smallest
```

I originally kept a separate `zero` flag; with a 0, `smallest` is 0 and subtracting it changes nothing, so it is unnecessary.

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- The remaining minus goes on the smallest **absolute value**, not the smallest value.

## Interview Explanation

Operations can carry a minus sign anywhere along a path and two signs cancel when they meet, but the parity of the negative count is fixed. So an even count gives the sum of absolute values, and an odd count subtracts twice the smallest absolute value. Time `O(n²)`.
