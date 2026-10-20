---
title: "LeetCode 2904: Shortest and Lexicographically Smallest Beautiful String"
summary: "LeetCode 2904 note: with exactly k ones in the window, also shrink away leading zeros to get the shortest beautiful substring ending at right; compare by length first, then lexicographically"
description: "LeetCode 2904 record from 2026-01-18"
date: 2026-01-18
tags: ["medium", "sliding-window", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-18
- Submissions: Wrong Answer → Accepted

## Approach

The shortest beautiful substring always **starts and ends with 1** (zeros at either end can be dropped).

Sliding window: add on the right, and shrink the left while there are more than `k` ones, or exactly `k` with a 0 at the left end. If exactly `k` ones remain, this is the shortest candidate ending at `right`.

Compare candidates **by length first, and lexicographically only on equal length**.

## My Attempts

Attempt 1 compared with `len(ans) > len(target) or ans > target`, replacing the answer whenever the candidate was lexicographically smaller, regardless of length. For `s = "1101"`, `k = 2`, the shortest is `"11"`, but `"101"` is lexicographically smaller than `"11"`, so it returned `"101"`.

## Solution

```python
class Solution:
    def shortestBeautifulSubstring(self, s: str, k: int) -> str:
        left = ones = 0
        ans = ""
        for right, c in enumerate(s):
            ones += c == "1"
            while ones > k or (ones == k and s[left] == "0"):
                ones -= s[left] == "1"
                left += 1
            if ones == k:
                cand = s[left:right + 1]
                if not ans or len(cand) < len(ans) or (len(cand) == len(ans) and cand < ans):
                    ans = cand
        return ans
```

## Complexity

Time `O(n^2)` (comparing candidates is up to `O(n)`), with `n <= 100`. Space `O(n)`.

## Mistakes to Avoid

- Comparing lexicographically without checking length first.
- `"101" < "11"`: strings compare character by character, not by length.

## Interview Explanation

The shortest beautiful substring starts and ends with 1. I slide a window, shrinking the left while there are more than `k` ones or exactly `k` with a leading 0; exactly `k` ones then gives the shortest candidate ending at the right end. Candidates compare by length first, and lexicographically only on ties.
