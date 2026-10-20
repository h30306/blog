---
title: "LeetCode 3298: Count Substrings That Can Be Rearranged to Contain a String II"
summary: "LeetCode 3298 note: rearrangeable to start with word2 ⇔ every character count is at least word2's; an \"at least\" counting window where meet tracks how many characters have reached their target"
description: "LeetCode 3298 record from 2026-01-20"
date: 2026-01-20
tags: ["hard", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-20
- Submissions: Accepted (first try)

## Approach

A substring can be rearranged to start with `word2` ⇔ **each character count is `>=` its count in `word2`**. That is monotonic, so use the "at least" count:

- `need = Counter(word2)`, and `meet` = how many character kinds have reached their target.
- When adding a character makes its count exactly `need[c]`, `meet += 1`.
- While `meet == len(need)`, keep shrinking the left; when a count falls from `need[c]` to `need[c] - 1`, `meet -= 1`.
- `count += left`.

The problem requires linear time; each step touches one character, and `meet` keeps the check `O(1)` instead of comparing whole count tables.

## My Solution

```python
class Solution:
    def validSubstringCount(self, word1: str, word2: str) -> int:
        need = Counter(word2)
        have = Counter()
        meet = left = count = 0
        for c in word1:
            have[c] += 1
            if have[c] == need[c]:
                meet += 1
            while meet == len(need):
                d = word1[left]
                if have[d] == need[d]:
                    meet -= 1                      # no longer enough after removal
                have[d] -= 1
                left += 1
            count += left
        return count
```

For characters not in `word2`, `need[c] = 0`: `have[c]` goes from 0 to 1 and never equals 0, so `meet` is unaffected; on removal `have[d]` is `>= 1`, also not 0.

## Complexity

Time `O(n + m)`, space `O(26)`.

## Mistakes to Avoid

- Comparing whole count tables each step: a large constant, and this problem's time and memory limits are tight.
- When looking up characters absent from `word2` in a `Counter`, `need[c]` is 0; make sure `meet` is not bumped by mistake.

## Interview Explanation

Being rearrangeable to start with `word2` means every character count is at least `word2`'s, which is monotonic. I use an "at least" sliding window where `meet` tracks how many kinds have reached their target; while all have, I shrink the left until one falls short, and every left end from 0 to `left - 1` is valid, so I add `left`. Time `O(n + m)`.
