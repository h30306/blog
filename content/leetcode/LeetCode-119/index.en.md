---
title: "LeetCode 119: Pascal's Triangle II"
summary: "LeetCode 119 note: only row rowIndex is needed; update a 1D array from right to left for O(k) space"
description: "LeetCode 119 record from 2022-08-16"
date: 2022-08-16
tags: ["easy", "array", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-16
- Submissions: Wrong Answer ×2 → Accepted ×2 → Runtime Error → Wrong Answer → Runtime Error → Accepted ×7

## Approach

For a single row there is no need to store the whole triangle: keep one array, append a 1 per row, then update `row[j] += row[j - 1]` **from right to left** ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}) Template 1), so `row[j - 1]` still holds the previous row's value; left to right would reuse already-updated values. `rowIndex` is 0-based, so row `k` has `k + 1` numbers.

## My Attempts

- Attempt 1 built the triangle as in LC 118 but only `rowIndex` rows; **`rowIndex` is 0-based**, so it returned the previous row: `rowIndex = 5` gave `[1, 4, 6, 4, 1]`.
- Then I tried the formula `ans[i] = ans[i - 1] * up / down`: a wrong parameter name (NameError), floats from `/` judged wrong, and `map(ans, int)` with the arguments reversed (TypeError); `//` passed.

## Solution

```python
class Solution:
    def getRow(self, rowIndex: int) -> List[int]:
        row = [1]
        for _ in range(rowIndex):
            row.append(1)
            for j in range(len(row) - 2, 0, -1):
                row[j] += row[j - 1]
        return row
```

## Complexity

Time `O(k²)`, space `O(k)`.

## Mistakes to Avoid

- `rowIndex` is 0-based; build `rowIndex + 1` rows.
- The 1D update runs right to left.
- With the formula `C(k, i)`, use integer division; `/` gives floats.

## Interview Explanation

I keep one array, append a 1 per row, and add each cell's left neighbor from right to left so only previous-row values are used, in `O(k)` space; the binomial coefficients C(k, i) also work term by term.
