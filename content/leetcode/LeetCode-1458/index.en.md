---
title: "LeetCode 1458: Max Dot Product of Two Subsequences"
summary: "LeetCode 1458 note: a two-prefix DP; dp[i][j] either pairs nums1[i] with nums2[j] (extending dp[i-1][j-1] or starting fresh) or skips one of them"
description: "LeetCode 1458 record from 2026-01-11"
date: 2026-01-11
tags: ["hard", "dynamic-programming", "longest-common-subsequence", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-11
- Submissions: Wrong Answer → Accepted

## Approach

A two-prefix DP like LCS (see [String DP]({{< relref "/algorithm/String-DP" >}})). `dp[i][j]` = the best dot product of non-empty subsequences of `nums1[:i]` and `nums2[:j]`:

- **Pair `nums1[i-1]` with `nums2[j-1]`**: with `p = nums1[i-1] × nums2[j-1]`, either extend the earlier best, `dp[i-1][j-1] + p`, or start fresh with `p` (better when everything earlier is negative).
- **Skip `nums1[i-1]`**: `dp[i-1][j]`.
- **Skip `nums2[j-1]`**: `dp[i][j-1]`.

Subsequences cannot be empty, so the base is negative infinity, not 0. That is also why "start fresh" is needed: if every product is negative, the answer is the largest negative, not 0.

## My Attempts

Attempt 1 had only "pair" and `dp[i-1][j-1]` (skip both), **without the transitions that skip just one side**. Then `dp[i][j]` only saw both sides advancing together, so `nums1[i]` could not pair with an earlier element of `nums2` and continue. For `nums1 = [3, 1, 3]`, `nums2 = [3, 4]`, `3 × 3 + 3 × 4 = 21`; it returned 15.

## Solution

```python
class Solution:
    def maxDotProduct(self, nums1: List[int], nums2: List[int]) -> int:
        n, m = len(nums1), len(nums2)
        NEG = float("-inf")
        dp = [[NEG] * (m + 1) for _ in range(n + 1)]   # subsequences cannot be empty
        for i in range(1, n + 1):
            for j in range(1, m + 1):
                p = nums1[i - 1] * nums2[j - 1]
                dp[i][j] = max(
                    p,                             # start with this pair
                    dp[i - 1][j - 1] + p,          # extend the earlier best
                    dp[i - 1][j],                  # skip nums1[i-1]
                    dp[i][j - 1],                  # skip nums2[j-1]
                )
        return dp[n][m]
```

## Complexity

Time `O(nm)`, space `O(nm)`.

## Mistakes to Avoid

- Missing the "skip just one side" transitions.
- A base of 0: subsequences cannot be empty, and with all negatives the answer is negative.

## Interview Explanation

This is a two-prefix DP. `dp[i][j]` can pair the two current elements, extending the earlier best or starting fresh, or skip the current element on either side. Since subsequences cannot be empty, the base is negative infinity, and "start fresh" handles the all-negative case. Time `O(nm)`.
