---
title: "LeetCode 922: Sort Array By Parity II"
summary: "LeetCode 922 note: pointers i over even slots and j over odd slots, each stepping by two; when slot i holds an odd number, move j to a misplaced even and swap"
description: "LeetCode 922 record from 2022-09-25"
date: 2022-09-25
tags: ["easy", "array", "two-pointers", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-25
- Submissions: Runtime Error ×10 → Output Limit Exceeded → Accepted ×3 → Runtime Error → Accepted ×2

## Approach

`i` visits only even slots and `j` only odd slots, both stepping by two ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 2). When `nums[i]` is odd it is misplaced; advance `j` to an odd slot holding an even number (also misplaced) and swap. Half the numbers are even, so one always exists.

## My Attempts

This took 17 submissions, the first ten all REs: the pointers' bounds were off and ran past the end, e.g. `j` overran on `[9, 8]` (IndexError); one version left a debug `print` and hit Output Limit Exceeded.

## Solution

```python
class Solution:
    def sortArrayByParityII(self, nums: List[int]) -> List[int]:
        j = 1
        for i in range(0, len(nums), 2):
            if nums[i] % 2:                              # 偶數位置放了奇數
                while nums[j] % 2:
                    j += 2
                nums[i], nums[j] = nums[j], nums[i]
        return nums
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Both pointers step by two.
- `j` never resets; earlier odd slots are already correct.

## Interview Explanation

`i` walks even slots and `j` odd slots; when `i` finds an odd number, `j` advances to a misplaced even and they swap. Each pointer only moves forward, `O(n)`.
