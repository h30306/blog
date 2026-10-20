---
title: "LeetCode 2537: Count the Number of Good Subarrays"
summary: "LeetCode 2537 note: adding x creates cnt[x] new equal pairs and removing it loses cnt[x] - 1; an \"at least k pairs\" counting window with count += left"
description: "LeetCode 2537 record from 2026-01-20"
date: 2026-01-20
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-20
- Submissions: Wrong Answer ×2 → Accepted ×2

## Approach

Equal-value pairs in the window: adding an `x` pairs it with every `x` already there, so **the pair count rises by `cnt[x]`** (the count before adding). Removing reverses it, falling by `cnt[x] - 1` (the count after removal).

The pair count only grows with the window, so "at least `k` pairs" is monotonic: use the "at least" count, shrinking while valid and adding `left`.

## My Attempts

I started with combinations: on adding, subtract the old `C(cnt - 1, 2)` and add the new `C(cnt, 2)`.

| Version | Problem |
|---|---|
| Attempt 1 | The combinations used `freq[nums[right - 1]]` (the previous element's count) instead of `freq[nums[right]]`. For `nums = [2, 2, 3]`, `k = 1`, the answer is 2; it returned 4 |
| Attempt 2 | Fixed the index, but when shrinking it **updated the pair count without decrementing `freq[nums[left]]`**. For `nums = [3, 2, 2, 3]`, `k = 1`, the answer is 4; it returned 5 |
| Attempt 3, AC | Added `freq[nums[left]] -= 1` |
| Attempt 4, AC | Switched to "add `cnt[x]` on entry, subtract `cnt[x]` on exit", much simpler |

## Solution

```python
class Solution:
    def countGood(self, nums: List[int], k: int) -> int:
        cnt = Counter()
        pairs = left = count = 0
        for x in nums:
            pairs += cnt[x]                        # pairs with every x already in the window
            cnt[x] += 1
            while pairs >= k:
                y = nums[left]
                cnt[y] -= 1
                pairs -= cnt[y]                    # loses its pairs with the remaining y's
                left += 1
            count += left
        return count
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Updating the statistic while shrinking but forgetting the count table.
- Using the wrong element in an incremental update (`nums[right - 1]` vs `nums[right]`).

## Interview Explanation

Adding an `x` pairs it with every `x` already in the window, so the pair count grows by that count, and removal reverses it. Pairs only increase as the window grows, so I use an "at least" sliding window: while there are at least `k` pairs I shrink the left, and every left end from 0 to `left - 1` is valid, so I add `left`. Time `O(n)`.
