---
title: "LeetCode 2231: Largest Number After Digit Swaps by Parity"
summary: "LeetCode 2231 note: odd digits swap only with odd digits and even with even; sort each group and refill each position with the largest digit of its parity"
description: "LeetCode 2231 record from 2022-11-22"
date: 2022-11-22
tags: ["easy", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-22
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Parity refers to **the digit's value**, not its position. Split the digits into odd and even groups, sort each descending (or use max-heaps, [Heap]({{< relref "/algorithm/Heap" >}})), then from left to right fill each odd-digit position with the largest remaining odd digit and each even-digit position with the largest remaining even digit.

## My Attempts

The first two grouped digits by **the index's parity** (`i % 2`) instead of the digit's: all four digits of `5575` are odd and can become `7555`, but one version returned nothing and the other the wrong value. Testing `int(s) % 2` passed.

## Solution

```python
class Solution:
    def largestInteger(self, num: int) -> int:
        digits = [int(c) for c in str(num)]
        odd = sorted((d for d in digits if d % 2), reverse=True)
        even = sorted((d for d in digits if d % 2 == 0), reverse=True)
        oi = ei = 0
        res = 0
        for d in digits:
            if d % 2:
                res = res * 10 + odd[oi]; oi += 1
            else:
                res = res * 10 + even[ei]; ei += 1
        return res
```

## Complexity

Time `O(d log d)` for `d` digits, space `O(d)`.

## Mistakes to Avoid

- Group by the digit's parity, not the index's.
- Return an integer.

## Interview Explanation

Odd digits swap only with odd and even with even, so I sort each group descending and, from left to right, give each position the largest remaining digit of its own parity.
