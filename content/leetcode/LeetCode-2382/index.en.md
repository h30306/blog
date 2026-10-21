---
title: "LeetCode 2382: Maximum Segment Sum After Removals"
summary: "LeetCode 2382 note: work backward so removals become additions; the Union-Find root stores the segment sum, and the maximum only grows"
description: "LeetCode 2382 record from 2026-07-26"
date: 2026-07-26
tags: ["hard", "union-find", "prefix-sum", "ordered-set", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-26
- Submissions: Time Limit Exceeded ×2 → Accepted → Wrong Answer → Accepted

## Approach

Removing elements one by one splits segments, but Union-Find can only merge. **Work backward** ([Union-Find]({{< relref "/algorithm/Union-Find" >}}), work backward): start with everything removed and add elements back in reverse order, merging with existing neighbors on the left and right.

- Each root stores its segment sum `total[root]`.
- In reverse, segments only grow and sums only increase (all numbers are positive), so a single variable holds the current maximum.
- The answer after the `i`-th removal is the maximum **before** `removeQueries[i]` is added back.

## My Attempts

| Version | Problem |
|---|---|
| Two TLEs | Right idea, but each step recomputed `max(group_sum.values())` over all segments, `O(n²)` overall; the first `find` also lacked path compression |
| AC | Switched to arrays and kept the maximum in a variable |
| WA | A different approach: sorted removed positions + prefix sums + a heap with lazy deletion. But popping from the heap **did not decrement the deletion count**, so deleting one segment discarded every segment with the same sum. For `nums = [3, 1, 3]`, `removeQueries = [1, 2, 0]` the answer is `[3, 3, 0]`; it returned `[3, 0, 0]` |
| AC | Added the decrement (but `list.insert` is `O(n)`, 1.3 s) |

## Solution

```python
class Solution:
    def maximumSegmentSum(self, nums: List[int], removeQueries: List[int]) -> List[int]:
        n = len(nums)
        parent = list(range(n))
        total = [0] * n
        alive = [False] * n

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        res, best = [], 0
        for i in reversed(removeQueries):
            res.append(best)                       # the answer before i is added back
            alive[i] = True
            total[i] = nums[i]
            for j in (i - 1, i + 1):
                if 0 <= j < n and alive[j]:
                    rj, ri = find(j), find(i)
                    parent[rj] = ri
                    total[ri] += total[rj]
            best = max(best, total[find(i)])
        return res[::-1]
```

## Complexity

Time `O(n · α(n))`, space `O(n)`.

## Mistakes to Avoid

- Do not recompute the maximum over all sets each step.
- With lazy deletion, decrement the matching count whenever one is popped.
- Record the answer before adding back, and reverse at the end.

## Interview Explanation

Removal splits segments and Union-Find cannot split, so I add elements back in reverse, merging with existing neighbors and storing sums at the root. All numbers are positive, so the maximum only grows and a single variable holds it. The maximum before each addition is the answer for that removal, reversed at the end. Time `O(n α(n))`.
