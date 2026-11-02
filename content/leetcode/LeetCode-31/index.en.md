---
title: "LeetCode 31: Next Permutation"
summary: "LeetCode 31 note: from the right find the first dip i, swap it with the smallest larger value to its right, then reverse everything after i, with comparisons that include equality"
description: "LeetCode 31 record from 2022-10-21"
date: 2022-10-21
tags: ["medium", "array", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-21
- Submissions: Accepted → Runtime Error ×2 → Wrong Answer → Accepted ×2 → Wrong Answer → Accepted ×2 → Wrong Answer → Accepted ×2
- 2026-10-20 rewrite: Runtime Error → Wrong Answer → Accepted

## Approach

The fixed steps of [Next Permutation]({{< relref "/algorithm/Next-Permutation" >}}):

1. From right to left find the first `i` with `nums[i] < nums[i + 1]`. The suffix `i + 1..` is non-increasing, already the largest arrangement.
2. If none exists (fully non-increasing), reverse everything into the smallest arrangement.
3. From right to left find the first `nums[j] > nums[i]` and swap `i` and `j`.
4. Reverse the part after `i` into increasing order.

With duplicates, steps 1 and 3 must skip equal values using `>=` / `<=`.

## My Attempts

The 2022 versions used strict `<` / `>`, **stopping at the wrong place with duplicates**: `[1, 3, 1]` should become `[3, 1, 1]`; it became `[1, 1, 3]`; another moved `j` rightward while searching for the swap partner and ran out of range. In 2026 one version reversed from `i + 1`, but its `i` pointed one past the dip, so one element too few was reversed: `[2, 3, 3]` should become `[3, 2, 3]`; it became `[3, 3, 2]`.

## Solution

```python
class Solution:
    def nextPermutation(self, nums: List[int]) -> None:
        n = len(nums)
        i = n - 2
        while i >= 0 and nums[i] >= nums[i + 1]:
            i -= 1
        if i >= 0:
            j = n - 1
            while nums[j] <= nums[i]:
                j -= 1
            nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1:] = reversed(nums[i + 1:])
```

## 2026-10 Rewrite

This time `i` meant "one past the descent" (`nums[i - 1] < nums[i]`), and I got it wrong twice:

1. The final reversal loop moved `i -= 1; j += 1`, the wrong directions, and ran out of range: `[1,3,2]` raised a Runtime Error.
2. With the directions fixed, the reversal reused the `j` left over from finding the swap target instead of the array's end, so only part was reversed: `[2,3,1]` returned `[3,2,1]`, the answer is `[3,1,2]`.
3. Resetting `j = n - 1` before reversing passed.

Both mistakes come from reusing a variable: the same `j` first finds the swap target and then drives the reversal, so it has to be reset in between.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- With duplicates, comparisons include equality.
- Reverse the part **after** `i`, starting at `i + 1`.

## Interview Explanation

I find the rightmost position smaller than its right neighbor, swap it with the smallest larger value to its right, and reverse the rest into increasing order; if none exists I reverse everything. Time `O(n)`.
