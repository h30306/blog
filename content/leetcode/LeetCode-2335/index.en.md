---
title: "LeetCode 2335: Minimum Amount of Time to Fill Cups"
summary: "LeetCode 2335 note: the answer is max(the largest count, ceil(total / 2)); simulating means filling one cup from each of the two largest every second"
description: "LeetCode 2335 record from 2022-11-22"
date: 2022-11-22
tags: ["easy", "array", "greedy", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-22
- Submissions: Accepted (first try)

## Approach

At most two cups per second, of different types, gives two lower bounds: at least `ceil(total / 2)` seconds, and at least `max(amount)` since the largest type fills one cup per second. Greedily filling the two largest types each second (simulated with a max-heap, [Greedy]({{< relref "/algorithm/Greedy" >}})) achieves the larger bound exactly.

## My Attempts

Passed on the first try with the formula above.

## Solution

```python
class Solution:
    def fillCups(self, amount: List[int]) -> int:
        return max(max(amount), (sum(amount) + 1) // 2)
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Consider both lower bounds and take the larger.

## Interview Explanation

With two different cups per second, at least ceil(total / 2) seconds are needed, and the largest type needs at least its count; greedily filling the two largest types reaches the larger bound.
