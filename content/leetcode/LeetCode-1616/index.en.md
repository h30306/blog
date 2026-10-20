---
title: "LeetCode 1616: Split Two Strings to Make Palindrome"
summary: "LeetCode 1616 note: greedily match a's prefix against b's suffix from the outside in; the leftover middle must be a palindrome entirely within a or b, and both directions need checking"
description: "LeetCode 1616 record from 2026-01-24"
date: 2026-01-24
tags: ["medium", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-24
- Submissions: WA → TLE ×2 → WA → AC → WA → AC

## Approach

Split `a` and `b` at the same index and check whether `a prefix + b suffix` or `b prefix + a suffix` is a palindrome.

For `a prefix + b suffix`, use converging pointers: the left pointer walks right on `a` and the right pointer walks left on `b`, **continuing while `a[left] == b[right]`**. This outer part can always be formed by "a's prefix matched with b's suffix".

When they stop, the unmatched middle `[left, right]` **must come entirely from one string** (the split point falls inside it), so either `a[left..right]` or `b[left..right]` must itself be a palindrome.

The other direction, `b prefix + a suffix`, is checked the same way.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1, WA | Checked only `a prefix + b suffix`, with split points only up to `n - 1`. For `a = "aa"`, `b = "ab"`, taking all of `a` is a palindrome, so the answer is `True`; this version returned `False` |
| Two TLEs | Added the other direction and split points `0..n`, but rebuilt and checked a string for every split: `O(n^2)` |
| Attempt 4, WA | Switched to greedy matching plus a middle check, but `is_palindrome` used `i -= 1` and `j += 1`, moving outward and going out of range |
| Attempt 6, WA | The last line was `check(a, b) or check(a, b)`; the second should be `check(b, a)`. For `a = "aaab"`, `b = "babb"`, b's prefix `"ba"` plus a's suffix `"ab"` gives `"baab"`, so the answer is `True`; checking one direction only returned `False` |

## Solution

```python
class Solution:
    def checkPalindromeFormation(self, a: str, b: str) -> bool:
        def is_palindrome(s: str, i: int, j: int) -> bool:
            while i < j:
                if s[i] != s[j]:
                    return False
                i += 1
                j -= 1
            return True

        def check(x: str, y: str) -> bool:            # x's prefix + y's suffix
            left, right = 0, len(x) - 1
            while left < right and x[left] == y[right]:
                left += 1
                right -= 1
            return is_palindrome(x, left, right) or is_palindrome(y, left, right)

        return check(a, b) or check(b, a)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Checking only one direction.
- Rebuilding a string for every split point: `O(n^2)`.
- Moving the palindrome-check pointers outward.
- Calling the same function twice without swapping the arguments.

## Interview Explanation

For a's prefix plus b's suffix, I move converging pointers from the outside in while `a[left]` equals `b[right]`. Where they stop, the remaining middle must come entirely from one string, so I check whether it is a palindrome within `a` or within `b`. The other direction swaps `a` and `b`. Time `O(n)`.
