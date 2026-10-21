---
title: "LeetCode 41: First Missing Positive"
summary: "LeetCode 41 note: the answer is in 1..n+1; replace impossible values with n+1 (not 0) and mark v as seen with the sign of nums[v-1]"
description: "LeetCode 41 record from 2026-01-31"
date: 2026-01-31
tags: ["hard", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-31
- Submissions: Wrong Answer ×4 → Accepted ×2; rewritten 2026-07-07: Accepted ×2 → Wrong Answer → Accepted

## Approach

An array of length `n` holds at most `1..n`, so the answer is in `1..n + 1`. With `O(1)` extra space, use the array itself as a hash table ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 2):

1. Values `<= 0` cannot affect the answer; replace them with `n + 1`.
2. For each value `v` (absolute value, since it may already be negated), if `1 <= v <= n`, make `nums[v - 1]` negative to record "`v` was seen".
3. The first position `i` still positive gives the answer `i + 1`; if all are negative, the answer is `n + 1`.

## My Attempts

The first four versions replaced values `<= 0` with **0**, and 0 was the problem:

| Version | Problem |
|---|---|
| Attempt 1 | Returned `n` when everything was present, instead of `n + 1`. For `[1]` the answer is 2; it returned 1 |
| Attempt 2 | Returned "maximum + 1", but computed the maximum **before** replacing with 0. `[-1]`: answer 1, it returned 0 |
| Attempt 3 | Moved the maximum after, but a 0 in a slot is not positive, so it looked "seen". `[0, 3]`: answer 1, it returned 2 |
| Attempt 4 | Checked `>= 0` instead, but **negating 0 gives 0**, so values that were present could not be marked. `[0, 1]`: answer 2, it returned 1 |
| AC | Replaced with `n + 1`, so the sign marking works |

Rewriting it half a year later I dropped the final `return`, and `[1]` returned `None`.

## Solution

```python
class Solution:
    def firstMissingPositive(self, nums: List[int]) -> int:
        n = len(nums)
        for i in range(n):
            if nums[i] <= 0:
                nums[i] = n + 1                    # not 0: 0 cannot be negated
        for x in nums:
            v = abs(x)
            if v <= n:
                nums[v - 1] = -abs(nums[v - 1])    # mark v as seen
        for i in range(n):
            if nums[i] > 0:
                return i + 1
        return n + 1
```

## Complexity

Time `O(n)`, extra space `O(1)`.

## Mistakes to Avoid

- The "impossible" value cannot be 0; its sign cannot carry a mark.
- Read values with `abs`, since they may already be marked negative.
- With all of `1..n` present, the answer is `n + 1`.

## Interview Explanation

The answer is between 1 and `n + 1`. I replace non-positive values with `n + 1`, then use the sign of `nums[v - 1]` to record whether `v` appears, taking absolute values when reading. The first position still positive is the answer, or `n + 1` if none. Time `O(n)`, extra space `O(1)`.
