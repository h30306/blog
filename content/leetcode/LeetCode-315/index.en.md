---
title: "LeetCode 315: Count of Smaller Numbers After Self"
summary: "LeetCode 315 note: merge sort with indices, plus a BIT solution"
description: "LeetCode 315 record from the 2026-10-18 merge sort practice ladder"
date: 2026-10-18
tags: ["hard", "merge-sort", "divide-and-conquer", "binary-indexed-tree", "counting"]
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
Source: merge sort practice ladder, step 2

## Approach

The difference from LCR 170: this problem wants an answer **for each element**, not a total.

- Sorting moves elements, so sort `(value, original index)` pairs to know which answer slot to update.
- The count belongs to the left element, so count when the merge **takes a left element**. At that moment, the `j - mid` right elements already taken are all strictly smaller, and all of them were originally to its right.

## My First Attempt

```python
sorted_nums = [(nums[i], i) for i in range(n)]
...
            if j >= high or (i < mid and sorted_nums[i][0] <= sorted_nums[j][0]):
                tmp[k] = sorted_nums[i]
                i += 1
            else:
                tmp[k] = sorted_nums[i]      # should be sorted_nums[j]
                j += 1
...
        return [index for _, index in sorted_nums]   # not the counts
```

## Review

1. **`else` takes the wrong element**: the same kind of bug as `temp[i]` in LC 912. The `j += 1` branch must use `[j]`.
2. **No counting yet**: carrying the index was the right idea, but nothing was counted.
3. **Wrong return value**: it returns original indices in sorted order. A separate `res = [0] * n` is needed.

Compared with LCR 170:

| | LCR 170 | LC 315 |
|---|---|---|
| Question | total number of pairs | smaller elements to the right of each element |
| When to count | when the **right** side is taken | when the **left** side is taken |
| Amount | `mid - i` | `j - mid` |

Rule of thumb: **count for an element at the moment that element is taken.**

## Solution

```python
class Solution:
    def countSmaller(self, nums: list[int]) -> list[int]:
        n = len(nums)
        sorted_nums = [(nums[i], i) for i in range(n)]
        tmp = [(0, 0)] * n
        res = [0] * n

        def mergeAndSort(low: int, high: int):
            if high - low <= 1:
                return

            mid = (low + high) // 2
            mergeAndSort(low, mid)
            mergeAndSort(mid, high)

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and sorted_nums[i][0] <= sorted_nums[j][0]):
                    res[sorted_nums[i][1]] += j - mid    # right elements already taken are smaller
                    tmp[k] = sorted_nums[i]
                    i += 1
                else:
                    tmp[k] = sorted_nums[j]
                    j += 1
                k += 1

            sorted_nums[low:high] = tmp[low:high]

        mergeAndSort(0, n)
        return res
```

`tmp = [(0, 0)] * n` is fine: tuples are immutable, so there is no shared-row problem like with DP tables.

### BIT Solution

Scan from right to left, ask how many values seen so far are smaller, then add the current value. Values range over `-10^4 ~ 10^4`, so shifting them to positive numbers gives BIT indices directly, with no coordinate compression:

```python
class Solution:
    def countSmaller(self, nums: list[int]) -> list[int]:
        OFFSET = 10**4 + 1                 # shift -1e4..1e4 to 1..20001
        size = 2 * 10**4 + 1
        bit = [0] * (size + 1)

        def add(i):
            while i <= size:
                bit[i] += 1
                i += i & -i

        def query(i):                      # count of values in 1..i
            s = 0
            while i > 0:
                s += bit[i]
                i -= i & -i
            return s

        res = [0] * len(nums)
        for idx in range(len(nums) - 1, -1, -1):
            v = nums[idx] + OFFSET
            res[idx] = query(v - 1)        # strictly smaller
            add(v)
        return res
```

## Complexity

| Approach | Time | Space |
|---|---|---|
| Merge sort | `O(n log n)` | `O(n)` |
| BIT | `O(n log U)`, `U` = value range | `O(U)` |
| Brute force | `O(n^2)` | times out at `n = 10^5` |

Keeping a sorted list with `bisect.insort` passes in Python, but each insert is `O(n)`, so it is not an optimal answer in an interview.

## Mistakes to Avoid

- Forgetting that sorting moves elements and not carrying the index.
- Counting in the `else` branch: that is the LCR 170 approach. Here, count when the left side is taken.
- Using `<`: equal values would be counted as smaller.

## Interview Explanation

I merge sort `(value, original index)` pairs. When the merge takes a left element, the `j - mid` right elements already taken are strictly smaller and were originally to its right, so I add that number to its original index. Ties take the left first so equal values are not counted. Time `O(n log n)`, space `O(n)`. The alternative is to scan right to left and query a BIT for the count of smaller values.
