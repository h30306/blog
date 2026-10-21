---
title: "LeetCode 832: Flipping an Image"
summary: "LeetCode 832 note: reverse each row and invert its bits, which two pointers can do at once"
description: "LeetCode 832 record from 2022-09-15"
date: 2022-09-15
tags: ["easy", "array", "two-pointers", "bit-manipulation", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-15
- Submissions: Runtime Error ×7 → Accepted

## Approach

Reverse each row, then invert it. Two pointers do both at once ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1): swap `row[l]` and `row[r]` while applying `^ 1` to each; the middle cell with `l == r` is inverted once.

## My Attempts

The first seven submissions were REs: attempt 1 computed the loop count with `/`, passing a float to `range` (TypeError); after switching to `//`, that version and the next five returned or iterated over a nonexistent `A` (the parameter is `image`, NameError). Attempt 1's swap also used `row[-i]`, which is off by one (`row[-0]` is `row[0]`, not the last cell) and should be `row[-1 - i]`. A one-line list comprehension over `image` finally passed.

## Solution

```python
class Solution:
    def flipAndInvertImage(self, image: List[List[int]]) -> List[List[int]]:
        for row in image:
            l, r = 0, len(row) - 1
            while l <= r:
                row[l], row[r] = row[r] ^ 1, row[l] ^ 1
                l, r = l + 1, r - 1
        return image
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- When `l == r` the simultaneous assignment inverts it once, which is correct.

## Interview Explanation

For each row two pointers swap the ends while XOR-ing each with 1, inverting the middle cell once. Time `O(n²)`, space `O(1)`.
