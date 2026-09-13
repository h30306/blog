---
title: "LeetCode 801: Minimum Swaps To Make Sequences Increasing"
summary: "LeetCode note for Minimum Swaps To Make Sequences Increasing, rebuilt from the original learning note"
description: "Cleaned LeetCode 801 article from 2026-05-23 with note repair points and final solution"
date: 2026-05-23
tags: ["hard", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-05-23
Source: Day 25 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- explain `LC 801` with `keep/swap` state meaning and legal transition cases

## Learning Note Extract

#### Problem 2 - LC 801 Minimum Swaps To Make Sequences Increasing
- **Pattern:** DP with two prefix states per index.

#### Why This Fits
At each index, the important question is:
```text
is index i swapped or not swapped?
```

That decision changes what values the next index sees, so the state must explicitly track it.

#### Core State / Invariant
```text
keep = minimum swaps needed up to index i if index i is not swapped
swap = minimum swaps needed up to index i if index i is swapped
```

Initialize:
```text
keep = 0
swap = 1
```

Because at index `0`:
- not swapping costs `0`
- swapping costs `1`

#### Transition Logic
At each `i`, check two kinds of validity.

#### Natural Order Works
```text
A[i - 1] < A[i] and B[i - 1] < B[i]
```

Then:
- if previous state was `keep`, current `keep` stays valid
- if previous state was `swap`, current `swap` stays valid with `+1` for the current swap

So:
```text
next_keep = min(next_keep, keep)
next_swap = min(next_swap, swap + 1)
```

#### Cross Order Works
```text
A[i - 1] < B[i] and B[i - 1] < A[i]
```

Then:
- a previous `swap` can lead to current `keep`
- a previous `keep` can lead to current `swap`

So:
```text
next_keep = min(next_keep, swap)
next_swap = min(next_swap, keep + 1)
```

#### Why This Problem Is Good For Interviews
It forces you to prove:
- what your state means
- why each transition is legal
- why the answer is not greedy on one local pair only

It is a clean test of whether you can reason from invariants instead of pattern-matching syntax.

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- forgetting to reset `next_keep` and `next_swap` to infinity each round
- mixing natural-order and cross-order transitions incorrectly
- using one sequence's ordering without checking the other
- not being able to explain why the state must track swap status at index `i`

#### Strong Spoken Explanation
I use two DP states per index: the minimum swaps so far if I keep the current pair as-is, and the minimum swaps so far if I swap the current pair. The recurrence depends on whether the current values are strictly increasing in natural order, cross order, or both. Natural order lets me stay in the same swap-status pattern. Cross order lets me switch between previous swap and current keep, or previous keep and current swap. Because the legality depends on whether the previous index was swapped, I have to keep that state explicitly.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def minSwap(self, nums1: List[int], nums2: List[int]) -> int:
        keep, swap = 0, 1

        for i in range(1, len(nums1)):
            n_keep = n_swap = float('inf')
            if nums1[i] > nums1[i - 1] and nums2[i] > nums2[i - 1]:
                n_keep = min(n_keep, keep)
                n_swap = min(n_swap, swap + 1)
            if nums1[i] > nums2[i - 1] and nums2[i] > nums1[i - 1]:
                n_keep = min(n_keep, swap)
                n_swap = min(n_swap, keep + 1)
            keep, swap = n_keep, n_swap

        return min(keep, swap)
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Checking only A[i] > A[i-1] and B[i] > B[i-1].
- Forgetting crossed transitions.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
