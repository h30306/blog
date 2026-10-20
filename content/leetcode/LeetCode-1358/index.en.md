---
title: "LeetCode 1358: Number of Substrings Containing All Three Characters"
summary: "LeetCode 1358 note: an \"at least one each of a, b, c\" counting window: keep shrinking while all three are present, then count += left"
description: "LeetCode 1358 record from 2026-01-19"
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
- Submissions: Wrong Answer → Accepted

## Approach

The same "at least" counting pattern as [LeetCode 2962]({{< relref "/leetcode/LeetCode-2962" >}}): while all three characters are present, keep shrinking the left until one is missing; every left end in `[0, left)` is valid, so `count += left`.

## My Attempts

Attempt 1 used `len(set(s))` as the target number of kinds instead of a fixed 3. If the string has only two kinds, e.g. `s = "abb"`, the target became 2 and every substring with `a` and `b` counted, returning 2; without a `c` nothing is valid, so the answer is 0.

## Solution

```python
class Solution:
    def numberOfSubstrings(self, s: str) -> int:
        cnt = Counter()
        left = count = 0
        for c in s:
            cnt[c] += 1
            while len(cnt) == 3:                   # all three present: keep shrinking
                cnt[s[left]] -= 1
                if cnt[s[left]] == 0:
                    del cnt[s[left]]
                left += 1
            count += left
        return count
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The target is always 3 kinds, not however many appear in the string.

## Interview Explanation

This is an "at least" count: while all three characters are in the window I keep shrinking the left until one is missing, and then every left end from 0 to `left - 1` gives a substring with all three, so I add `left`. Time `O(n)`.
