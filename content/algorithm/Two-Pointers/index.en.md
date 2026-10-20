---
title: "Two Pointers"
summary: "Converging pointers, one pointer per sequence, skipping blanks to compare positions, and counting pairs after sorting"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["two-pointers", "string", "sorting"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Two pointers scan with two indices at once, deciding at each step which one to move, which turns an `O(n^2)` all-pairs comparison into `O(n)`.

The key is that **each pointer moves in only one direction**: once you can show a position will never be needed again, you can safely move past it.

Three common forms:

| Form | How the pointers move | Examples |
|---|---|---|
| Converging | one from the start, one from the end, toward the middle | palindromes, reversal, pairs after sorting |
| One per sequence | each advances along its own sequence | merging, comparison, subsequence checks |
| Same direction, different speeds | both start at the front | sliding windows, deduplication |

Sliding windows have their own post; this one covers the first two.

## Template 1: Converging Pointers

```python
left, right = 0, len(s) - 1
while left < right:
    if condition(s[left], s[right]):
        handle()
    left += 1
    right -= 1
```

- **Checking or forming a palindrome** (LC 2697): when the ends differ, set both to the smaller character for the lexicographically smallest result.
- **Reversing while skipping some characters** (LC 3823): each side first skips to a character to process, then they swap.
- **Forming a palindrome from two strings** (LC 1616): match greedily from the outside in; when matching stops, the remaining middle must come entirely from one string and be a palindrome on its own.

Python strings are immutable, so swapping characters needs `list(s)` first and `"".join(...)` at the end (LC 3794).

## Template 2: One Pointer per Sequence

```python
i = j = 0
while i < len(a) and j < len(b):
    if a[i] == b[j]:
        ...
        i += 1
        j += 1
    elif a[i] < b[j]:
        i += 1
    else:
        j += 1
# handle whatever is left
```

- **Merging two sorted sequences** (LC 2570): the same as merge sort's merge.
- **Finding a common element** (LC 2540): advance the smaller side.
- **Subsequence check** (LC 522): advance both on a match, otherwise only the longer string.
- **Comparing runs** (LC 809): count the length of the current run of identical characters on each side, then compare lengths.

### Key Parameters:

- **After the loop, confirm that both sides are exhausted**: checking only one side ignores leftover characters on the other (LC 809).
- **Do not read a side that has run out**: check the index before reading (the Runtime Error in LC 2337).

## Template 3: Skipping Blanks to Compare Piece Positions

`L` only moves left, `R` only moves right, and `_` or `X` is empty (LC 2337, 777):

1. With blanks removed, both strings must have the same pieces in the same order (pieces cannot pass each other).
2. For each pair of matching pieces: an `L`'s start position must be `>=` its target position; an `R`'s must be `<=`.

```python
i = j = 0
while True:
    while i < n and start[i] == "_":
        i += 1
    while j < n and target[j] == "_":
        j += 1
    if i == n or j == n:
        return i == n and j == n
    if start[i] != target[j]:
        return False
    if start[i] == "L" and i < j or start[i] == "R" and i > j:
        return False
    i += 1
    j += 1
```

Comparing character counts (`Counter`) is not enough: both order and direction matter (the first WA in LC 777).

## Template 4: Counting Pairs after Sorting

After sorting, fix one end and use a pointer or bisect to find the matching range at the other:

```python
nums.sort()
left, right = 0, len(nums) - 1
while left < right:
    if nums[left] + nums[right] > target:
        right -= 1                    # too large; only the largest can shrink
    else:
        count += right - left         # left pairs with every index in (left, right]
        left += 1
```

This is the sorted version of Two Sum and the skeleton of many "count pairs" problems.

## Complexity

The two-pointer scan is `O(n)`; with sorting, `O(n log n)`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Forgetting to move a pointer inside the `while` loop**: an infinite loop and TLE (LC 1768).
- **Writing `right += 1`**: in converging pointers, the right pointer decreases (LC 1750).
- **Emitting overlapping ranges twice**: keep a pointer to how far output has already gone (LC 2200).
- **Concluding from a single next element**: LC 1826 needs the whole remaining tail compared, plus handling the case where both explanations fit.
- **Calling the same check twice**: `check(a, b) or check(a, b)`, where the second should be `check(b, a)` (LC 1616).
- **Comparing counts but not order** (LC 777).

## Related LeetCode

- `LC 1768` Merge Strings Alternately
- `LC 2570` Merge Two 2D Arrays by Summing Values
- `LC 2540` Minimum Common Value
- `LC 2441` Largest Positive Integer That Exists With Its Negative
- `LC 3794` Reverse String Prefix
- `LC 3823` Reverse Letters Then Special Characters in a String
- `LC 3643` Flip Square Submatrix Vertically
- `LC 3750` Minimum Number of Flips to Reverse Binary String
- `LC 3884` First Matching Character From Both Ends
- `LC 2697` Lexicographically Smallest Palindrome
- `LC 1750` Minimum Length of String After Deleting Similar Ends
- `LC 1616` Split Two Strings to Make Palindrome
- `LC 2200` Find All K-Distant Indices in an Array
- `LC 3775` Reverse Words With Same Vowel Count
- `LC 1826` Faulty Sensor
- `LC 522` Longest Uncommon Subsequence II
- `LC 809` Expressive Words
- `LC 2337` Move Pieces to Obtain a String
- `LC 777` Swap Adjacent in LR String
- `LC 2410` Maximum Matching of Players With Trainers
- `LC 3649` Number of Perfect Pairs
- `LC 825` Friends Of Appropriate Ages
- `LC 923` 3Sum With Multiplicity
- `LC 1782` Count Pairs Of Nodes
- `LC 948` Bag of Tokens
- `LC 2105` Watering Plants II
- `LC 1877` Minimize Maximum Pair Sum in Array
- `LC 1498` Number of Subsequences That Satisfy the Given Sum Condition
- `LC 1471` The k Strongest Values in an Array
- `LC 633` Sum of Square Numbers
- `LC 2563` Count the Number of Fair Pairs
- `LC 1574` Shortest Subarray to be Removed to Make Array Sorted
- `LC 2972` Count the Number of Incremovable Subarrays II
- `LC 2122` Recover the Original Array
- `LC 1989` Maximum Number of People That Can Be Caught in Tag
- `LC 3555` Smallest Subarray to Sort in Every Sliding Window
- `LC 581` Shortest Unsorted Continuous Subarray
- `LC 1793` Maximum Score of a Good Subarray
- `LC 986` Interval List Intersections
- `LC 244` Shortest Word Distance II
- `LC 1570` Dot Product of Two Sparse Vectors
- `LC 1229` Meeting Scheduler
- `LC 4026` Maximum Gap Between Stations
- `LC 2193` Minimum Number of Moves to Make Palindrome
- `LC 1842` Next Palindrome Using Same Digits
