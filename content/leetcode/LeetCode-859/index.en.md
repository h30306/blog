---
title: "LeetCode 859: Buddy Strings"
summary: "LeetCode 859 note: lengths must match; identical strings need a repeated character; otherwise exactly two positions differ and cross-match"
description: "LeetCode 859 record from 2022-09-17"
date: 2022-09-17
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-17
- Submissions: Runtime Error ×2 → Wrong Answer ×3 → Accepted ×3

## Approach

Three cases:

1. Different lengths: impossible.
2. `s == goal`: the swap must exchange two **equal characters**, so `s` needs a repeat (`len(set(s)) < len(s)`).
3. Otherwise collect the differing positions; there must be **exactly two**, `i, j`, with `s[i] == goal[j]` and `s[j] == goal[i]`.

## My Attempts

This took 8 submissions, each adding one case:

- The first two had variable bugs: the counter was incremented before `d1` and `d2` were set, so `d1` was never assigned (NameError).
- Attempt 3 ignored **identical strings**: `"c"`, `"c"` must still swap once, impossible without a repeated character, so the answer is `False`; it returned `True`.
- After that fix, **a single differing position** still returned `True`: `"a"`, `"c"`. Failing on exactly one difference passed.

## Solution

```python
class Solution:
    def buddyStrings(self, s: str, goal: str) -> bool:
        if len(s) != len(goal):
            return False
        if s == goal:
            return len(set(s)) < len(s)
        diff = [i for i in range(len(s)) if s[i] != goal[i]]
        return len(diff) == 2 and s[diff[0]] == goal[diff[1]] and s[diff[1]] == goal[diff[0]]
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- One swap is mandatory: identical strings qualify only with a repeated character.
- With a single differing position no swap can fix it.

## Interview Explanation

I rule out different lengths; identical strings need a repeated character to swap; otherwise there must be exactly two differing positions that cross-match. Time `O(n)`.
