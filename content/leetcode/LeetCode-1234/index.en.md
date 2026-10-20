---
title: "LeetCode 1234: Replace the Substring for Balanced String"
summary: "LeetCode 1234 note: after replacing a window, every character outside it must be at most n / 4; a shortest-window slide tracks the counts outside the window"
description: "LeetCode 1234 record from 2026-01-18"
date: 2026-01-18
tags: ["medium", "sliding-window", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-18
- Submissions: Accepted (first try)

## Approach

Replacing the window leaves the characters **outside** it untouched. For the whole string to balance, each character outside must be `<= n / 4` (only then can the window make up the rest).

Conversely, whenever every character outside is `<= n / 4`, the window can always be filled to balance. So:

- Keep `outside[c]`, the count outside the window.
- Use the "shortest" sliding window: add on the right (`outside` minus one), update the answer while valid, then try shrinking the left (`outside` plus one).

If the string is already balanced, the answer is 0.

## My Solution

```python
class Solution:
    def balancedString(self, s: str) -> int:
        n = len(s)
        target = n // 4
        outside = Counter(s)                       # counts outside the window
        if all(outside[c] <= target for c in "QWER"):
            return 0

        left = 0
        best = n
        for right, c in enumerate(s):
            outside[c] -= 1
            while left <= right and all(outside[ch] <= target for ch in "QWER"):
                best = min(best, right - left + 1)
                outside[s[left]] += 1
                left += 1
        return best
```

My original first computed how many extra copies of each character there were, required the window to contain those extras, and used `meet_count` to track how many kinds were covered. It means the same thing, but "nothing outside exceeds `n / 4`" is shorter.

## Complexity

Time `O(n)` (4 characters checked each time), space `O(1)`.

## Mistakes to Avoid

- Return 0 when the string is already balanced.
- The validity check is about **outside** the window, not inside.

## Interview Explanation

Replacing a block leaves everything outside it unchanged, so the string can be balanced exactly when each character outside appears at most `n / 4` times. I track the counts outside the window with a shortest-window slide, updating the answer while valid and then shrinking the left. If it is balanced from the start, return 0. Time `O(n)`.
