---
title: "LeetCode 492: Construct the Rectangle"
summary: "LeetCode 492 note: search the width downward from √area; the first divisor of area gives the most square-like rectangle"
description: "LeetCode 492 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Runtime Error → Wrong Answer ×3 → Accepted ×3 → Wrong Answer → Runtime Error → Accepted

## Approach

`L >= W` with `L - W` minimal means `W` should be as large as possible without exceeding `√area` ([Math]({{< relref "/algorithm/Math" >}}) Template 4). Scan down from `int(√area)`; the first `W` dividing `area` is the answer with `L = area // W`. `W = 1` always divides, so the search always succeeds.

## My Attempts

This took 10 submissions:

- Attempt 1's `range(area // 2)` started at 0, so `area % 0` raised ZeroDivisionError.
- `range(1, area // 2)` then had **the wrong upper bound**: `area = 4` tried only 1, returning `[4, 1]` instead of `[2, 2]`, and for `area` of 1, 2 or 3 the range was empty, leaving `w` at 0.
- Bounding by `√area` passed. A rewrite that scans down from `√area` and returns the first divisor then had one version returning `None` and one misnamed variable before passing on the third try.

## Solution

```python
class Solution:
    def constructRectangle(self, area: int) -> List[int]:
        w = isqrt(area)
        while area % w:
            w -= 1
        return [area // w, w]
```

## Complexity

Time `O(√area)`, space `O(1)`.

## Mistakes to Avoid

- The width's upper bound is `√area`, not `area // 2`: for `area = 4`, `range(1, 2)` only tries 1.
- Starting `range` at 0 divides by zero.

## Interview Explanation

With L at least W and the gap minimal, W should be as close to √area as possible, so I scan down from √area for the first divisor and set L = area / W. Time `O(√area)`.
