---
title: "LeetCode 1869: Longer Contiguous Segments of Ones than Zeros"
summary: "LeetCode 1869 note: find the longest run of 1s and of 0s and compare; split does it in one line"
description: "LeetCode 1869 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Wrong Answer ×2 → Accepted ×2

## Approach

Splitting on `'0'` leaves runs of 1s, so the longest piece is the longest run of 1s; splitting on `'1'` likewise gives 0s. The 1s must be **strictly** longer.

## My Attempts

The first two counted runs by hand but tested `i == 1`, **and a string character never equals the integer 1**, so every character counted as a 0: `"1"` returned `False`. Attempt 1 also skipped updating the final run after the loop. A one-line `split` version passed.

## Solution

```python
class Solution:
    def checkZeroOnes(self, s: str) -> bool:
        return max(map(len, s.split("0"))) > max(map(len, s.split("1")))
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The characters are `'1'`, not the integer `1`.
- When counting runs by hand, update once more after the loop for the final run.

## Interview Explanation

Splitting on 0 gives runs of 1s and splitting on 1 gives runs of 0s; I compare their longest pieces. Time `O(n)`.
