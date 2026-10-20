---
title: "LeetCode 2963: Count the Number of Good Partitions"
summary: "LeetCode 2963 note: all occurrences of a value must share a part, so last occurrences cut the array into b indivisible blocks; each boundary may be cut or not, giving 2^(b-1)"
description: "LeetCode 2963 record from 2026-09-05"
date: 2026-09-05
tags: ["hard", "math", "combinatorics", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-05
- Submissions: Accepted ×2

## Approach

"No two parts contain the same number" ⇔ **every occurrence of a value lies in one part**.

1. Record each value's last index `last[x]`.
2. Scan left to right, tracking how far the current block must reach, `reach = max(last[x])`. At `i == reach` the block ends and cannot be split further.
3. That gives `b` indivisible blocks with `b - 1` boundaries between them, each cut or not: `2^(b - 1)`, modulo.

This is the same idea as [LeetCode 2584]({{< relref "/leetcode/LeetCode-2584" >}}) and "Partition Labels".

## My Solution

```python
class Solution:
    def numberOfGoodPartitions(self, nums: List[int]) -> int:
        last = {x: i for i, x in enumerate(nums)}  # last index of each value
        blocks = 0
        reach = 0
        for i, x in enumerate(nums):
            reach = max(reach, last[x])
            if i == reach:
                blocks += 1                        # an indivisible block ends
        return pow(2, blocks - 1, 10 ** 9 + 7)
```

My original skipped each whole block with a `while` loop, which is the same; one `for` loop tracking `reach` is more concise.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- There are `b - 1` cut points, not `b`.
- Take the power of 2 modulo.

## Interview Explanation

All occurrences of a value must be in one part, so I record each value's last index and scan left to right; the current block must reach the last index of everything seen, and arriving there closes an indivisible block. The `b - 1` boundaries between `b` blocks are each cut or not, so the answer is `2^(b-1)`. Time `O(n)`.
