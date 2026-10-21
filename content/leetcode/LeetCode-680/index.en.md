---
title: "LeetCode 680: Valid Palindrome II"
summary: "LeetCode 680 note: at the first mismatch the only options are deleting the left or the right character; check whether either remainder is a palindrome"
description: "LeetCode 680 record from 2022-08-30"
date: 2022-08-30
tags: ["easy", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-30
- Submissions: Wrong Answer ×7 → Runtime Error ×2 → Time Limit Exceeded → Runtime Error ×3 → Wrong Answer → Runtime Error → Wrong Answer ×3 → Runtime Error → Wrong Answer → Accepted ×2

## Approach

Compare with two pointers moving inward ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1). At the first mismatch `s[l] != s[r]`, only one deletion is allowed, so there are two options: delete `s[l]` (check `s[l+1..r]`) or delete `s[r]` (check `s[l..r-1]`); either being a palindrome suffices. The part already compared is symmetric.

## My Attempts

This took 22 submissions. The early idea was "count mismatched pairs and fail beyond one", but deleting a character shifts all later pairings, so counting is wrong: `"bca"` has a single mismatched pair (`b` and `a`), yet neither deletion yields a palindrome, so the answer is `False`; those versions returned `True`. Attempt 1 also compared indices instead of characters.

## Solution

```python
class Solution:
    def validPalindrome(self, s: str) -> bool:
        def pal(l, r):
            while l < r:
                if s[l] != s[r]:
                    return False
                l, r = l + 1, r - 1
            return True
        l, r = 0, len(s) - 1
        while l < r:
            if s[l] != s[r]:
                return pal(l + 1, r) or pal(l, r - 1)
            l, r = l + 1, r - 1
        return True
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Counting mismatched pairs is not enough: deleting a character shifts every later pairing.

## Interview Explanation

Two pointers compare inward; at the first mismatch only deleting the left or the right remains, so I check whether either remaining range is a palindrome. Time `O(n)`, space `O(1)`.
