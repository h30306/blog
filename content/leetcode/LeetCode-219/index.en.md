---
title: "LeetCode 219: Contains Duplicate II"
summary: "LeetCode 219 note: a hash map stores each value's last index; only the most recent occurrence needs a distance check"
description: "LeetCode 219 record from 2022-08-21"
date: 2022-08-21
tags: ["easy", "array", "hash-table", "sliding-window"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-21
- Submissions: Wrong Answer → Runtime Error → Wrong Answer ×2 → Accepted ×4

## Approach

A hash map keeps the **last** index of each value ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). At `nums[i]`, compare only with its previous occurrence: if the nearest one is farther than `k`, earlier ones are farther still. Equivalently, check for a duplicate inside a fixed window of length `k + 1` ([Sliding Window]({{< relref "/algorithm/Sliding-Window" >}}) Template 1).

## My Attempts

The first four versions stored every index of each value in a list and then compared:

- Attempt 1 built the map and returned nothing.
- Attempt 2 wrote `d.values` without parentheses (TypeError).
- Attempt 3 compared **the first and the last** occurrences, and a value seen once had distance 0, so it counted as a duplicate: `[3]`, `k = 2` returned `True`.
- Attempt 4 excluded single occurrences but still compared the ends: in `[0, 0, 0]` with `k = 1`, adjacent zeros are 1 apart so the answer is `True`, but the ends are 2 apart and it returned `False`.

Keeping only the last index passed.

## Solution

```python
class Solution:
    def containsNearbyDuplicate(self, nums: List[int], k: int) -> bool:
        last = {}
        for i, v in enumerate(nums):
            if v in last and i - last[v] <= k:
                return True
            last[v] = i
        return False
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Compare **consecutive** occurrences, not the first and the last.
- A value that appears once is not a duplicate.

## Interview Explanation

A hash map stores each value's previous index; on a repeat I check whether the distance is at most k and then update it. Only the nearest occurrence matters since earlier ones are farther. Time `O(n)`, space `O(n)`.
