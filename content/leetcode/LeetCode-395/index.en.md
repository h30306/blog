---
title: "LeetCode 395: Longest Substring with At Least K Repeating Characters"
summary: "LeetCode 395 note: \"every character at least k times\" is not monotonic, so a direct slide fails; divide and conquer splits on characters with fewer than k occurrences, or fixing the number of distinct characters makes the window slidable"
description: "LeetCode 395 record from 2026-01-17"
date: 2026-01-17
tags: ["medium", "sliding-window", "divide-and-conquer", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-17
- Submissions: WA → RE ×2 → WA ×2 → AC (divide and conquer) → AC ×2 (sliding window)

## Approach

"Every character in the window at least `k` times" is **not monotonic**: growing the window can make it invalid (a character appears once) or valid (a character reaches `k`). So "shrink the left when invalid" does not apply directly.

### Divide and conquer

If a character appears fewer than `k` times in the whole string, the answer cannot contain it. Split the string on it and recurse on each part. When every character reaches `k`, the whole string is the answer.

### Sliding window with a fixed number of distinct characters

**Add a constraint that restores monotonicity**: the window has exactly `t` distinct characters. Shrinking when there are more than `t` is monotonic. Run once for each `t = 1..26`, and update the answer when the window has `t` distinct characters that all reach `k`.

## My Attempts

The first few versions slid directly, using `not_enough` to count occurrences of characters below `k`, and jumped the left end past any character whose total count was below `k`.

| Version | Problem |
|---|---|
| Attempt 1, WA | After the jump, the counts were not reset, so characters outside the window stayed counted. For `s = "cbb"`, `k = 2`, the answer is 2 (`"bb"`); it returned 0 |
| Two REs | Switched to running forward and backward; once a colon was missing, then the helper forgot to `return` |
| Attempt 4, WA | Added the `return`, but counts still were not reset. For `s = "caab"`, `k = 2`, the answer is 2; it returned 0 |
| Attempt 5, WA | Reset the counts, but the method itself is wrong: the condition is not monotonic, so the left end cannot tell whether to shrink. For `s = "bcccbab"`, `k = 3`, the answer is 3 (`"ccc"`); it returned 0 |

Divide and conquer then passed, and I wrote the fixed-distinct-count window afterwards.

## Solution

Divide and conquer:

```python
class Solution:
    def longestSubstring(self, s: str, k: int) -> int:
        for c, cnt in Counter(s).items():
            if cnt < k:                            # the answer cannot contain c
                return max(self.longestSubstring(part, k) for part in s.split(c))
        return len(s)
```

Sliding window with a fixed number of distinct characters:

```python
class Solution:
    def longestSubstring(self, s: str, k: int) -> int:
        best = 0
        for target in range(1, len(set(s)) + 1):   # exactly `target` distinct characters
            cnt = Counter()
            left = unique = enough = 0             # enough: distinct characters at k or more
            for right, c in enumerate(s):
                if cnt[c] == 0:
                    unique += 1
                cnt[c] += 1
                if cnt[c] == k:
                    enough += 1
                while unique > target:
                    d = s[left]
                    if cnt[d] == k:
                        enough -= 1
                    cnt[d] -= 1
                    if cnt[d] == 0:
                        unique -= 1
                    left += 1
                if unique == target and enough == target:
                    best = max(best, right - left + 1)
        return best
```

## Complexity

- Divide and conquer: each level removes at least one character, so at most 26 levels of `O(n)`: `O(26n)`.
- Sliding window: `O(26n)`, space `O(26)`.

## Mistakes to Avoid

- Sliding directly when the condition is not monotonic.
- Not resetting the counts when jumping the left end.

## Interview Explanation

"Every character at least `k` times" is not monotonic, so a direct slide fails. One way is divide and conquer: a character with fewer than `k` occurrences cannot be in the answer, so split on it and recurse. Another is to add a constraint, enumerating the exact number of distinct characters in the window, which makes shrinking monotonic, then checking whether all of them reach `k`. Both are `O(26n)`.
