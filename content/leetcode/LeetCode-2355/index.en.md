---
title: "LeetCode 2355: Maximum Number of Books You Can Take"
summary: "LeetCode 2355 note: ending at i, each shelf to the left takes one fewer book until a bottleneck shelf j with too few books; a monotonic stack finds j, and dp[i] = dp[j] + an arithmetic series"
description: "LeetCode 2355 record from 2026-07-26"
date: 2026-07-26
tags: ["hard", "dynamic-programming", "monotonic-stack", "stack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-26
- Submissions: Accepted ×2

## Approach

`dp[i]` = the most books taken with shelf `i` as the rightmost.

Ending at `i`, it is best to take all `books[i]` from shelf `i`, and each shelf to the left must take strictly one fewer: shelf `k` takes at most `books[i] - (i - k)`. Walk left until some shelf `j` has **too few** books for that: `books[j] < books[i] - (i - j)`, i.e. **`books[j] - j < books[i] - i`**.

- Shelves `j + 1..i` follow the arithmetic series down from `books[i]`, for at most `i - j` shelves and never below 1, so `length = min(i - j, books[i])` shelves.
- At `j`, its own limit `books[j]` is below what the series would allow, so everything from `j` leftward is `dp[j]`.

```text
dp[i] = dp[j] + (books[i] + (books[i] - length + 1)) × length / 2
```

"The nearest `j` on the left with `books[j] - j < books[i] - i`" is a **monotonic stack**: keep `books[k] - k` increasing and pop entries that are `>=`.

## My Solution

```python
class Solution:
    def maximumBooks(self, books: List[int]) -> int:
        n = len(books)
        dp = [0] * n
        stack = []                                 # books[k] - k increasing
        for i in range(n):
            while stack and books[stack[-1]] - stack[-1] >= books[i] - i:
                stack.pop()
            j = stack[-1] if stack else -1         # nearest bottleneck on the left
            length = min(i - j, books[i])
            dp[i] = (books[i] + books[i] - length + 1) * length // 2
            if j >= 0:
                dp[i] += dp[j]
            stack.append(i)
        return max(dp)
```

My two accepted versions differ only in how the condition is written: `books[top] >= books[i] - (i - top)` and `books[top] - top >= books[i] - i` are the same, and the latter makes the monotonicity easier to see.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The series length cannot exceed `books[i]`: each shelf takes at least 1, so at most `books[i]` shelves to the left.
- The bottleneck condition is strict: `books[j] - j < books[i] - i`.

## Interview Explanation

Ending at `i`, shelf `i` is taken in full and each shelf to the left takes one fewer, until a shelf `j` without enough books, which simplifies to `books[j] - j < books[i] - i`. The shelves right of `j` follow the arithmetic series, and from `j` leftward it is `dp[j]`. A monotonic stack finds the nearest such `j`, giving `O(n)`.
