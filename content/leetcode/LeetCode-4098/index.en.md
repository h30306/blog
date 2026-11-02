---
title: "LeetCode 4098: Minimize the Maximum Value of GCD-Connected Array"
summary: "LeetCode 4098 note: value's smallest prime factor p decides everything: the next element is at least value + p, then even numbers step by 2; the left side is feasible iff value - p >= 2 * index"
description: "LeetCode 4098 record from 2026-11-02"
date: 2026-11-02
tags: ["medium", "math", "number-theory", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-11-02
- Submissions: Wrong Answer ×2 → Accepted

## Approach

The array must be strictly increasing, with `nums[index] = value` and gcd greater than 1 for every adjacent pair. Minimize the last element.

The key identity is `gcd(value, value + d) = gcd(value, d)`. So the closest number sharing a factor with `value` is at distance `p`, the **smallest prime factor** of `value` ([Number Theory]({{< relref "/algorithm/Number-Theory" >}})):

- `value + p` and `value - p` are always even: if `p = 2`, `value` is even; if `p` is odd, `value` is odd too, and odd ± odd is even.
- After an even number, the next even number always works (gcd at least 2) and costs only 2 more, which cannot be beaten.

**Right side**: there are `t = n - 1 - index` elements after `index`.

- `t = 0`: the answer is `value`.
- Otherwise: `value + p`, then +2 each step, ending at `value + p + 2 * (t - 1)`.

**Left side** only needs to be feasible: the previous element is at most `value - p`, each earlier one 2 less, and the first must be at least 2, so `index` elements must fit: `value - p - 2 * (index - 1) >= 2`, i.e. `value - p >= 2 * index`. `value = 1` has no prime factor, so it is never feasible (with `n >= 2` it always has a neighbour).

`value` goes up to `10^9`; find the smallest prime factor by trial division up to `sqrt(value)`.

## My Attempts

Two wrong answers during the contest:

1. The first version overcomplicated it: sieve the prime factors of `value`, use Euler's phi to count numbers below `value` sharing a factor with it, compare that count with `index`, and always return `value + smallest prime factor`. Both sides were wrong:
   - The left side only needs **adjacent** pairs to share a factor, not every element to share one with `value`. `n = 4, index = 3, value = 9` works as `[2,4,6,9]`, but I returned -1.
   - The right side ignored how many elements follow `index`: for `n = 4, index = 3, value = 12` the answer is 12 and I returned 14; for `n = 4, index = 0, value = 8` the answer is 14 (`[8,10,12,14]`) and I returned 10.
   - The sieve also allocates an array of length `value`, impossible for `value` up to `10^9`.
2. Added a `value == 1` check and changed nothing else; still wrong.
3. Rewrote it with the reasoning above and passed.

## Solution

```python
class Solution:
    def minimumMaxValue(self, n: int, index: int, value: int) -> int:
        if value == 1:
            return -1
        p = value
        d = 2
        while d * d <= value:
            if value % d == 0:
                p = d
                break
            d += 1
        if value - p < 2 * index:
            return -1
        t = n - 1 - index
        return value if t == 0 else value + p + 2 * (t - 1)
```

## Complexity

Time `O(sqrt(value))`, space `O(1)`.

## Mistakes to Avoid

- The condition is on **adjacent** pairs, not on every element sharing a factor with `value`.
- The answer depends on how many elements follow `index`; if `index` is last, the answer is `value`.
- `value` reaches `10^9`, so a sieve of length `value` is out of the question.

## Interview Explanation

Since `gcd(value, value + d) = gcd(value, d)`, the nearest number sharing a factor with `value` is at distance `p`, its smallest prime factor, and `value ± p` is even, so from there I can move in steps of 2. With `t` elements on the right the answer is `value + p + 2(t - 1)`, or `value` when `t = 0`; the left side must fit `index` numbers of at least 2, which means `value - p >= 2 * index`. Trial division finds `p`, so time is `O(sqrt(value))`.
