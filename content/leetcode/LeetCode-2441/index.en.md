---
title: "LeetCode 2441: Largest Positive Integer That Exists With Its Negative"
summary: "LeetCode 2441 note: keep positives and absolute values of negatives in separate sets and take the largest common value; absolute values alone mistake same-sign duplicates for pairs"
description: "LeetCode 2441 record from 2025-08-06"
date: 2025-08-06
tags: ["easy", "hash-map", "two-pointers", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-08-06
- Submissions: Wrong Answer ×4 → Accepted

## Approach

Find the largest positive `k` such that `-k` is also in the array.

Put **positives** and **absolute values of negatives** into two separate sets; values in both are valid `k`, and the answer is the largest.

## My Attempts

### Attempts 1 and 2: absolute values only

```python
for num in nums:
    if num < 0:
        num *= -1
    if num not in exist:
        exist.add(num)
    else:
        max_num = max(max_num, num)
```

Every number became its absolute value, and a second sighting counted as a pair. The problem: **same-sign duplicates** also count, so `[3, 3]` returns 3 even though `-3` is not in the array. The second attempt only added "return -1 when nothing is found" and did not fix this.

### Attempts 3 and 4: two sets, signs mixed up

Next I used one set for positives and one for negatives, but the signs were never handled right: the third attempt put raw negatives into `exist_pos` and positives into `exist_neg`, so one set held only negatives and the other only positives and the intersection was always empty; the fourth negated the positives, so both sets held negatives and the intersection was found, but it returned `-k`. The final version stores "negatives as absolute values in `exist_neg`, positives as-is in `exist_pos`" and passed.

## Solution

```python
class Solution:
    def findMaxK(self, nums: List[int]) -> int:
        pos = {x for x in nums if x > 0}
        neg = {-x for x in nums if x < 0}
        both = pos & neg
        return max(both) if both else -1
```

### Alternative: sort and use two pointers

After sorting, start the left pointer at the smallest negative and the right pointer at the largest positive: equal absolute values give the answer; if the left side's absolute value is larger, move left rightwards, otherwise move right leftwards. Time `O(n log n)`, space `O(1)`.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Looking only at absolute values: same-sign duplicates are mistaken for pairs.
- Inconsistent signs between the two sets: the intersection is empty, or the answer comes back negative.

## Interview Explanation

I put positives in one set and absolute values of negatives in another; their intersection is the numbers present with both signs, and I return the largest, or `-1` if it is empty. Absolute values alone do not work, because same-sign duplicates would look like a pair. Time `O(n)`.
