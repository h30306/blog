---
title: "LeetCode 307: Range Sum Query - Mutable"
summary: "LeetCode 307 note: point updates with range sums make prefix sums O(n) per update; a segment tree or Fenwick tree makes both operations O(log n)"
description: "LeetCode 307 record from 2026-06-19"
date: 2026-06-19
tags: ["medium", "segment-tree", "binary-indexed-tree", "design", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-19
- Submissions: Wrong Answer → Accepted

## Approach

[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) queries are `O(1)`, but every `update` recomputes the later prefixes in `O(n)`. With up to `3 × 10^4` updates and queries, both operations should be `O(log n)` ([Segment Tree]({{< relref "/algorithm/Segment-Tree" >}})):

- **Segment tree**: each node stores a range sum and its children each cover half. An update walks down to the leaf and recomputes parents on the way back; a query returns fully covered nodes directly, 0 for disjoint ones, and splits partially overlapping ones.
- **Fenwick tree**: shorter code; `update` computes the difference and `add`s it, and a range sum is two prefixes subtracted.

## My Attempts

I used a recursive segment tree. Attempt 1's `sumRange` had two bugs: the right child was written `2 * node + 1` (the same as the left), and after querying both halves it **forgot `return left_sum + right_sum`**, so partially overlapping nodes returned `None`. Fixing both passed.

## Solution

```python
class NumArray:
    def __init__(self, nums: List[int]):
        self.n = len(nums)
        self.tree = [0] * (4 * self.n)
        self._build(nums, 0, 0, self.n - 1)

    def _build(self, nums, node, start, end):
        if start == end:
            self.tree[node] = nums[start]
            return
        mid = (start + end) // 2
        self._build(nums, 2 * node + 1, start, mid)
        self._build(nums, 2 * node + 2, mid + 1, end)
        self.tree[node] = self.tree[2 * node + 1] + self.tree[2 * node + 2]

    def update(self, index: int, val: int) -> None:
        def go(node, start, end):
            if start == end:
                self.tree[node] = val
                return
            mid = (start + end) // 2
            if index <= mid:
                go(2 * node + 1, start, mid)
            else:
                go(2 * node + 2, mid + 1, end)
            self.tree[node] = self.tree[2 * node + 1] + self.tree[2 * node + 2]
        go(0, 0, self.n - 1)

    def sumRange(self, left: int, right: int) -> int:
        def go(node, start, end):
            if right < start or end < left:
                return 0
            if left <= start and end <= right:
                return self.tree[node]
            mid = (start + end) // 2
            return go(2 * node + 1, start, mid) + go(2 * node + 2, mid + 1, end)
        return go(0, 0, self.n - 1)
```

## Complexity

Build `O(n)`, `update` and `sumRange` `O(log n)` each, space `O(n)`.

## Mistakes to Avoid

- The children are `2 * node + 1` and `2 * node + 2`; copy-paste easily makes them the same.
- Every path of a recursive function needs a return value.

## Interview Explanation

Prefix sums do not work with modifications, since each update costs `O(n)`. I use a segment tree where each node stores its range's sum; an update finds the leaf and recomputes ancestors, and a query uses fully covered nodes directly, returns 0 for disjoint ones, and splits the rest. Both operations are `O(log n)`. A Fenwick tree also works with shorter code.
