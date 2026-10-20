---
title: "LeetCode LCR 170: Count Inversions (Sword Offer 51)"
summary: "LCR 170 note: count inversions during the merge step"
description: "LCR 170 record from the 2026-10-18 merge sort practice ladder"
date: 2026-10-18
tags: ["hard", "merge-sort", "divide-and-conquer", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-18
Source: merge sort practice ladder, step 1 (the classic problem)

## Approach

An inversion is a pair with `i < j` and `record[i] > record[j]`. Starting from the LC 912 merge sort, **only one line is added**:

When the merge enters `else`, the right element `record[j]` is strictly smaller than the left element `record[i]` (on ties, `<=` takes the left first). The left half is sorted, so all of `record[i..mid-1]` are larger than `record[j]`, and each forms an inversion with it: `mid - i` pairs.

## My First Attempt

I adapted Krahets' closed-interval solution to my usual half-open style:

```python
def mergeSort(low: int, high: int):
    if high - low <= 1:
        return                                   # ① returns None

    mid = (low + high) // 2
    res = mergeSort(low, mid) + mergeSort(mid, right)   # ② right is undefined

    i, j, k = l, mid, l                          # ③ l is undefined
    while i < mid or j < high:
        if j >= high or (i < mid and record[i] <= reocrd[j]):   # ④ typo
            tmp[k] = record[i]
            i += 1
        elif i >= mid:
            tmp[k] = reocrd[j]
            j += 1
        else:
            tmp[k] = record[j]
            j += 1
            res += mid - i + 1                   # ⑤ off by one
        k += 1

    res[low: high] = tmp[low: high]              # ⑥ should write back to record
    return res
```

## Review

| # | Problem | Result |
|---|---|---|
| ① | the base case should be `return 0` | `None + None`, TypeError |
| ② ③ | mixing the reference's `l`, `r` with my `low`, `high` | NameError |
| ④ | `reocrd` typo | NameError |
| ⑤ | `mid - i + 1` | **logic error, no exception** |
| ⑥ | `res` is an int and cannot be sliced | TypeError |

⑤ is the important one. The reference uses closed intervals `[l, m]`, where the left half has `m - i + 1` elements left. With half-open `[low, mid)`, it has `mid - i`. On `[2, 1]`, my version returns 2; the correct answer is 1.

**When borrowing a formula from someone else's solution, re-derive it with your own interval convention.**

The `elif i >= mid` branch can also go. With `mid - i`, an exhausted left half means `i == mid`, so `else` adds 0 and nothing is overcounted.

## Solution

```python
class Solution:
    def reversePairs(self, record: list[int]) -> int:
        n = len(record)
        tmp = [0] * n

        def mergeSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0

            mid = (low + high) // 2
            res = mergeSort(low, mid) + mergeSort(mid, high)

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and record[i] <= record[j]):
                    tmp[k] = record[i]
                    i += 1
                else:
                    tmp[k] = record[j]
                    j += 1
                    res += mid - i        # every remaining left element is larger
                k += 1

            record[low:high] = tmp[low:high]
            return res

        return mergeSort(0, n)
```

## Complexity

Time `O(n log n)`, space `O(n)`. Counting adds one `O(1)` addition whenever the right side is taken.

## Mistakes to Avoid

- Using `<` instead of `<=`: ties then take the right element first and equal pairs are counted as inversions.
- Copying the closed-interval `+ 1`.
- Not scanning variable names after writing: every name used must be defined somewhere above.

## Interview Explanation

I count during the merge step of merge sort. In a merge, every left element was originally an `i` and every right element a `j`, so each cross pair already has `i < j`. When a right element is smaller than the left front, all `mid - i` remaining left elements are larger than it, so I add them all at once. On ties I take the left first so equal pairs are not counted. Time `O(n log n)`, space `O(n)`.
