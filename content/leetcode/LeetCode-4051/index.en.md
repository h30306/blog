---
title: "LeetCode 4051: Count Subarrays with Distant Sums"
summary: "LeetCode 4051 note: prefix sums, complement counting, range counting, and the k = 0 edge case"
description: "LeetCode 4051 record from the 2026-10-19 merge sort practice ladder"
date: 2026-10-19
tags: ["hard", "merge-sort", "prefix-sum", "binary-indexed-tree", "biweekly-contest"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard (Biweekly Contest 191 Q4)
First Attempt: 2026-10-19
Source: merge sort practice ladder, step 6

## Approach

A subarray is distant if its sum satisfies `|sum - goal| >= k`. Count the distant subarrays. `n <= 10^5`, and `nums` can be negative.

1. **Turn subarray sums into prefix sums**: `sum = prefix[R] - prefix[L]` with `L < R`.
2. **Negative numbers rule out sliding window**: prefix sums are not monotonic. Instead, for each `R`, count how many earlier `prefix[L]` fall in a value range. That is a merge sort counting or BIT problem.
3. **Count the complement**: counting distant subarrays directly needs two ranges, and when `k = 0` they overlap and double count. Count the non-distant ones instead:

```text
|sum - goal| < k  ⟺  goal - k < sum < goal + k
```

That is a single contiguous range. Answer = `n(n+1)/2 - bad`.

This is LC 327 Count of Range Sum plus a complement.

## My Attempts

### Attempt 1

```python
# count of sum >= k + goal or sum <= k + goal          ← wrong lower bound
...
j1 = mid
j2 = high - 1
for i in range(low, mid):
    while j1 < high and (prefix[i] - prefix[j1]) <= k + goal:   # reversed sign
        j1 += 1
    while j2 > mid and (prefix[i] - prefix[j2]) >= k + goal:
        j2 -= 1                                                  # pointer moves left
    count += ((high - low) * (high - low + 1) // 2) - (j2 - j1 + 1)
```

Problems:

1. A subarray sum is **right minus left**: `i` is in the left half and `j` in the right, so it should be `prefix[j] - prefix[i]`.
2. The lower bound is `goal - k`, not `goal + k`.
3. **Subtract the complement once, at the top level.** Each merge level only counts bad pairs with `i` on the left and `j` on the right.
4. As `i` moves right, both bounds grow, so **both pointers only move right**.

### Attempt 2

```python
l = r = mid
for i in range(low, mid):
    lo = goal - k
    hi = goal + k
    while l < high and prefix[l] - prefix[i] <= lo:
        l += 1
    while r < high and prefix[r] - prefix[i] < hi:
        r += 1
    bad = r - l          # should be +=
```

All of the issues above are fixed, and comparing subarray sums directly reads well. Two bugs remain:

1. **`bad = r - l` is missing `+`**: it overwrites the recursive results and the counts from earlier `i`. Example 1 returns 6 instead of 5.
2. **No special case for `k = 0`**: with `lo == hi`, `l` stops at the first sum `> goal` and `r` at the first sum `>= goal`, so `r - l` goes negative. `nums = [1]`, `goal = 1`, `k = 0` returns 2 instead of 1.

## Solution

```python
class Solution:
    def distantSubarrays(self, nums: list[int], goal: int, k: int) -> int:
        # distant: sum >= goal + k or sum <= goal - k
        n = len(nums)
        total = n * (n + 1) // 2
        if k == 0:
            return total                       # |x| >= 0 always holds

        prefix = [0] * (n + 1)
        for i in range(n):
            prefix[i + 1] = prefix[i] + nums[i]

        lo, hi = goal - k, goal + k            # bad: lo < sum < hi

        def mergeAndSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0

            mid = (low + high) // 2
            bad = mergeAndSort(low, mid) + mergeAndSort(mid, high)

            l = r = mid
            for i in range(low, mid):
                while l < high and prefix[l] - prefix[i] <= lo:
                    l += 1                     # l: first sum > lo
                while r < high and prefix[r] - prefix[i] < hi:
                    r += 1                     # r: first sum >= hi
                bad += r - l

            prefix[low:high] = sorted(prefix[low:high])
            return bad

        return total - mergeAndSort(0, n + 1)
```

### BIT Solution

For each `prefix[R]`, a bad `prefix[L]` lies in `[prefix[R] - goal - k + 1, prefix[R] - goal + k - 1]`. Prefix sums reach `10^14`, so compress coordinates first:

```python
from bisect import bisect_left, bisect_right

class Solution:
    def distantSubarrays(self, nums: list[int], goal: int, k: int) -> int:
        n = len(nums)
        pre = [0]
        for x in nums:
            pre.append(pre[-1] + x)
        vals = sorted(set(pre))
        m = len(vals)
        bit = [0] * (m + 1)

        def add(i):
            i += 1
            while i <= m:
                bit[i] += 1
                i += i & -i

        def query(i):                          # count of ranks in [0, i)
            r = 0
            while i > 0:
                r += bit[i]
                i -= i & -i
            return r

        bad = 0
        for s in pre:
            lo, hi = s - goal - k + 1, s - goal + k - 1
            if lo <= hi:                       # empty range when k = 0
                bad += query(bisect_right(vals, hi)) - query(bisect_left(vals, lo))
            add(bisect_left(vals, s))          # query before insert keeps L < R
        return n * (n + 1) // 2 - bad
```

## Complexity

Both solutions run in `O(n log n)` time and `O(n)` space.

## Mistakes to Avoid

- Writing code before the derivation is clear. Write the bad range `(lo, hi)` in a comment first.
- Using `=` for an accumulator.
- Not trying extreme inputs: `k = 0`, a single element.
- In Java/C++, prefix sums need `long`.

## Interview Explanation

I turn subarray sums into prefix sum differences; negative numbers rule out sliding window. Counting distant subarrays directly needs two ranges and double counts when `k = 0`, so I count the complement: `goal - k < sum < goal + k` is one contiguous range. With merge sort counting, for each left `prefix[i]` the bad right elements form a middle segment, found with two right-moving pointers. The answer is the total number of subarrays minus the bad ones, and `k = 0` returns the total directly. Time `O(n log n)`.
