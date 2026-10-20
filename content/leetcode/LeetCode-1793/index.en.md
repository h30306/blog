---
title: "LeetCode 1793: Maximum Score of a Good Subarray"
summary: "LeetCode 1793 note: expand from k toward the larger neighbor each step so the minimum stays as large as possible for each length; at a boundary, only the other side can grow"
description: "LeetCode 1793 record from 2026-01-29"
date: 2026-01-29
tags: ["hard", "two-pointers", "greedy", "binary-search", "array", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-29
- Submissions: Wrong Answer ×3 → Accepted

## Approach

A good subarray always contains `k`, so start from `[k, k]` and grow by one element to the left or right each step, from length 1 up to `n`.

**Grow toward the larger neighbor**: the score is minimum × length, and for a given length a larger minimum is better. Moving toward the larger neighbor lowers the minimum the least. After each step, update the answer with the current minimum × length.

At a boundary, only the other side can grow, until both ends are reached.

The same problem can be viewed with a monotonic stack: for each `nums[i]` as the minimum, find how far it extends left and right and count it only if the range contains `k`, the same family as the largest rectangle in a histogram ([LeetCode 84]({{< relref "/leetcode/LeetCode-84" >}})).

## My Attempts

My version computed the score after growing left and after growing right, and moved toward the higher one. All three WAs were boundary and update issues:

| Version | Problem |
|---|---|
| Attempt 1 | The left-growth length was one short, the current minimum was never updated, and it moved right even with the right end at the boundary. For `nums = [1, 1]`, `k = 1`, the answer is 2; it returned 1 |
| Attempt 2 | When growing right, it updated the answer with the left-growth score. For `nums = [1, 1]`, `k = 0`, the answer is 2; it returned 1 |
| Attempt 3 | Looped while `start >= 0 and end <= n - 1` and set the blocked side's score to the current answer; on a tie it moved toward the blocked side, `start` became -1, and the loop ended before the other side finished growing. For `nums = [2, 1, 1]`, `k = 0`, the whole array `1 × 3 = 3` is the answer; it returned 2 |

Looping while `start > 0 or end < n - 1` and forcing the other side at a boundary passed.

## Solution

```python
class Solution:
    def maximumScore(self, nums: List[int], k: int) -> int:
        n = len(nums)
        i = j = k
        cur_min = best = nums[k]
        while i > 0 or j < n - 1:
            if i == 0 or (j < n - 1 and nums[j + 1] > nums[i - 1]):
                j += 1                             # grow right (left blocked, or right neighbor larger)
                cur_min = min(cur_min, nums[j])
            else:
                i -= 1                             # grow left
                cur_min = min(cur_min, nums[i])
            best = max(best, cur_min * (j - i + 1))
        return best
```

Comparing the two neighbor values directly is simpler than my original comparison of post-growth scores, with the same effect.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Forgetting to update the minimum after growing.
- Growing toward a boundary, or ending the loop before the other side has finished.
- The length is `j - i + 1`.

## Interview Explanation

A good subarray always contains `k`, so I grow outward from `k`, each time toward the larger neighbor, because for the same length a larger minimum scores higher and the larger side lowers the minimum the least. After each step I update the answer with minimum × length, and once one side is at the boundary I only grow the other. Time `O(n)`. A monotonic stack that finds each element's range as the minimum, counting only ranges containing `k`, also works.
