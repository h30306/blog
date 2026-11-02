---
title: "LeetCode 1186: Maximum Subarray Sum with One Deletion"
summary: "LeetCode 1186 note: Kadane with one more state, ending here with no deletion or with one deletion; update the answer at every step"
description: "LeetCode 1186 record from 2026-10-22"
date: 2026-10-22
tags: ["medium", "array", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-22
- Submissions: Wrong Answer → Accepted

## Approach

Kadane ([Kadane's Algorithm]({{< relref "/algorithm/Kadanes-Algorithm" >}})) with one extra state. At each index `i`, keep two values, both for subarrays **ending at `i`**:

- `no_delete`: the best sum with no deletion, `max(no_delete + num, num)`, the usual Kadane.
- `delete_one`: the best sum with exactly one deletion. Two sources:
  - Delete the current `num`: the sum of the best undeleted subarray ending just before, i.e. the previous `no_delete`.
  - A deletion already happened earlier: `delete_one + num`.

Update both from the previous step's values at the same time. The subarray must keep at least one element, so `delete_one` starts at `-inf` and the first element cannot be deleted into an empty subarray.

The answer is the maximum of both values over all indices, **updated at every step**.

## My Attempts

1. Returned `max(no_delete, delete_one)` only at the end. Those states describe subarrays ending at the last element, but the best one may end earlier: `[1,-1,-3]` returned 0, the answer is 1.
2. Updating the answer at every step passed.

## Solution

```python
class Solution:
    def maximumSum(self, arr: List[int]) -> int:
        no_delete = -inf
        delete_one = -inf
        best = -inf
        for num in arr:
            no_delete, delete_one = max(no_delete + num, num), max(no_delete, delete_one + num)
            best = max(best, no_delete, delete_one)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The DP state means "ends here", so take the maximum at every step, not only at the last one.
- Update both states simultaneously (tuple assignment); `delete_one` needs the **old** `no_delete`.
- If every value is negative the answer is the largest element, since the array cannot be deleted to empty; start from `-inf`, not 0.

## Interview Explanation

It is Kadane with one more state: the best sum ending at `i` with no deletion, and with one deletion. One deletion comes either from deleting the current element after the previous undeleted best, or from an earlier deletion plus the current element. Since the states mean "ends here", I update the answer at every step. Time `O(n)`, space `O(1)`.
