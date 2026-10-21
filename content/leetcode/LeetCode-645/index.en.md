---
title: "LeetCode 645: Set Mismatch"
summary: "LeetCode 645 note: use sums: missing = sum of 1..n - sum of the set, duplicate = array sum - sum of the set"
description: "LeetCode 645 record from 2022-08-29"
date: 2022-08-29
tags: ["easy", "array", "hash-table", "bit-manipulation", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-29
- Submissions: Runtime Error → Wrong Answer ×5 → Runtime Error ×2 → Wrong Answer ×6 → Runtime Error → Accepted ×2

## Approach

The array should be `1..n` with one number duplicated and one missing. `set(nums)` lacks `missing`: `missing = n(n + 1) / 2 - sum(set)`; the array sum exceeds the set's by `duplicate`: `duplicate = sum(nums) - sum(set)`. No sorting or position comparison is needed ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). For `O(1)` space, XOR everything with `1..n` to get `dup ^ miss`, then split by its lowest set bit ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})).

## My Attempts

This took 17 submissions, most of them comparing `nums[i]` with `i + 1`:

- The array is **unsorted**, so comparing `nums[i]` with `nums[i - 1]` or with `i + 1` means nothing: `[2, 2]` returned `[2, 1, 2]` or `[1, 2]`, and several versions forgot the `return`.
- Sorting and then looking for "value differs from position" **marks more than one spot**: `[3, 3, 1]` sorts to `[1, 3, 3]`, with both later cells off, producing results like `[3, 2, 3, 3]`.
- Sorting to find the duplicate plus a set difference for the missing number finally passed, and I later rewrote it with sums.

## Solution

```python
class Solution:
    def findErrorNums(self, nums: List[int]) -> List[int]:
        n = len(nums)
        uniq = sum(set(nums))
        return [sum(nums) - uniq, n * (n + 1) // 2 - uniq]
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The array is unsorted, so `nums[i]` cannot be compared with `i + 1` directly.
- Even after sorting, more than one position is off: everything between the duplicate and the missing number shifts.
- Return `[duplicate, missing]` in that order.

## Interview Explanation

The set lacks the missing number and the array sum exceeds the set sum by the duplicate, so missing is the 1..n total minus the set sum and duplicate is the array sum minus the set sum. Time `O(n)`.
