---
title: "Greedy"
summary: "Sort then scan, intervals sorted by right end, left and right passes, pairing and parity invariants, adjacent differences, and \"remove what exceeds the average\", each with why greedy is correct"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["greedy", "sorting", "intervals"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Greedy makes the choice that looks best right now at every step and never goes back. The code is usually short; the hard part is **knowing it is correct**. Two common proofs:

- **Exchange argument**: suppose an optimal solution differs from greedy at some step; swapping in greedy's choice does not make it worse.
- **Invariant / lower bound**: find a quantity no operation can change (such as the parity of the number of negatives), or a cost every solution must pay, and show greedy achieves it exactly.

| Form | How | Examples |
|---|---|---|
| Sort then scan | Decide small to large (or large to small) whether to take each | Grouping, buy the most items, top `k` |
| Intervals | Sort by right end, place points as far right as possible | At least two points in every interval |
| Left and right passes | One pass for the left neighbor's constraint, one for the right | Candy, propagating upper bounds |
| Pairing and parity | Count each type first, then decide how to pair | Palindrome pairs, sign flips, swap costs |
| Adjacent differences | The answer depends only on neighboring differences | Minimum total increase to make an array non-decreasing |
| Average | A resource larger than the average can only serve one consumer | Batteries for computers |

When choices interact and taking one makes later options worse, you usually need DP; see [Linear DP]({{< relref "/algorithm/Linear-DP" >}}).

## Template 1: Sort then scan

```python
nums.sort()
groups = 1
start = nums[0]                          # minimum of the current group
for x in nums[1:]:
    if x - start > k:                    # does not fit, start a new group
        groups += 1
        start = x
```

- **Groups with max minus min `<= k`** (LC 2294): after sorting, extend each group as far right as possible.
- **Buy the most items with limited money** (LC 1833): buy the cheapest first; the problem asks for counting sort, and values are at most `10^5`.
- **At most `k` distinct numbers, maximum sum** (LC 3684): deduplicate and take the `k` largest.
- **Fewest deletions so at most `k` kinds remain** (LC 3545): delete whole kinds, least frequent first.
- **Delete anything, then pick a subarray with no repeats** (LC 3487): this is choosing distinct values; take every non-negative one, or only the maximum when all are negative.
- **Largest all-ones submatrix with columns rearranged** (LC 1727): per row, compute the height of consecutive ones above; sort descending, and the `j`-th tallest times `j + 1` columns is a candidate.

## Template 2: Intervals, sorted by right end

```python
intervals.sort(key=lambda x: (x[1], -x[0]))    # smaller right end first; same right end, shorter first
p1 = p2 = float("-inf")                  # the two rightmost points placed, p1 < p2
res = 0
for s, e in intervals:
    if s > p2:                           # covers neither point
        res += 2
        p1, p2 = e - 1, e
    elif s > p1:                         # covers only p2
        res += 1
        p1, p2 = p2, e
```

Place points at the **right end**: later intervals only have larger right ends, so points on the right are the most likely to be shared (LC 757). With the same right end, handle the shorter interval (larger left end) first; otherwise the longer one would wrongly look covered by two points.

- **Insert interval** (LC 57): the intervals are sorted, so split them into entirely left, entirely right and overlapping, merging the overlapping ones into the new interval; start the merge from the new interval itself.
- **Summary ranges** (LC 228): extend the last range when the number continues it, otherwise open a new one.

## Template 3: Left and right passes

When a condition involves both neighbors, handle one side per pass:

```python
left = [1] * n
for i in range(1, n):
    if ratings[i] > ratings[i - 1]:
        left[i] = left[i - 1] + 1
right = [1] * n
for i in range(n - 2, -1, -1):
    if ratings[i] > ratings[i + 1]:
        right[i] = right[i + 1] + 1
res = sum(max(a, b) for a, b in zip(left, right))
```

- **Candy** (LC 135): `left` satisfies the left condition and `right` the right one; taking the larger satisfies both, and each is a necessary lower bound.
- **Propagating upper bounds** (LC 3796): each position's bound = min of its own limit, the left bound + difference, and the right bound + difference. One pass left to right and one right to left converge.

## Template 4: Pairing and parity

Classify positions and count them; the answer depends only on the counts:

```python
cnt = Counter(words)
res, mid = 0, False
for w, c in cnt.items():
    r = w[::-1]
    if w == r:                           # itself a palindrome: pair up on both sides
        res += c // 2 * 4
        mid |= c % 2 == 1                # one leftover can go in the middle
    elif w < r:                          # pair with its reverse, count each pair once
        res += min(c, cnt[r]) * 4
res += 2 if mid else 0
```

- **Palindrome pairs** (LC 2131): the code above.
- **Signs can move in pairs** (LC 1975): multiplying two neighbors by -1 lets a minus sign travel anywhere, but the **parity of the number of negatives never changes**. An even count all becomes positive; an odd count leaves one on the smallest absolute value.
- **Two kinds of mismatch** (LC 3800): count `s = 0, t = 1` and `s = 1, t = 0`. A pair of different kinds costs one swap, a pair of the same kind costs cross + swap, and a leftover must be flipped; compare each against two flips.
- **Excess fruit** (LC 2561): every value's total must be even. Sort the excess; each cheap half item swaps with an expensive one, or uses the global minimum as a go-between for `2 × min`.
- **One operation per value** (LC 3810): the answer is how many distinct values sit at mismatched positions.
- **Device minimums** (LC 3961): all devices but one donate their smallest unit to the same device; the one left is the device with the smallest second-smallest value.

## Template 5: Adjacent differences

An operation affects only the two ends of its range, so the answer often depends only on adjacent differences:

```python
res = 0
for i in range(1, n):
    res += max(0, nums[i - 1] - nums[i])   # every drop must be filled
```

- **Minimum total increase to make the array non-decreasing** (LC 3914): adding `x` to `[l, r]` only raises the `l - 1 → l` difference by `x`. Each drop needs at least its size, and adding to suffixes achieves exactly that.
- **Moving cost with a cheap "closest" move** (LC 3919): walk step by step, each step costing 1 (if the next index is the closest) or the gap; jumping directly costs the sum of gaps, never cheaper. Answer queries with prefix sums.
- **Max minus min** (LC 3689): the whole array has the global max and min, and can be chosen `k` times.

## Template 6: Remove what exceeds the average

```python
batteries.sort()
total = sum(batteries)
while batteries[-1] > total // n:        # a battery above the average can only serve one computer
    total -= batteries.pop()
    n -= 1
return total // n
```

A battery longer than the average run time can at most power one computer the whole time, with the rest wasted; remove it together with that computer and average the rest (LC 2141). Use strict `>`: after removing a battery equal to the average, the remaining average can exceed it, and that computer cannot last that long.

## Key Parameters

- The sort key decides the scan order; interval problems often use `(right end, -left end)`.
- For counting problems, first work out how many types there are, then the cost of each type.
- In a second pass, combine with the first pass using `max` / `min` instead of overwriting.

## Complexity

Mostly sorting `O(n log n)` plus one scan `O(n)`. Counting problems are `O(n)`.

## Common Mistakes

These are mistakes I actually made while practicing:

- **Returning 0 when everything is negative**: collecting only positives left the set empty (LC 3487).
- **Finding the maximum's position in the whole array**: recursing on a subrange with `ratings.index(...)` found a position outside it, giving wrong results or infinite recursion (LC 135).
- **Sending every self-palindrome word to the middle**: `["cc", "cc"]` can go one on each side for length 4 (LC 2131).
- **Checking only the cell before the crossing point**: the peak of two slopes can be the crossing cell itself (LC 3796).
- **Hard-coding the top 3** instead of using `k` (LC 3684).
- **Assuming each row is sorted** and taking `unit[0]` as the minimum (LC 3961).
- **Not subtracting a removed battery from the total**, and using `<=` so batteries equal to the average were removed too (LC 2141).
- **A `while` condition using a count read before the loop**: it never changes, so the counts kept dropping below zero (LC 2561).
- **Not marking newly planted flowers**: two adjacent empty plots both count as plantable (LC 605).
- **Tracking only the total for change**: count each denomination (LC 860).
- **Requiring exactly 3 pieces**: zero-sum pieces can be cut further, so test `>= 3` (LC 1013).
- **Updating `first` with a strict `>` in the increasing triplet**: equal values become `second` (LC 334).
- **Merging from `inf` and taking `min` of right ends** (LC 57).

## Related LeetCode

- `LC 3487` Maximum Unique Subarray Sum After Deletion
- `LC 3545` Minimum Deletions for At Most K Distinct Characters
- `LC 135` Candy
- `LC 2131` Longest Palindrome by Concatenating Two Letter Words
- `LC 2294` Partition Array Such That Maximum Difference Is K
- `LC 3689` Maximum Total Subarray Value I
- `LC 3796` Find Maximum Value in a Constrained Sequence
- `LC 3800` Minimum Cost to Make Two Binary Strings Equal
- `LC 1975` Maximum Matrix Sum
- `LC 3810` Minimum Operations to Reach Target Array
- `LC 3684` Maximize Sum of At Most K Distinct Elements
- `LC 3914` Minimum Operations to Make Array Non Decreasing
- `LC 3919` Minimum Cost to Move Between Indices
- `LC 3961` Maximize Sum of Device Ratings
- `LC 1833` Maximum Ice Cream Bars
- `LC 1727` Largest Submatrix With Rearrangements
- `LC 757` Set Intersection Size At Least Two
- `LC 2141` Maximum Running Time of N Computers
- `LC 2561` Rearranging Fruits
- `LC 605` Can Place Flowers
- `LC 860` Lemonade Change
- `LC 1013` Partition Array Into Three Parts With Equal Sum
- `LC 334` Increasing Triplet Subsequence
- `LC 134` Gas Station
- `LC 228` Summary Ranges
- `LC 57` Insert Interval
- `LC 435` Non-overlapping Intervals
