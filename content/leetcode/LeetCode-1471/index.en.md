---
title: "LeetCode 1471: The k Strongest Values in an Array"
summary: "LeetCode 1471 note: after sorting, the value farthest from the median is always at one of the ends, so converging pointers pick the stronger end k times"
description: "LeetCode 1471 record from 2026-01-25"
date: 2026-01-25
tags: ["medium", "two-pointers", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-25
- Submissions: Wrong Answer → Accepted

## Approach

Sort and take the median `m = arr[(n - 1) // 2]`. Strength is `|arr[i] - m|`, with ties going to the larger value.

After sorting, **the value farthest from `m` is always at one of the ends**. So use converging pointers and compare the two ends:

- `m - arr[left] > arr[right] - m`: the left end is stronger; take it.
- Otherwise take the right end (on equal distance the right value is larger, so it is stronger).

Taking `k` values gives the answer.

## My Attempts

Attempt 1 used `arr[n // 2]` as the median, but the problem defines it as `arr[(n - 1) // 2]`; they differ by one for even lengths. For `arr = [2, -5]`, `k = 1`, sorting gives `[-5, 2]`, the median is `-5`, and the strongest is `2`; using `2` as the median returned `[-5]`.

## Solution

```python
class Solution:
    def getStrongest(self, arr: List[int], k: int) -> List[int]:
        arr.sort()
        m = arr[(len(arr) - 1) // 2]
        left, right = 0, len(arr) - 1
        res = []
        while len(res) < k:
            if m - arr[left] > arr[right] - m:
                res.append(arr[left])
                left += 1
            else:
                res.append(arr[right])            # on a tie, the right value is larger
                right -= 1
        return res
```

My original looped while `left < right` and appended the last element separately when `k == n`; looping on `len(res) < k` avoids that, since both branches take the same element when `left == right`.

## Complexity

Time `O(n log n)`, space `O(1)` apart from the output and sorting.

## Mistakes to Avoid

- Using the wrong median index: it is `(n - 1) // 2`.
- On equal distance, take the larger value, which is the right end.

## Interview Explanation

After sorting I find the median. Strength is distance from the median, so the strongest value is always at one end. Converging pointers compare the ends: take the left one only if its distance is strictly larger, otherwise the right one (ties favor the larger value), `k` times. Time `O(n log n)`.
