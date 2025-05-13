---
title: "Next Permutation"
summary: "Introduction to Next Permutation"
description: "Algorithm Learning"
date: 2025-04-13
tags: ["blog", "algorithm", "next permutation"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

The **Next Permutation** algorithm is used to generate the next lexicographically greater permutation of a given sequence. If no such permutation exists (i.e., the sequence is the largest possible), it rearranges the sequence into its smallest (i.e., sorted in ascending order).

This algorithm is commonly used in problems involving permutation generation, string manipulation, or finding the next configuration in a state space.

## Core Idea

The goal is to find the next permutation in lexicographic (dictionary) order. The core steps are:

1. **Scan from right to left**, and find the **first index `i`** such that `nums[i] < nums[i + 1]`. This is the **pivot** point.
2. **Find the smallest index `j` > `i`** such that `nums[j] > nums[i]`.
3. **Swap** `nums[i]` and `nums[j]`.
4. **Reverse** the subarray `nums[i + 1:]` to get the next smallest configuration.

If no such `i` exists (i.e., the array is in descending order), then the current permutation is the last one. In that case, simply reverse the entire array to get the first permutation.

## Time Complexity

The **Next Permutation** algorithm has the following time complexity characteristics:

- **Step 1 (Find the pivot)**:  
  We scan from right to left to find the first decreasing element — this takes **O(n)** in the worst case.

- **Step 2 (Find the swap index)**:  
  Another linear scan from the end to the pivot — also **O(n)** in the worst case.

- **Step 3 (Swap)**:  
  A single constant-time operation — **O(1)**.

- **Step 4 (Reverse the suffix)**:  
  Reversing the tail of the array from `i + 1` to the end — worst-case **O(n)**.

---

### Overall Time Complexity:

```
O(n)
```

Where `n` is the length of the input array.

---

### Space Complexity:

```
O(1)
```

The algorithm performs in-place swaps and reversals without using extra space.



## Template

```python
def next_permutation(nums: List[int]) -> None:
    n = len(nums)
    i = n - 2

    # Step 1: Find first decreasing element from the right
    while i >= 0 and nums[i] >= nums[i + 1]:
        i -= 1

    if i >= 0:
        # Step 2: Find element just greater than nums[i]
        j = n - 1
        while nums[j] <= nums[i]:
            j -= 1
        # Step 3: Swap
        nums[i], nums[j] = nums[j], nums[i]

    # Step 4: Reverse the tail
    nums[i + 1:] = reversed(nums[i + 1:])
```
### Explanation of the key parameters:

- `i`: Index of the pivot — the first element from the right that breaks the decreasing trend.

- `j`: The element just greater than `nums[i]` — to be swapped in.

- `nums[i + 1:]`: The tail of the array — must be reversed to form the smallest possible suffix.

## Examples

## LeetCode