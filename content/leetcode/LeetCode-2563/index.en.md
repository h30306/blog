---
title: "LeetCode 2563: Count the Number of Fair Pairs"
summary: "LeetCode 2563 note: split \"sum in [lower, upper]\" into \"sum <= upper\" minus \"sum <= lower - 1\", and count each with converging pointers over the sorted array in O(n)"
description: "LeetCode 2563 record from 2026-01-25"
date: 2026-01-25
tags: ["medium", "two-pointers", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-25
- Submissions: WA → TLE → WA → TLE → AC

## Approach

A pair `(i, j)` depends only on the sum of two values, not their order, so sort first.

Counting "sum in `[lower, upper]`" directly mixes an upper and a lower bound whose pointers want to move in opposite directions. **Split it into two one-sided counts**:

```text
count(lower <= sum <= upper) = count(sum <= upper) - count(sum <= lower - 1)
```

`count(sum <= limit)` with converging pointers:

- `nums[left] + nums[right] > limit`: `right` is too big; move it left.
- Otherwise `left` pairs with every index in `left + 1..right`, so add `right - left` and move `left` right.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1, WA | Used one shared `left`/`right` across all `i` to find the partner range, without requiring `j > i`, so it paired elements with themselves and counted both orders. For `[1, 1]`, `lower = upper = 2`, the answer is 1; this returned 4 |
| Attempts 2 and 4, TLE | Reset the pointers to `i + 1` and `n - 1` for every `i` and walked inward: `O(n^2)` |
| Attempt 3, WA | Used `left = max(i + 1, left)` so `left` only moved right, but as `nums[i]` grows, **the lower-bound position actually moves left**, so `left` cannot be monotonic. For `[-2, -1, -1, -1]`, `lower = upper = -2`, every pair of the three `-1`s sums to `-2`, so the answer is 3; this returned 2 |

Every one of these handled both bounds at once. Splitting into two one-sided counts passed.

## Solution

```python
class Solution:
    def countFairPairs(self, nums: List[int], lower: int, upper: int) -> int:
        nums.sort()

        def count_at_most(limit: int) -> int:     # pairs with sum <= limit
            left, right = 0, len(nums) - 1
            count = 0
            while left < right:
                if nums[left] + nums[right] > limit:
                    right -= 1
                else:
                    count += right - left
                    left += 1
            return count

        return count_at_most(upper) - count_at_most(lower - 1)
```

Alternatively, for each `i`, `bisect` the bounds in `i + 1..n - 1`, also `O(n log n)`.

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Not requiring `j > i`: self-pairs and double counting.
- Handling both bounds with one pair of pointers: the lower-bound position is not monotonic.
- Resetting pointers for every `i`: `O(n^2)`.

## Interview Explanation

Pairs depend only on their sum, so I sort. I turn the range into "sum `<= upper`" minus "sum `<= lower - 1`". Each one-sided count uses converging pointers: if the ends sum too high, move the right end left; otherwise the left end pairs with everything up to the right end, so add `right - left` and move the left end right. Both passes are `O(n)`, so sorting dominates at `O(n log n)`.
