---
title: "LeetCode 3325: Count Substrings With K-Frequency Characters I"
summary: "LeetCode 3325 note: an \"at least one character appears k times\" counting window; when the new character reaches k, keep shrinking until it drops to k - 1"
description: "LeetCode 3325 record from 2026-01-19"
date: 2026-01-19
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
First Attempt: 2026-01-19
- Submissions: Wrong Answer → Runtime Error → Wrong Answer ×2 → Accepted

## Approach

"At least one character appears at least `k` times" is monotonic, so use the "at least" count:

- Add character `c` on the right; if `c` just reached `k`, the window is valid.
- While valid, keep shrinking the left until **some character's count falls from `k` to `k - 1`** (the only qualifying character just left).
- `count += left`.

Before adding `c` the window was invalid (no character at `k`), and only `c` can qualify after adding it, so valid ⇔ `cnt[c] >= k`, and shrinking until `cnt[c] < k` is enough.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1, WA | Hard-coded `k` as 2. For `s = "b"`, `k = 1`, the answer is 1; it returned 0 |
| Attempt 2, RE | Used `k`, but the "no longer valid" check on removal was count `== 1` instead of `== k - 1`. With `k = 1` the count drops to 0, never equals 1, and `left` ran off the string |
| Attempts 3–4, WA | Guarded with `left < n` and `left <= right` to stop the overflow, but the threshold was still wrong. For `s = "cc"`, `k = 1`, the answer is 3 and attempt 3 returned 4; for `s = "bbb"`, `k = 3`, the answer is 1 and attempt 4 returned 2 |
| AC | Changed the threshold to `== k - 1` |

## Solution

```python
class Solution:
    def numberOfSubstrings(self, s: str, k: int) -> int:
        cnt = Counter()
        left = count = 0
        for c in s:
            cnt[c] += 1
            while cnt[c] >= k:                     # only the new c can qualify
                cnt[s[left]] -= 1
                left += 1
            count += left
        return count
```

Using `cnt[c] >= k` directly is simpler than tracking a qualifying count and checking `== k - 1`, and leaves no threshold to get wrong.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Hard-coding `k`.
- The "leaves the target" threshold is `k - 1`, not 1.

## Interview Explanation

This is an "at least" count. Before adding a character the window is invalid, and afterwards only that character can reach `k`, so when it does I keep shrinking the left until it is below `k`; every left end from 0 to `left - 1` is then valid, so I add `left`. Time `O(n)`.
