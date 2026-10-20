---
title: "LeetCode 3638: Maximum Balanced Shipments"
summary: "LeetCode 3638 note: greedily cut a segment as soon as a value below its maximum appears; until then the segment is non-decreasing, so its maximum is the previous value"
description: "LeetCode 3638 record from 2025-08-03"
date: 2025-08-03
tags: ["medium", "dynamic-programming", "greedy", "monotonic-stack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-03
- Submissions: Wrong Answer → Accepted

## Approach

A segment is valid ⇔ its last value is **strictly less** than its maximum.

**Greedy: cut as soon as possible**. Going left to right, as soon as the current value is below the segment's maximum, end the segment and start a new one. Ending early never reduces later cuts (no later element is used up).

Before a cut, the segment is always **non-decreasing** (otherwise it would have been cut already), so its maximum is **the previous value**. Comparing `weight[i] < weight[i - 1]` is enough.

## My Attempts

Attempt 1 remembered the segment's **first value** and kept comparing against it instead of the maximum. For `weight = [1, 5, 2]`, the maximum of `[1, 5, 2]` is 5 and `2 < 5`, so it forms one segment and the answer is 1; but `2` is not below the first value `1`, so this returned 0.

Updating the remembered value to the current value (the maximum) whenever no cut happens passed.

## Solution

```python
class Solution:
    def maxBalancedShipments(self, weight: List[int]) -> int:
        count = 0
        prev = None                                # the segment's max so far (= previous value)
        for w in weight:
            if prev is not None and w < prev:
                count += 1                         # cut as soon as possible
                prev = None                        # start a new segment
            else:
                prev = w
        return count
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Comparing with the segment's first value: compare with its maximum.
- After a cut, start over; the next value begins a new segment.

## Interview Explanation

A segment is valid when its last value is below its maximum. Greedily I cut as soon as possible, since ending early wastes no later elements. Before a cut the segment is non-decreasing, so its maximum is the previous value, and comparing neighbors is enough. Time `O(n)`.
