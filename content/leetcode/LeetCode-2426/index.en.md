---
title: "LeetCode 2426: Number of Pairs Satisfying Inequality"
summary: "LeetCode 2426 note: simplify the inequality, then decide whether the matches form a prefix or a suffix"
description: "LeetCode 2426 record from the 2026-10-19 merge sort practice ladder"
date: 2026-10-19
tags: ["hard", "merge-sort", "divide-and-conquer", "two-pointers", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-19
Source: merge sort practice ladder, step 5

## Approach

The condition is `nums1[i] - nums1[j] <= nums2[i] - nums2[j] + diff` with `i < j`. Group the terms by index:

```text
(nums1[i] - nums2[i]) - (nums1[j] - nums2[j]) <= diff
let d = nums1 - nums2
d[i] - d[j] <= diff
```

After that it is merge sort counting on `d`, scanning first and merging afterwards like LC 493.

## My First Attempt

The simplification was right, but the counting loop was copied straight from LC 493:

```python
j = mid
for i in range(low, mid):
    while j < high and nums[i] - nums[j] >= diff:   # inequality flipped
        j += 1
    count += j - mid                                # counts the wrong side
```

## Review

1. **The inequality is flipped**: the problem asks for `<= diff`, not `>= diff`.
2. **The matching `j` form a suffix, not a prefix**: rewrite the condition in terms of `j`:

```text
d[i] - d[j] <= diff  ⟺  d[j] >= d[i] - diff
```

The right half is ascending and `d[j]` must be large enough, so the matches are a **suffix** of size `high - j`. In LC 493, `nums[j]` must be small enough, so the matches are a prefix.

Check with `nums1 = [3,2,5]`, `nums2 = [2,2,1]`, `diff = 1`: `d = [1, 0, 4]`, all three pairs qualify, so the answer is 3. The first attempt returns 1.

**Before writing the counting loop, ask: after rewriting the condition as "`d[j]` compared to some value", are the matching `j` a prefix or a suffix?**

| Rewritten condition | Matching `j` in an ascending right half | Count |
|---|---|---|
| `d[j] < X` or `d[j] <= X` | prefix | `j - mid` |
| `d[j] > X` or `d[j] >= X` | suffix | `high - j` |

## Solution

```python
class Solution:
    def numberOfPairs(self, nums1: list[int], nums2: list[int], diff: int) -> int:
        # d[i] - d[j] <= diff  ⟺  d[j] >= d[i] - diff
        n = len(nums1)
        nums = [nums1[i] - nums2[i] for i in range(n)]

        def mergeAndSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0

            mid = (low + high) // 2
            count = mergeAndSort(low, mid) + mergeAndSort(mid, high)

            j = mid
            for i in range(low, mid):
                while j < high and nums[i] - nums[j] > diff:   # skip non-matching
                    j += 1
                count += high - j                              # the rest all match

            nums[low:high] = sorted(nums[low:high])
            return count

        return mergeAndSort(0, n)
```

As `i` moves right, `d[i]` grows and so does the threshold `d[i] - diff`. The skipped part only grows, so `j` never moves back.

## Complexity

Time `O(n log n)`, space `O(n)`. `sorted()` is close to linear on two sorted runs; an interviewer may ask for a hand-written merge.

## Mistakes to Avoid

- Reusing the previous problem's counting without first rewriting the condition as "`d[j]` compared to some value".
- Putting the `i` and `j` terms on the wrong side while simplifying.

## Interview Explanation

I first group the terms by index. With `d = nums1 - nums2`, the condition becomes `d[i] - d[j] <= diff`, which is `d[j] >= d[i] - diff`. Then I run merge sort counting on `d`: after both halves are sorted, for each left `d[i]` the matching right elements form a suffix, so a forward-only pointer finds where it starts and I add `high - j`. Time `O(n log n)`, space `O(n)`.
