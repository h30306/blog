---
title: "Sliding Window"
summary: "Fixed-size windows, variable windows for longest / shortest, counting subarrays (at most K minus at most K - 1), and monotonic deques for window extremes"
description: "Algorithm Learning"
date: 2025-07-04
tags: ["sliding-window", "two-pointers", "hash-table", "monotonic-queue"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Sliding windows handle problems about **contiguous subarrays / substrings**. Enumerating every range is `O(n^2)`; a sliding window moves both boundaries only to the right, so each element enters and leaves once, giving `O(n)`.

The key is that **when the window moves, update only the element coming in and the one going out**; never recompute the whole window.

| Form | How the window moves | Example |
|---|---|---|
| Fixed size | One in on the right, one out on the left | Max sum of length `k`, per-window statistics |
| Variable, longest | Grow right; when invalid, shrink left until valid | Longest subarray with at most `k` zeros |
| Variable, shortest | Grow right; while valid, shrink left as far as possible | Shortest subarray with sum at least `k` |
| Counting subarrays | `right - left + 1` valid subarrays end at `right` | "Exactly K" as "at most K" minus "at most K - 1" |
| Window max / min | Monotonic deque | Sliding window maximum |

Variable windows need **monotonicity**: as the window grows, the condition only gets harder (or easier) to satisfy. With negative numbers or a non-monotonic condition, prefix sums plus a hash map are usually the tool instead.

## Template 1: Fixed-size window

```python
window = 0
for right, x in enumerate(nums):
    window += x                          # in
    if right >= k:
        window -= nums[right - k]        # out
    if right >= k - 1:                   # update only once the window is full
        res = max(res, window)
```

What the window maintains is not always a sum:

- **Hash map / count array**: how many distinct values are in the window (LC 2841, 2461), or the `x`-th smallest negative (LC 2653, small value range, so a count array).
- **Turn "remove a part" into "keep a part"**: taking `k` cards from the ends = keeping a contiguous middle of length `n - k` with minimum sum (LC 1423); removing a length-`k` substring = the remaining displacement = total displacement minus the window's (LC 3694).
- **Circular arrays**: concatenate the array with itself, or use `i % n` (LC 2134, 1888).
- **Rolling hash**: multiply / divide by `power` as the window moves, touching only the ends (LC 2156).

## Template 2: Variable window, longest

```python
left = 0
for right, x in enumerate(nums):
    add(x)
    while window_invalid():
        remove(nums[left])
        left += 1
    res = max(res, right - left + 1)     # always valid after shrinking
```

- **At most one 0**: the longest all-1s run after deleting one element is the longest window with at most one 0, minus 1 (LC 1493).

## Template 3: Variable window, shortest

```python
left = 0
for right, x in enumerate(nums):
    add(x)
    while window_valid():
        res = min(res, right - left + 1) # update while valid, then try shrinking
        remove(nums[left])
        left += 1
```

- **Sum of distinct values at least `k`** (LC 3795): a value appearing several times counts once. Record each value's **last position**, and when the left boundary leaves, subtract it only if that was its last occurrence.

## Template 4: Counting subarrays

Every subarray ending at `right` with its left end in `[left, right]` is valid, which is `right - left + 1` of them:

```python
def at_most(k):
    left = count = 0
    for right, x in enumerate(nums):
        add(x)
        while exceeds(k):
            remove(nums[left])
            left += 1
        count += right - left + 1
    return count

return at_most(k) - at_most(k - 1)       # exactly k
```

**"Exactly K" is not monotonic, but "at most K" is**, so subtract two at-most counts (LC 1248). When the condition, such as "cost `<= k`", is monotonic itself, count directly (LC 3835).

## Template 5: Monotonic deque for window extremes

```python
from collections import deque

max_q = deque()                          # indices, values decreasing
for right, x in enumerate(nums):
    while max_q and nums[max_q[-1]] <= x:
        max_q.pop()                      # dominated by x, can never be the max
    max_q.append(right)
    left = right - k + 1                 # fixed size k; for variable windows the condition sets left
    if max_q[0] < left:
        max_q.popleft()                  # expired: outside the window
    if left >= 0:
        res.append(nums[max_q[0]])       # window maximum
```

Keep the two conditions separate: the **back** drops dominated indices, the **front** drops expired ones. For both max and min, use two deques (LC 3835).

## Key Parameters

- `left`, `right`: the window is `[left, right]`, length `right - left + 1`.
- For fixed size, the outgoing element is `nums[right - k]` and the window is full when `right >= k - 1`.
- Counting hash maps: delete keys that drop to 0 so `len()` means "number of distinct values".

## Complexity

Each element enters and leaves the window once: time `O(n)`. With a hash map, space is `O(distinct values in the window)`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Wrong variable for the outgoing element**: after copy-pasting, the left element was checked against the right element's expected value (LC 1888).
- **Discarded elements left in the counts**: an arrival the rule discards should not be subtracted again when it leaves the window (LC 3679).
- **Missing the first window**: updating the answer only when `i - k >= 0` skips the window ending at `i == k - 1` (LC 3694).
- **Using the total sum when the problem wants the sum of distinct values** (LC 3795).
- **Not checking that the window length equals the target** (LC 2953).
- **Powers without a modulo**: recomputing `power ** k` as a big integer each step, TLE (LC 2156).
- **Mixing "expired" and "dominated" into one deque condition** (LC 3835).

## Related LeetCode

- `LC 1248` Count Number of Nice Subarrays
- `LC 1493` Longest Subarray of 1's After Deleting One Element
- `LC 2841` Maximum Sum of Almost Unique Subarray
- `LC 2461` Maximum Sum of Distinct Subarrays With Length K
- `LC 3679` Minimum Discards to Balance Inventory
- `LC 1423` Maximum Points You Can Obtain from Cards
- `LC 3694` Distinct Points Reachable After Substring Removal
- `LC 2134` Minimum Swaps to Group All 1's Together II
- `LC 3795` Minimum Subarray Length With Distinct Sum At Least K
- `LC 1888` Minimum Number of Flips to Make the Binary String Alternating
- `LC 2653` Sliding Subarray Beauty
- `LC 2953` Count Complete Substrings
- `LC 2269` Find the K-Beauty of a Number
- `LC 2156` Find Substring With Given Hash Value
- `LC 3835` Count Subarrays With Cost Less Than or Equal to K
- `LC 1016` Binary String With Substrings Representing 1 To N
- `LC 220` Contains Duplicate III
- `LC 2024` Maximize the Confusion of an Exam
- `LC 1208` Get Equal Substrings Within Budget
- `LC 3634` Minimum Removals to Balance Array
- `LC 3090` Maximum Length Substring With Two Occurrences
- `LC 2958` Length of Longest Subarray With at Most K Frequency
- `LC 2831` Find the Longest Equal Subarray
- `LC 2779` Maximum Beauty of an Array After Applying Operation
- `LC 2271` Maximum White Tiles Covered by a Carpet
- `LC 1838` Frequency of the Most Frequent Element
- `LC 2730` Find the Longest Semi-Repetitive Substring
- `LC 2516` Take K of Each Character From Left and Right
- `LC 2106` Maximum Fruits Harvested After at Most K Steps
- `LC 2555` Maximize Win From Two Segments
- `LC 2009` Minimum Number of Operations to Make Array Continuous
- `LC 2781` Length of the Longest Valid Substring
- `LC 3413` Maximum Coins From K Consecutive Bags
- `LC 395` Longest Substring with At Least K Repeating Characters
- `LC 1763` Longest Nice Substring
- `LC 2904` Shortest and Lexicographically Smallest Beautiful String
- `LC 2968` Apply Operations to Maximize Frequency Score
- `LC 3258` Count Substrings That Satisfy K-Constraint I
- `LC 1040` Moving Stones Until Consecutive II
- `LC 2302` Count Subarrays With Score Less Than K
- `LC 2875` Minimum Size Subarray in Infinite Array
- `LC 1234` Replace the Substring for Balanced String
