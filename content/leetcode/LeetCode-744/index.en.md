---
title: "LeetCode 744: Find Smallest Letter Greater Than Target"
summary: "LeetCode 744 note: find the first letter > target (an upper bound), wrapping around to the first letter if none exists"
description: "LeetCode 744 record from 2022-09-03"
date: 2022-09-03
tags: ["easy", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-03
- Submissions: Wrong Answer ×2 → Runtime Error ×2 → Wrong Answer ×5 → Accepted ×2 → Wrong Answer → Time Limit Exceeded ×2 → Accepted

## Approach

Find the first letter **strictly greater** than `target` in the sorted list, the upper bound ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1), via `bisect_right`. If every letter is `<= target`, wrap around to the first, handled with `% len`.

## My Attempts

This took 15 submissions. I first handled wrap-around with `ord` plus 26: add 26 to letters below `target` and take the minimum, but returned a number (`123`) or forgot to subtract 26 after `chr` (`'{'`), e.g. `['a', 'h']`, `target = 'j'` should be `'a'`. After switching to binary search, two versions stopped shrinking the interval (TLE).

## Solution

```python
class Solution:
    def nextGreatestLetter(self, letters: List[str], target: str) -> str:
        return letters[bisect.bisect_right(letters, target) % len(letters)]
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- Strictly greater, so letters equal to `target` do not count: `bisect_right`.
- Return the letter, not its `ord` value.

## Interview Explanation

`bisect_right` gives the position of the first letter strictly greater than the target, and a modulo wraps around past the end. Time `O(log n)`.
