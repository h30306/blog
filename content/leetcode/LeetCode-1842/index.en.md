---
title: "LeetCode 1842: Next Palindrome Using Same Digits"
summary: "LeetCode 1842 note: a palindrome is determined by its left half and the middle digit stays put; take the next permutation of the left half and mirror it"
description: "LeetCode 1842 record from 2026-09-27"
date: 2026-09-27
tags: ["hard", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-27
- Submissions: Wrong Answer → Runtime Error → Accepted ×2

## Approach

A palindrome is fully determined by its **left half**; the right half is its mirror. For odd lengths, the middle digit is the only digit with an odd count, so it **can only sit in the middle** and never changes.

So "the smallest larger palindrome from the same digits" is "the next permutation of the left half", mirrored. If the left half is already the largest permutation, there is no answer: return `""`.

Next permutation:

1. From the right, find the first `i` with `half[i] < half[i + 1]`. If there is none, it is the largest permutation.
2. From the right, find the first `half[j] > half[i]` and swap `half[i]` and `half[j]`.
3. Reverse `half[i + 1:]` (converging pointers) to make that part as small as possible.

## My Attempts

1. **WA**: took the middle digit as `nums[n // 2 + 1]` instead of `nums[n // 2]`. For `num = "12321"` the answer is `"21312"`; using `2` as the middle returned `"21212"`, with different digits.
2. **RE**: fixed the middle, but with `n == 1` the left half is empty and reading `left[-1]` went out of range, e.g. `num = "3"`.
3. **AC**: special-cased `n == 1` to return `""`.

## Solution

```python
class Solution:
    def nextPalindrome(self, num: str) -> str:
        n = len(num)
        half = list(num[:n // 2])

        i = len(half) - 2
        while i >= 0 and half[i] >= half[i + 1]:
            i -= 1
        if i < 0:
            return ""                              # left half is the largest permutation (incl. n == 1)
        j = len(half) - 1
        while half[j] <= half[i]:
            j -= 1
        half[i], half[j] = half[j], half[i]

        lo, hi = i + 1, len(half) - 1              # reverse the suffix
        while lo < hi:
            half[lo], half[hi] = half[hi], half[lo]
            lo += 1
            hi -= 1

        left = "".join(half)
        mid = num[n // 2] if n % 2 else ""
        return left + mid + left[::-1]
```

`i` starts at `len(half) - 2`, so for an empty or one-digit left half the loop never runs and `i < 0`, with no separate `n == 1` check.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The middle digit is at `n // 2`.
- An empty (`n == 1`) or one-digit left half has no next permutation.
- Next permutation ends by reversing the suffix, not sorting it (reversing suffices because that part is decreasing).

## Interview Explanation

A palindrome is determined by its left half, and for odd lengths the middle digit has to stay in the middle. So the smallest larger palindrome is the next permutation of the left half, mirrored. Next permutation finds the first dip from the right, swaps it with the first larger digit from the right, and reverses the suffix with converging pointers. With no next permutation, return an empty string. Time `O(n)`.
