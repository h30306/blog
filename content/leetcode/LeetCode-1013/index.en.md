---
title: "LeetCode 1013: Partition Array Into Three Parts With Equal Sum"
summary: "LeetCode 1013 note: the total must be divisible by 3; accumulate from the left, cutting whenever the running sum hits total / 3, and succeed with at least 3 pieces"
description: "LeetCode 1013 record from 2022-09-27"
date: 2022-09-27
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
First Attempt: 2022-09-27
- Submissions: Wrong Answer → Runtime Error → Wrong Answer ×5 → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×3 → Accepted → Wrong Answer → Accepted ×3

## Approach

Each piece must sum to `target = total / 3`, so a total not divisible by 3 is impossible. Accumulate from the left and **cut as soon as the sum hits `target`** ([Greedy]({{< relref "/algorithm/Greedy" >}}): cutting early leaves more options). Succeed with **at least** 3 pieces: the first two are `target`, and everything after them must then sum to `target` too. With `target = 0` there can be more than three pieces, as in `[0, 0, 0, 0]`, so the test is `>= 3`, not `== 3`.

## My Attempts

This took 18 submissions, stuck on how many pieces to require:

- Attempt 1 was already the right greedy, but it tested `c == 3`, **missing that zero-sum pieces can be cut further**: `[0, 0, 2, -2, 0]` splits as `0 | 0 | 2, -2 | 0`, four pieces, so it returned `False` instead of `True`.
- A dozen more versions kept changing the ending: cutting only while `c < 3`, requiring `temp == target` at the end, and so on, each failing on another input such as `[1, 1, 1]` or `[2, 2, 2, 0]`. One put the `return` inside the loop and returned on the first element.
- The first accepted version checked that the remaining sum is 0 once the third piece is cut; then I went back to attempt 1 with `>= 3` instead of `== 3`, which also passed.

## Solution

```python
class Solution:
    def canThreePartsEqualSum(self, arr: List[int]) -> bool:
        total = sum(arr)
        if total % 3:
            return False
        target, cur, parts = total // 3, 0, 0
        for x in arr:
            cur += x
            if cur == target:
                parts += 1
                cur = 0
        return parts >= 3
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Test `>= 3`: zero-sum pieces can be cut further.
- Do not `return` from inside the loop on the first iteration.

## Interview Explanation

The total must be divisible by 3 with each piece a third. Accumulating from the left, I cut whenever the sum reaches a third and succeed with at least three pieces; a zero third can yield more pieces, hence at least. Time `O(n)`.
