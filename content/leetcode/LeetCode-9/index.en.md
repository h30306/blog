---
title: "LeetCode 9: Palindrome Number"
summary: "LeetCode 9 note: negatives are never palindromes; without strings, reverse the second half of the digits and compare it with the first half"
description: "LeetCode 9 record from 2019-09-17"
date: 2019-09-17
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2019-09-17
- Submissions: Accepted → Wrong Answer ×2 → Accepted → Runtime Error ×2 → Accepted ×2 → Runtime Error ×2 → Accepted ×3

## Approach

Negatives carry a `-` and are never palindromes; positive numbers ending in 0 are not either (none starts with 0). The follow-up forbids strings: peel the second half's digits with `% 10` and `// 10` into a reversed number ([Math]({{< relref "/algorithm/Math" >}}) Template 5) until it reaches the remaining number. With an even digit count the two are equal; with an odd count the middle digit sits in `rev`, so compare `rev // 10`.

## My Attempts

- The first 2019 attempt passed by reversing the string. A rewrite the next day returned `True` for negatives, **the opposite**: `-6` returned `True`.
- In 2022-05 I tried comparing the two halves but computed the midpoint with `/`, **a float that cannot be a slice index** (TypeError), then went back to string reversal.

## Solution

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0 or (x % 10 == 0 and x != 0):
            return False
        rev = 0
        while x > rev:
            rev = rev * 10 + x % 10
            x //= 10
        return x == rev or x == rev // 10
```

## Complexity

Time `O(log x)`, space `O(1)`.

## Mistakes to Avoid

- Negatives return `False`.
- Rule out positive numbers ending in 0 first, or `10` would pass.
- `/` is float division and cannot be an index.

## Interview Explanation

I rule out negatives and positives ending in 0, reverse the second half of the digits until the reversed part catches up, then compare, dropping the middle digit for odd lengths. Time `O(log x)` without strings.
