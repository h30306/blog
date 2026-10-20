---
title: "LeetCode 2516: Take K of Each Character From Left and Right"
summary: "LeetCode 2516 note: taking from both ends leaves a middle block in which each letter may appear at most total − k times; find the longest such window"
description: "LeetCode 2516 record from 2026-01-11"
date: 2026-01-11
tags: ["medium", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-11
- Submissions: Wrong Answer → Runtime Error ×2 → Accepted

## Approach

As in [LeetCode 1423]({{< relref "/leetcode/LeetCode-1423" >}}), taking from both ends = leaving a contiguous middle block.

Taking at least `k` of each letter ⇔ the middle keeps **at most `total − k`** of each. So:

1. Compute each letter's limit `limit[c] = count[c] - k`. If any is `< 0`, the total is not enough: return -1.
2. Find the longest middle block with a "longest" sliding window: shrink the left when the newly added letter goes over its limit.
3. The answer is `n - longest length`.

## My Attempts

All the mistakes were in step 1:

| Version | Problem |
|---|---|
| Attempt 1, WA | Wrote `char not in freq or freq[char] < k`. With `k = 0` nothing is needed, but a letter absent from the string was still judged short. For `s = "b"`, `k = 0`, the answer is 0; this returned -1 |
| Attempts 2–3, RE | Switched to `and` (attempt 3 also added `k > 0`), so a letter present but short **no longer returned -1**; its limit went negative, no window was ever valid, and `left` ran off the string. For `s = "abc"`, `k = 2`, it raised IndexError; the answer is -1 |
| AC | `(k > 0 and char not in freq) or freq[char] < k` |

Checking `count[c] - k < 0` alone is enough: `Counter` returns 0 for missing letters, and with `k = 0`, `0 - 0` is not negative.

## Solution

```python
class Solution:
    def takeCharacters(self, s: str, k: int) -> int:
        limit = Counter(s)
        for c in "abc":
            limit[c] -= k                          # how many c the middle may keep
            if limit[c] < 0:
                return -1

        cnt = Counter()
        left = best = 0
        for right, c in enumerate(s):
            cnt[c] += 1
            while cnt[c] > limit[c]:
                cnt[s[left]] -= 1
                left += 1
            best = max(best, right - left + 1)
        return len(s) - best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- With `k = 0`, no letters are needed.
- Return early when a total is short; otherwise the limit is negative and the window loop runs out of range.

## Interview Explanation

Taking from both ends leaves a contiguous middle, so I flip the problem: the middle may keep at most total minus `k` of each letter, and the answer is the length minus the longest such middle. If a total is short I return -1 right away. A longest-window slide shrinks the left when the new letter exceeds its limit. Time `O(n)`.
