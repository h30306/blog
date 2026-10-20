---
title: "LeetCode 2131: Longest Palindrome by Concatenating Two Letter Words"
summary: "LeetCode 2131 note: pair each word with its reverse on both sides; self-palindromes also pair with each other, and only one leftover can sit in the middle"
description: "LeetCode 2131 record from 2025-08-21"
date: 2025-08-21
tags: ["medium", "greedy", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-21
- Submissions: Wrong Answer → Accepted

## Approach

A palindrome is symmetric, so each word needs its reverse on the other side:

- `"ab"` pairs with `"ba"`, one on each side, +4.
- A self-palindrome like `"cc"` **can pair with another `"cc"`**; one leftover can go in the middle for +2, and only one word in total can.

## My Attempts

Attempt 1 treated every self-palindrome as a middle candidate and skipped it. For `["cc", "cc"]` the answer is 4 (`"cccc"`); it returned 2.

Pairing every word with its reverse first (the reverse of `"cc"` is itself) and adding 2 if any palindrome is left over passed.

## Solution

```python
class Solution:
    def longestPalindrome(self, words: List[str]) -> int:
        cnt = Counter(words)
        res, mid = 0, False
        for w, c in cnt.items():
            r = w[::-1]
            if w == r:
                res += c // 2 * 4          # pair up on both sides
                mid |= c % 2 == 1          # one leftover can go in the middle
            elif w < r:                    # count each pair once
                res += min(c, cnt[r]) * 4
        return res + (2 if mid else 0)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Self-palindromes can pair with each other; they are not all middle-only.
- At most one word goes in the middle.
- `w < r` keeps `"ab"` and `"ba"` from being counted twice.

## Interview Explanation

I count each word. A non-palindrome pairs with its reverse, using the smaller count; a self-palindrome pairs with itself, and an odd count leaves one for the middle. Each pair adds 4 and the middle adds 2. Time `O(n)`.
