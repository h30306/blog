---
title: "LeetCode 3960: Frequency Balance Subarray"
summary: "LeetCode 3960 note: n is only 1000, so fix the left end and extend right while maintaining value -> count and count -> how many; exactly two counts f and 2f means balanced"
description: "LeetCode 3960 record from 2026-06-18"
date: 2026-06-18
tags: ["medium", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-18
- Submissions: Wrong Answer → Accepted

## Approach

`n <= 1000`, so `O(n²)` is fine. Fix the left end and extend right; each new number changes `O(1)` counts ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 4):

- `cnt`: value -> count.
- `freq`: count -> how many values have it. When a value goes from `c` to `c + 1`, decrement `freq[c]` (deleting it at 0) and increment `freq[c + 1]`.

Balanced means a single value, or `freq` holding exactly two counts with the larger twice the smaller.

## My Attempts

Attempt 1 had an extra condition, `min(freq_map) in apperance_map`, **looking up a count in the value -> count table**; they mean different things. For `[2, 3, 2]`, 2 appears twice and 3 once, so the whole array works and the answer is 3; the smallest count, 1, is not a value in the array, so it returned 1. Removing the condition passed.

## Solution

```python
class Solution:
    def getLength(self, nums: List[int]) -> int:
        n, best = len(nums), 0
        for i in range(n):
            cnt, freq = {}, Counter()
            for j in range(i, n):
                c = cnt.get(nums[j], 0)
                if c:
                    freq[c] -= 1
                    if freq[c] == 0:
                        del freq[c]
                cnt[nums[j]] = c + 1
                freq[c + 1] += 1
                if len(cnt) == 1 or (len(freq) == 2 and max(freq) == 2 * min(freq)):
                    best = max(best, j - i + 1)
        return best
```

## Complexity

Time `O(n²)`, space `O(n)`. `max(freq)` and `min(freq)` only run when `len(freq) == 2`, so they are `O(1)`.

## Mistakes to Avoid

- Delete a count that reaches 0, or `len(freq)` is wrong.
- "Count" and "value" are different keys; do not mix them.

## Interview Explanation

With `n` only 1000, I fix the left end and extend right, tracking each value's count and how many values have each count; every new number updates just two of those. When there is a single value, or exactly two counts with one twice the other, I update the answer. Time `O(n²)`.
