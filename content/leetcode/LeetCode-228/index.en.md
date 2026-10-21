---
title: "LeetCode 228: Summary Ranges"
summary: "LeetCode 228 note: scan once, extending the current range when a number continues the previous one and opening a new range otherwise, then format"
description: "LeetCode 228 record from 2022-08-21"
date: 2022-08-21
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
First Attempt: 2022-08-21
- Submissions: Runtime Error ×3 → Wrong Answer ×4 → Runtime Error ×2 → Accepted ×4 → Runtime Error → Accepted

## Approach

Keep a list of ranges: a number `x` equal to the last range's end plus one extends it, otherwise open `[x, x]`. Finally format `a == b` as `"a"` and others as `"a->b"`. The last range and the empty array need no special handling.

## My Attempts

This took 15 submissions:

- The first versions emitted a range only when the next number jumped by more than 1, **so the final range was never emitted**, and an empty array returned `None`: `[3]` returned `[]`.
- Handling the last element by index then kept reading `nums[i + 1]` out of range.
- The first accepted version was full of special cases; the final rewrite, "extend the last range when the number continues it", removed every boundary problem.

## Solution

```python
class Solution:
    def summaryRanges(self, nums: List[int]) -> List[str]:
        ranges = []
        for x in nums:
            if ranges and ranges[-1][1] == x - 1:
                ranges[-1][1] = x
            else:
                ranges.append([x, x])
        return [str(a) if a == b else f"{a}->{b}" for a, b in ranges]
```

## Complexity

Time `O(n)`, space `O(n)` (output).

## Mistakes to Avoid

- Emit the final range.
- An empty array returns an empty list, not `None`.
- A single-number range is written `"a"`.

## Interview Explanation

In one pass I keep a list of ranges, extending the last one when a number continues it and opening a new one otherwise, then format them. Time `O(n)`.
