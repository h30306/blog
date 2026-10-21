---
title: "LeetCode 944: Delete Columns to Make Sorted"
summary: "LeetCode 944 note: take each column with zip(*strs) and count the columns that are not non-decreasing"
description: "LeetCode 944 record from 2022-09-26"
date: 2022-09-26
tags: ["easy", "array", "string", "longest-increasing-subsequence"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-26
- Submissions: Wrong Answer ×2 → Accepted

## Approach

`zip(*strs)` turns each column into a tuple. A column must be deleted when it is not non-decreasing, i.e. some `col[i] > col[i + 1]`. Count such columns.

## My Attempts

- Attempt 1 forgot the `return`.
- Attempt 2 wrote `sum(sorted(s) == s ...)`, **counting the sorted columns**, the opposite; and since `s` is a tuple while `sorted(s)` is a list they never compare equal, so it always returned 0: `["c", "b"]` should be 1.
- `sorted(s) != list(s)` passed.

## Solution

```python
class Solution:
    def minDeletionSize(self, strs: List[str]) -> int:
        return sum(any(a > b for a, b in zip(col, col[1:])) for col in zip(*strs))
```

## Complexity

Time `O(total characters)`, space `O(m)`.

## Mistakes to Avoid

- `zip` yields tuples while `sorted` returns a list, so `==` between them is always false.
- Count the columns that are **not** sorted.

## Interview Explanation

I take each column with zip, check whether any adjacent pair decreases, and count those columns. Time is linear in the total length.
