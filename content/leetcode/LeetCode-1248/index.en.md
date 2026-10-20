---
title: "LeetCode 1248: Count Number of Nice Subarrays"
summary: "LeetCode 1248 note: \"exactly k odd numbers\" is not monotonic, so compute \"at most k\" minus \"at most k - 1\"; or use prefix sums with a hash map"
description: "LeetCode 1248 record from 2025-07-22"
date: 2025-07-22
tags: ["medium", "sliding-window", "prefix-sum", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-22
- Submissions: Accepted (sliding window) → Time Limit Exceeded → Accepted (prefix sums)

## Approach

### Sliding window: at most k minus at most k - 1

"Exactly `k` odd numbers" does not work directly with a window: growing it may leave the odd count unchanged, so the left boundary cannot tell whether to shrink. But "**at most `k` odd numbers**" is monotonic:

- Each time the right boundary adds a number, shrink the left while the odd count exceeds `k`.
- There are `right - left + 1` valid subarrays ending at `right`.

Exactly `k` = at most `k` − at most `k - 1`.

### Prefix sums with a hash map

Treat odd numbers as 1 and even as 0. The subarray `(i, j]` has `k` odd numbers ⇔ `prefix[j] - prefix[i] == k`. While scanning, a hash map counts each prefix value, and each `j` adds `count[prefix[j] - k]`.

## My Attempts

I first passed with a sliding window. Rewriting it six months later with prefix sums, my first version compared every pair of prefixes with a nested loop, `O(n^2)`, which hit TLE at `n = 50000`. Counting prefix values in a hash map passed.

## Solution

```python
class Solution:
    def numberOfSubarrays(self, nums: List[int], k: int) -> int:
        def at_most(limit: int) -> int:
            left = odd = count = 0
            for right, x in enumerate(nums):
                odd += x % 2
                while odd > limit:
                    odd -= nums[left] % 2
                    left += 1
                count += right - left + 1          # valid subarrays ending at right
            return count

        return at_most(k) - at_most(k - 1)
```

Prefix-sum version:

```python
class Solution:
    def numberOfSubarrays(self, nums: List[int], k: int) -> int:
        seen = Counter({0: 1})                     # prefix value -> occurrences
        prefix = ans = 0
        for x in nums:
            prefix += x % 2
            ans += seen[prefix - k]
            seen[prefix] += 1
        return ans
```

## Complexity

Both are `O(n)` time. The sliding window uses `O(1)` space, prefix sums `O(n)`.

## Mistakes to Avoid

- Sliding a window directly on "exactly `k`": it is not monotonic.
- Pairing prefix sums with a nested loop: `O(n^2)`.
- Seed the prefix map with `{0: 1}` for subarrays starting at index 0.

## Interview Explanation

"Exactly `k` odd numbers" is not monotonic, so I compute "at most `k`" minus "at most `k - 1`". "At most" works with a sliding window: shrink the left while the odd count is over the limit, and `right - left + 1` valid subarrays end at the right boundary. Alternatively, treat odd numbers as 1, take prefix sums, and count how many times `prefix - k` has appeared. Both are `O(n)`.
