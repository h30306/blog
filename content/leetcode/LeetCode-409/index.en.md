---
title: "LeetCode 409: Longest Palindrome"
summary: "LeetCode 409 note: use an even number of each character on the two sides, plus one in the middle if any count is odd"
description: "LeetCode 409 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "hash-table", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Wrong Answer ×4 → Accepted → Wrong Answer → Accepted

## Approach

A palindrome is symmetric, so each character contributes at most `v // 2 * 2` (an even count). Leftover singles from odd counts can fill only **one** center slot: if any count is odd, add 1 ([Greedy]({{< relref "/algorithm/Greedy" >}}), counting with [Hash Table]({{< relref "/algorithm/Hash-Table" >}})). Case matters.

## My Attempts

In 2022 it failed four times, always on odd counts:

- Attempt 1 used `v / 2` (a float) and added only half of even counts: `"aa"` returned `1.0`.
- Attempt 2 added **only 1** for an odd count, ignoring its usable `v - 1`: `"bbb"` should be 3; it returned 1.
- Attempt 3 added `v - 1` but **forgot the center 1**: `"bbb"` returned 2; attempt 4 added `v` plus 1, giving 4.

The 2026 rewrite had the right logic but wrote `return res + 1 if plus_one else 0`; **the conditional expression binds looser than `+`**, so it meant `(res + 1) if plus_one else 0` and returned 0 with no odd counts: `"aa"` returned 0.

## Solution

```python
class Solution:
    def longestPalindrome(self, s: str) -> int:
        cnt = Counter(s)
        res = sum(v // 2 * 2 for v in cnt.values())
        return res + (1 if any(v % 2 for v in cnt.values()) else 0)
```

## Complexity

Time `O(n)`, space `O(k)`.

## Mistakes to Avoid

- An odd count still contributes `v - 1`, not just one center character.
- `res + 1 if odd else 0` parses as `(res + 1) if odd else 0`; add parentheses.
- `v / 2` is a float; use `//`.

## Interview Explanation

I count characters, use an even number of each on the two sides, and add one center character if any count is odd. Time `O(n)`.
