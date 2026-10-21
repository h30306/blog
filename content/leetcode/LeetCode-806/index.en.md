---
title: "LeetCode 806: Number of Lines To Write String"
summary: "LeetCode 806 note: simulate writing, wrapping when the next letter would exceed 100; landing exactly on 100 stays on the line"
description: "LeetCode 806 record from 2022-09-07"
date: 2022-09-07
tags: ["easy", "array", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-07
- Submissions: Wrong Answer → Runtime Error → Wrong Answer ×6 → Runtime Error → Wrong Answer ×2 → Accepted

## Approach

Simulate from line 1 at width 0: wrap only when the current width plus this letter's width **exceeds 100** (the new line starts at this letter's width); otherwise add it. Reaching exactly 100 **stays on the line**.

## My Attempts

This took 12 submissions, all patching one wrong idea, "exactly 100 moves to the next line at width 0":

- Attempt 1 used the letter's index as its width instead of looking up `widths`, and a lone `"a"` was then reduced by the trailing "width 0 means one line fewer" fix to `[-1, 0]`.
- After wrapping, the width was set to the letter's width **and then added again by the next `if`**: `[2, 23]` instead of `[2, 15]`.
- With `elif`, filling exactly 100 was treated as a wrap and then undone, giving `[1, 0]` instead of `[1, 100]`.
- The accepted version patched the end: "if the width is 0, drop a line and set the width to 100".

## Solution

```python
class Solution:
    def numberOfLines(self, widths: List[int], s: str) -> List[int]:
        lines, cur = 1, 0
        for c in s:
            w = widths[ord(c) - ord("a")]
            if cur + w > 100:
                lines += 1
                cur = w
            else:
                cur += w
        return [lines, cur]
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Exactly 100 does not wrap; the last line's width can be 100.
- After wrapping the new line holds this letter's width; do not add it again.
- Look the width up in `widths`, not the letter's index.

## Interview Explanation

I simulate from the first line, wrapping only when the next letter would exceed 100 and starting the new line at that letter's width, otherwise accumulating; I return the line count and the last width. Time `O(n)`.
