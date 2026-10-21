---
title: "LeetCode 3900: Longest Balanced Substring After One Swap"
summary: "LeetCode 3900 note: equal prefix differences mean balanced; a substring off by 2 also works if a swappable character exists outside, and keeping the two earliest positions per difference is enough"
description: "LeetCode 3900 record from 2026-04-12"
date: 2026-04-12
tags: ["medium", "prefix-sum", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-12
- Submissions: Wrong Answer ×3 → Accepted

## Approach

Let `d[p]` be `ones - zeros` over the first `p` characters. Substring `s[q:p]` is balanced exactly when `d[p] == d[q]` ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) Template 3).

One swap can trade a 1 inside the substring for a 0 outside (or the reverse), shifting the difference by 2:

- `d[p] - d[q] == 2` (two extra 1s): needs a 0 **outside**, i.e. `zeros inside < total zeros`.
- `d[p] - d[q] == -2` (two extra 0s): needs a 1 outside.

For the longest, use the earliest `q`. If the earliest fails (every 0 is inside), the second earliest `q'` always works: `s[q:q']` has difference 0 and length at least 2, so it contains a 0, which is now outside. So keep only the **two earliest** positions per difference.

## My Attempts

The first three versions used a sliding window, trying to keep it "off by at most 2 with something swappable nearby":

1. Attempt 1's shrink condition was incomplete and even counted odd-length windows. For `"001"` the answer is 2; it returned 3.
2. Attempt 2 only checked for swappable characters to the right, shrinking windows that were already balanced. For `"000111"` the whole string is balanced, answer 6; it returned 4.
3. Attempt 3 used `max(count) × 2` as the length, as if one swap could fix any imbalance. For `"0011111100"` the answer is 6; it returned 8.

Balance is not monotonic, so shrinking a window does not necessarily help; switching to prefix differences + a hash map passed.

## Solution

```python
class Solution:
    def longestBalanced(self, s: str) -> int:
        total0, total1 = s.count("0"), s.count("1")
        first = {0: [0]}                       # difference -> two earliest prefix lengths
        zeros = [0]                            # zeros[p]: number of 0s in s[:p]
        d = best = 0
        for p, ch in enumerate(s, 1):
            d += 1 if ch == "1" else -1
            zeros.append(zeros[-1] + (ch == "0"))
            if d in first:                     # already balanced
                best = max(best, p - first[d][0])
            for q in first.get(d - 2, ()):     # two extra 1s: need a 0 outside
                if zeros[p] - zeros[q] < total0:
                    best = max(best, p - q)
                    break
            for q in first.get(d + 2, ()):     # two extra 0s: need a 1 outside
                if (p - q) - (zeros[p] - zeros[q]) < total1:
                    best = max(best, p - q)
                    break
            pos = first.setdefault(d, [])
            if len(pos) < 2:
                pos.append(p)
        return best
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Balance is not monotonic; do not use a sliding window.
- One swap only fixes a substring off by 2, and only if a matching character exists outside.

## Interview Explanation

I use prefix `ones - zeros`; two positions with equal differences bound a balanced substring. One swap fixes a substring off by 2 if the needed character exists outside. The longest uses the earliest position, and when the earliest fails the second earliest always works, so I keep two positions per difference. Time `O(n)`.
