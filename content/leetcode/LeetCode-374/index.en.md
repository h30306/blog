---
title: "LeetCode 374: Guess Number Higher or Lower"
summary: "LeetCode 374 note: adjust the range by guess's result, where -1 means the guess is too high and 1 too low"
description: "LeetCode 374 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "binary-search", "interactive"]
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
- Submissions: Accepted ×4

## Approach

Standard binary search ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1) with the comparison replaced by `guess`: `-1` means my number is too high, go left; `1` means too low, go right; `0` is correct.

## My Solution

```python
class Solution:
    def guessNumber(self, n: int) -> int:
        l, r = 1, n
        while True:
            mid = (l + r) // 2
            g = guess(mid)
            if g == 0:
                return mid
            if g < 0:
                r = mid - 1
            else:
                l = mid + 1
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- `guess` reports my guess relative to the answer; `-1` means too high.

## Interview Explanation

I binary search 1 to `n`, going left or right by `guess`'s result and returning when it is 0. Time `O(log n)`.
