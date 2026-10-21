---
title: "Two Pointers"
summary: "Converging pointers, one pointer per sequence, skipping blanks to compare positions, counting pairs after sorting, and the in-place write pointer"
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

Sliding windows have their own post; of the same-direction pattern this post covers only the write pointer (Template 5), used to delete, deduplicate or move elements in place.

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

- **Skipping characters that do not count** (LC 125, 917, 345): with `if / elif / else` move one side at a time, and compare or swap only when both rest on valid characters.
- **A palindrome after deleting one character** (LC 680): at the first mismatch the only options are deleting the left or the right; check each remaining range.
- **Greedily moving the shorter side** (LC 11): the area is limited by the shorter side, so moving the taller one can never help.

### Extension: k-Sum (LC 15, 16, 18)

Sort, fix the first `k - 2` numbers, and use converging pointers for the last two, in `O(n^(k-1))`. Deduplicate in three places:

```python
nums.sort()
for i in range(n):
    if i > 0 and nums[i] == nums[i - 1]:
        continue                       # dedup the first number
    l, r = i + 1, n - 1                # start at i + 1, not 0
    while l < r:
        s = nums[i] + nums[l] + nums[r]
        if s < target:
            l += 1
        elif s > target:
            r -= 1
        else:
            res.append([nums[i], nums[l], nums[r]])
            l += 1
            while l < r and nums[l] == nums[l - 1]:
                l += 1                 # skip equal values after a match
            r -= 1
```

4Sum adds a `j` loop whose dedup condition is `j > i + 1`; 3Sum Closest needs no dedup and compares `abs(s - target)` instead.

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

## Template 5: Write Pointer (In-Place Overwrite)

`k` points at the next slot to write and `i` scans the whole array. `nums[:k]` is always the processed, kept prefix, and since `k <= i` a write never clobbers an unread value:

```python
k = 0
for x in nums:
    if keep(x):
        nums[k] = x
        k += 1
return k                               # nums[:k] is the answer
```

| Problem | Keep when |
|---|---|
| LC 27 Remove Element | `x != val` |
| LC 26 Remove Duplicates | `k == 0 or x != nums[k - 1]` |
| LC 80 keep at most two | `k < 2 or x != nums[k - 2]` |
| LC 283 Move Zeroes | `x != 0`, swapping so zeros move back |
| LC 905 Sort Array By Parity | `x` is even, swapping |

- Compare with the **already written** `nums[k - 1]` or `nums[k - 2]`, not the original `nums[i - 1]`, which may have been overwritten (LC 80).
- When the output grows (LC 1089 Duplicate Zeros), write **back to front** after computing each element's final position, so unprocessed values are not overwritten.
- For three categories (LC 75 Sort Colors) use three pointers: 0s before `low`, 2s after `high`; after swapping with `high`, do not advance `i`, because the incoming value is unchecked.

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
- **Treating only letters as valid**: alphanumeric includes digits (LC 125).
- **Counting mismatched pairs**: deleting a character shifts every later pairing, so actually delete and recheck (LC 680).
- **Starting both pointers at 0**: converging `while left < right` never runs (LC 917).
- **Reversing only the first block**, or skipping a final block shorter than `k` (LC 541).
- **`split(" ")` produces empty strings for consecutive spaces**; use `split()` (LC 151).
- **Looping only while both pointers are in range**: when one runs out, the rest of the other is never checked (LC 925).
- **Comparing with the original `nums[i - 2]`**: the write pointer may have overwritten it (LC 80).
- **Advancing the write pointer outside the `if`**: advance only after writing (LC 283).
- **Not skipping equal values after a k-sum match**, adding the same answer repeatedly; starting the second number at 0 is wrong too (LC 15).
- **4Sum's second-level dedup written as `j > 0`**, skipping valid answers (LC 18).
- **Advancing `i` after swapping with `high`**: the incoming value goes unchecked (LC 75).

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
- `LC 125` Valid Palindrome
- `LC 680` Valid Palindrome II
- `LC 344` Reverse String
- `LC 541` Reverse String II
- `LC 917` Reverse Only Letters
- `LC 345` Reverse Vowels of a String
- `LC 151` Reverse Words in a String
- `LC 557` Reverse Words in a String III
- `LC 832` Flipping an Image
- `LC 942` DI String Match
- `LC 165` Compare Version Numbers
- `LC 925` Long Pressed Name
- `LC 11` Container With Most Water
- `LC 15` 3Sum
- `LC 16` 3Sum Closest
- `LC 18` 4Sum
- `LC 977` Squares of a Sorted Array
- `LC 455` Assign Cookies
- `LC 922` Sort Array By Parity II
- `LC 189` Rotate Array
- `LC 31` Next Permutation
- `LC 3069` Distribute Elements Into Two Arrays I
- `LC 26` Remove Duplicates from Sorted Array
- `LC 27` Remove Element
- `LC 80` Remove Duplicates from Sorted Array II
- `LC 283` Move Zeroes
- `LC 905` Sort Array By Parity
- `LC 1089` Duplicate Zeros
- `LC 75` Sort Colors
