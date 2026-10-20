---
title: "LeetCode 992: Subarrays with K Different Integers"
summary: "LeetCode 992 note: \"exactly k kinds\" = \"at most k\" − \"at most k - 1\", where each at-most window adds right - left + 1 per right end"
description: "LeetCode 992 record from 2026-01-21"
date: 2026-01-21
tags: ["hard", "sliding-window", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-21
- Submissions: Accepted (first try)

## Approach

"Exactly `k` distinct" is not monotonic, but "at most `k` distinct" is:

```text
exactly k = at most k − at most k - 1
```

The "at most" count: shrink the left when there are too many kinds, and `right - left + 1` valid subarrays end at `right`.

## My Solution

My accepted version used the same `extra` trick as [LeetCode 3306]({{< relref "/leetcode/LeetCode-3306" >}}): with exactly `k` kinds, shrink away redundant repeats on the left, record them in `extra`, and add `1 + extra` per right end, resetting `extra` when too many kinds force one out. Here it is in the more general at-most difference form:

```python
class Solution:
    def subarraysWithKDistinct(self, nums: List[int], k: int) -> int:
        def at_most(limit: int) -> int:
            cnt = Counter()
            left = count = 0
            for right, x in enumerate(nums):
                cnt[x] += 1
                while len(cnt) > limit:
                    y = nums[left]
                    cnt[y] -= 1
                    if cnt[y] == 0:
                        del cnt[y]
                    left += 1
                count += right - left + 1
            return count

        return at_most(k) - at_most(k - 1)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Delete keys whose count reaches zero, so `len(cnt)` is the number of kinds.

## Interview Explanation

"Exactly `k` kinds" is not monotonic, so I compute "at most `k`" minus "at most `k - 1`". Each at-most count is a sliding window that shrinks when there are too many kinds and adds `right - left + 1` per right end. Both passes are `O(n)`.
