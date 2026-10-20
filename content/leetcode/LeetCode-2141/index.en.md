---
title: "LeetCode 2141: Maximum Running Time of N Computers"
summary: "LeetCode 2141 note: a battery longer than the average can only serve one computer, so remove it with that computer and average the rest, using strict greater-than"
description: "LeetCode 2141 record from 2026-07-28"
date: 2026-07-28
tags: ["hard", "greedy", "binary-search", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-28
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Batteries can be swapped at any time, so as long as there is enough total charge the time spreads evenly: ideally `total // n` minutes.

The exception is an **unusually large battery**: a battery can be in only one computer at a time, so it contributes at most `T` minutes to one computer. If the largest battery exceeds the average `total // n`, dedicate it to one computer and waste the rest; remove both and recompute the average. Repeat until the largest battery does not exceed the average ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 6).

## My Attempts

1. **Attempt 1** removed batteries **without subtracting them from the total**. For `n = 2`, `[7, 5]` the answer is 5; after removing 7 it returned `12 // 1 = 12`.
2. **Attempt 2** subtracted, but used `avg <= batteries[-1]`, **removing batteries equal to the average too**. For `n = 2`, `[4, 1, 4]` the average is `9 // 2 = 4`; removing one 4 leaves `[1, 4]` for one computer with average 5, but the removed computer only runs 4 minutes. The answer is 4; it returned 5.
3. Strict `<` passed.

Why strict is safe: if `b > total / n`, the new average `(total - b) / (n - 1)` is below `total / n` and hence below `b`, so the dedicated computer outlasts the rest; with equality that is not guaranteed.

## Solution

```python
class Solution:
    def maxRunTime(self, n: int, batteries: List[int]) -> int:
        batteries.sort()
        total = sum(batteries)
        while batteries[-1] > total // n:
            total -= batteries.pop()
            n -= 1
        return total // n
```

With `n = 1` the average is the total, never below the largest battery, so the loop cannot bring `n` to 0.

Binary searching the answer `T` also works: check `sum(min(b, T)) >= n * T`, since each battery contributes at most `T`.

## Complexity

Time `O(m log m)` for `m` batteries, space `O(1)` besides sorting.

## Mistakes to Avoid

- Subtract a removed battery from the total.
- Do not remove a battery equal to the average; use strict greater-than.

## Interview Explanation

Since batteries can be swapped freely, ideally all computers run for total charge divided by the number of computers. But a battery serves only one computer at a time, so if it exceeds the average I dedicate it to one computer, remove both, and recompute, until the largest battery fits under the average. The comparison must be strict, because removing a battery equal to the average can leave a higher average than it. Time `O(m log m)`.
