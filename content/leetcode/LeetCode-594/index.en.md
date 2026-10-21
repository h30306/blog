---
title: "LeetCode 594: Longest Harmonious Subsequence"
summary: "LeetCode 594 note: subsequences need not be contiguous, so just count; for each x add the counts of x and x + 1"
description: "LeetCode 594 record from 2022-08-28"
date: 2022-08-28
tags: ["easy", "array", "hash-table", "sliding-window", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-28
- Submissions: Accepted ×2 → Runtime Error

## Approach

Subsequences are not contiguous, so order does not matter: just count ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1). A harmonious subsequence holds only `x` and `x + 1`; for each `x` with `x + 1` present, a candidate is `cnt[x] + cnt[x + 1]`. Checking `x + 1` suffices because the `x - 1` pairing is handled at `x - 1`.

## My Solution

```python
class Solution:
    def findLHS(self, nums: List[int]) -> int:
        cnt = Counter(nums)
        return max((cnt[x] + cnt[x + 1] for x in cnt if x + 1 in cnt), default=0)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- A single distinct value is not harmonious; return 0.

## Interview Explanation

Since a subsequence need not be contiguous I just count, and for each value x with x + 1 present I update the answer with their combined count. Time `O(n)`.
