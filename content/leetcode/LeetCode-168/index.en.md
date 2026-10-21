---
title: "LeetCode 168: Excel Sheet Column Title"
summary: "LeetCode 168 note: Excel columns are base 26 without a zero digit; take (n - 1) % 26 as the letter, then n = (n - 1) // 26"
description: "LeetCode 168 record from 2022-08-20"
date: 2022-08-20
tags: ["easy", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-20
- Submissions: Internal Error → Wrong Answer ×3 → Runtime Error ×3 → Wrong Answer → Accepted

## Approach

An ordinary base has digits `0..25`, but column names use `1..26` (`A..Z`) **with no zero**. So each step first does `n -= 1`, shifting `1..26` to `0..25`, then takes `% 26` as the last letter and `// 26` to move on ([Math]({{< relref "/algorithm/Math" >}}) Template 7). Reverse the letters at the end.

## My Attempts

This took 9 submissions:

- The first four assumed **at most two letters**, writing `capitals[n // 26] + capitals[n % 26]`: `1` returned `"AB"` instead of `"A"`.
- With recursion, one version misspelled the parameter (NameError) and the next subtracted 1 only for the letter, **not for the recursive call**: `52` returned `"BZ"` instead of `"AZ"`. Using `n - 1` on both sides passed.

## Solution

```python
class Solution:
    def convertToTitle(self, columnNumber: int) -> str:
        res = []
        n = columnNumber
        while n:
            n, r = divmod(n - 1, 26)
            res.append(chr(ord("A") + r))
        return "".join(reversed(res))
```

## Complexity

Time `O(log n)`, space `O(log n)`.

## Mistakes to Avoid

- Subtract 1 at every step, not only for the last letter: `52` is `"AZ"`, not `"BZ"`.
- The number of letters is not fixed; do not assume two.

## Interview Explanation

Column names are base 26 with digits 1 to 26, so each step subtracts one to get 0 to 25, uses the remainder as the letter, divides, and continues; then I reverse. Time `O(log n)`.
