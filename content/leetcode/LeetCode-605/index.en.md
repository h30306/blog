---
title: "LeetCode 605: Can Place Flowers"
summary: "LeetCode 605 note: scan left to right and plant in any empty plot whose neighbors are empty; a new flower blocks the next plot, so actually update the array"
description: "LeetCode 605 record from 2022-08-28"
date: 2022-08-28
tags: ["easy", "array", "greedy"]
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
- Submissions: Runtime Error ×2 → Wrong Answer → Internal Error → Wrong Answer → Accepted → Wrong Answer ×5 → Accepted

## Approach

Greedy ([Greedy]({{< relref "/algorithm/Greedy" >}})): scanning left to right, plant whenever the plot is 0 and neither neighbor is 1 (treating outside the ends as empty), **and set it to 1** so the next plot is blocked. Planting as early as possible never hurts, since a flower further left leaves more room on the right. Finally check that the count is `>= n`.

## My Attempts

I solved it in 2022 and again in 2025, failing 10 times in total:

- 2022: I first counted "empty plots not next to any flower", **but newly planted flowers block their neighbors too**, so adjacent empty plots were both counted: `[0, 0]`, `n = 2` returned `True` instead of `False`. Padding with zeros and marking each planted plot passed.
- 2025: tracking `prev_plant` and `next_plant`, I first typed `pre_plant`, so the left neighbor always looked empty; after fixing that, the last line read `plots <= n`, **the comparison reversed**.

## Solution

```python
class Solution:
    def canPlaceFlowers(self, flowerbed: List[int], n: int) -> bool:
        bed = [0] + flowerbed + [0]
        count = 0
        for i in range(1, len(bed) - 1):
            if bed[i - 1] == bed[i] == bed[i + 1] == 0:
                bed[i] = 1
                count += 1
        return count >= n
```

## Complexity

Time `O(n)`, space `O(n)` for the sentinels; checking the bounds in place gives `O(1)`.

## Mistakes to Avoid

- Update the array after planting, or two adjacent empty plots both count.
- The comparison is `count >= n`.

## Interview Explanation

With an empty sentinel at each end I scan left to right, planting and marking any plot with empty neighbors, since planting early never hurts, then check the count is at least n. Time `O(n)`.
