---
title: "LeetCode 3828: Final Element After Subarray Deletions"
summary: "LeetCode 3828 note: Alice can leave only the first or last element on her first move, guaranteeing max(first, last); Bob can likewise keep only an end, and one deletion changes at most one end, so the answer is max(first, last)"
description: "LeetCode 3828 record from 2026-02-01"
date: 2026-02-01
tags: ["medium", "math", "brainteaser", "game-theory", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-01
- Submissions: Accepted (first try)

## Approach

A move may delete any subarray of length `< m` (the current length), so **one move can leave a single element, as long as it is the first or the last** (delete a subarray of length `m - 1`).

- **Lower bound**: Alice's first move leaves only `nums[0]` or `nums[-1]`, whichever is larger, ending the game. The answer is at least `max(first, last)`.
- **Upper bound**: if Alice's first move does not end the game, she deleted one contiguous subarray and cannot remove both ends, so the new array keeps at least one original end. Bob then deletes down to the smaller of the new array's ends, which is `<=` that original end `<= max(first, last)`.

So the answer is exactly `max(nums[0], nums[-1])`.

## My Solution

```python
class Solution:
    def finalElement(self, nums: List[int]) -> int:
        return max(nums[0], nums[-1])
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Simulating the whole game: once "one move can leave an end" is seen, it is constant time.

## Interview Explanation

Every move can delete down to just the first or last element. Alice does that immediately and gets the larger end; if she does not, she only removed one block, so an original end survives, and Bob deletes down to the smaller of the new ends, which cannot exceed the original larger end. So the answer is `max(first, last)`.
