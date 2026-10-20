---
title: "LeetCode 3660: Jump Game IX"
summary: "LeetCode 3660 note: cutting between i and i+1, if the left max exceeds the right min the two sides reach each other and share the answer; otherwise the left answer is the left max"
description: "LeetCode 3660 record from 2026-06-23"
date: 2026-06-23
tags: ["medium", "dynamic-programming", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-23
- Submissions: Accepted (first try)

## Approach

Jumps go right to a smaller value or left to a larger one.

Cut between `i` and `i + 1` and compare the left max `pre_max[i]` of `[0..i]` with the right min `suf_min` of `[i+1..]`:

- **`pre_max[i] > suf_min`**: the left maximum can jump right to the right minimum, which can jump back left to anything larger. The two sides **merge into one component**, so `ans[i] = ans[i + 1]`.
- **`pre_max[i] <= suf_min`**: every left value is `<=` every right value, so the left can never reach the right (rightward jumps go only to smaller values). Within the left, every index can reach `pre_max[i]` (jump left to larger, or right and then left), so `ans[i] = pre_max[i]`.

Working right to left, `ans[n - 1] = pre_max[n - 1]` (the global maximum).

## My Solution

```python
class Solution:
    def maxValue(self, nums: List[int]) -> List[int]:
        n = len(nums)
        pre_max = list(accumulate(nums, max))
        ans = [0] * n
        suf_min = float("inf")
        for i in range(n - 1, -1, -1):
            if pre_max[i] > suf_min:
                ans[i] = ans[i + 1]                # merged with the right side
            else:
                ans[i] = pre_max[i]                # cannot cross, take the left max
            suf_min = min(suf_min, nums[i])
        return ans
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Running BFS / DFS from every start: `O(n^2)`.
- The cut condition is strict `>`: equal values cannot jump to each other.

## Interview Explanation

I cut at every position and compare the left maximum with the right minimum. If the left max is larger, the sides can reach each other and the left answer equals the right one; otherwise the left can never cross and its answer is the left maximum. With prefix maxima precomputed and a suffix minimum maintained right to left, time is `O(n)`.
