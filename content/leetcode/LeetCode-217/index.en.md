---
title: "LeetCode 217: Contains Duplicate"
summary: "LeetCode 217 note: if converting to a set shortens the array, there is a duplicate"
description: "LeetCode 217 record from 2022-08-21"
date: 2022-08-21
tags: ["easy", "array", "hash-table", "sorting"]
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
- Submissions: Wrong Answer → Accepted → Wrong Answer → Accepted ×4

## Approach

`set(nums)` drops duplicates, so a shorter length means a repeat ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). To stop early, add elements to a set while scanning and return `True` on the first one already present.

## My Attempts

In both 2022-08 and 2022-10 I wrote `len(set(nums)) == len(nums)`, **the exact opposite**, returning `True` when there is no duplicate. `!=` passed.

## Solution

```python
class Solution:
    def containsDuplicate(self, nums: List[int]) -> bool:
        seen = set()
        for x in nums:
            if x in seen:
                return True
            seen.add(x)
        return False
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- A repeat exists when the lengths **differ**; do not invert it.

## Interview Explanation

I add numbers to a set while scanning and report a duplicate as soon as one is already present, in `O(n)` time and space; comparing the set's length with the array's also works.
