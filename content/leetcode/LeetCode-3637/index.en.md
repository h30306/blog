---
title: "LeetCode 3637: Trionic Array I"
summary: "LeetCode 3637 note: walk one index through uphill, downhill and uphill; all three runs must be non-empty and reach the end exactly"
description: "LeetCode 3637 record from 2025-08-03"
date: 2025-08-03
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
First Attempt: 2025-08-03
- Submissions: Wrong Answer → Runtime Error ×2 → Wrong Answer ×2 → Accepted; rewritten 2026-02-03: Wrong Answer → Accepted

## Approach

Advance one index run by run ([Array]({{< relref "/algorithm/Array" >}}) Template 1): strictly uphill to `p`, strictly downhill to `q`, then strictly uphill again. It holds when all three runs are non-empty (`0 < p < q < n - 1`) and the third run ends exactly at the last element.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1 | Added sentinels at both ends, but the index started at 0 and compared with `nums[-1]` (the trailing `inf` sentinel), so the first run counted as empty. `[0, 5, 2, 3]`: answer `True`, it returned `False` |
| Two REs | Switched to enumerating `p`, but the pasted code lost `self` and its indentation |
| Attempt 4 | `return False` was indented inside the `for` loop: only the first `p` was tried, and when the loop finished via `continue` nothing was returned, e.g. `[0, 1, 3, 2]` returned `None` |
| Attempt 5 | Moved `return False` out, but the downhill run could reach the last element, so an empty third run still passed. `[2, 5, 2, 2]`: answer `False`, it returned `True` |
| AC | Three nested loops enumerating `p` and `q` and checking each run (`n <= 100`, so `O(n³)` passes) |
| Rewrite half a year later | Tried a single scan but never required a final uphill run. `[2, 5, 0]`: answer `False`, it returned `True` |

## Solution

```python
class Solution:
    def isTrionic(self, nums: List[int]) -> bool:
        n, i = len(nums), 0
        while i + 1 < n and nums[i] < nums[i + 1]:
            i += 1
        p = i
        while i + 1 < n and nums[i] > nums[i + 1]:
            i += 1
        q = i
        while i + 1 < n and nums[i] < nums[i + 1]:
            i += 1
        return 0 < p < q < n - 1 and i == n - 1
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- All three runs must be non-empty: `p > 0`, `q > p`, `q < n - 1`.
- Confirm the third run reaches the end.
- Put `return False` outside the loop.

## Interview Explanation

I walk one index through uphill, downhill and uphill, then check all three runs are non-empty and the third ends exactly at the end of the array. Time `O(n)`.
