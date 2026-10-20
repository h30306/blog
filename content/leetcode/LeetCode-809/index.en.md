---
title: "LeetCode 809: Expressive Words"
summary: "LeetCode 809 note: two pointers compare runs of equal characters; when the lengths differ, the run in s must be at least 3 and no shorter than the word's run, and both strings must end together"
description: "LeetCode 809 record from 2026-01-31"
date: 2026-01-31
tags: ["medium", "two-pointers", "string", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-31
- Submissions: Runtime Error → Wrong Answer ×2 → Accepted

## Approach

View a string as runs of equal characters, e.g. `"heeellooo"` is `h1 e3 l2 o3`. `word` can stretch into `s` when both have the same number of runs and every run:

- has the same character;
- has the same length, **or** the run in `s` has length `>= 3` and `>=` the word's run (runs can only be extended to 3 or more, never shortened).

Two pointers walk `s` and `word`, each consuming a whole run per step, and compare lengths. **After the loop both strings must be fully consumed**, or one side has leftover runs.

## My Attempts

Every mistake here was in the termination condition:

| Version | Problem |
|---|---|
| Attempt 1, RE | The loop checked only `left < n`, so once `word` ran out it still read `word[right]`. `s = "aab"`, `word = "aa"` raises IndexError |
| Attempt 2, WA | Changed to `left < n and right < m` but returned `True` after the loop without checking leftovers in `s`. The same `"aab"` / `["aa"]` returned 1; the answer is 0 |
| Attempt 3, WA | Added `left == n` but not a check for leftovers in `word`. `s = "abc"`, `word = "abcd"` returned 1; the answer is 0 |

Requiring `left == n and right == m` passed.

## Solution

```python
class Solution:
    def expressiveWords(self, s: str, words: List[str]) -> int:
        def run_end(t: str, i: int) -> int:           # end (exclusive) of the run starting at i
            j = i
            while j < len(t) and t[j] == t[i]:
                j += 1
            return j

        def stretchy(word: str) -> bool:
            i = j = 0
            while i < len(s) and j < len(word):
                if s[i] != word[j]:
                    return False
                ni, nj = run_end(s, i), run_end(word, j)
                len_s, len_w = ni - i, nj - j
                if len_s != len_w and (len_s < 3 or len_s < len_w):
                    return False
                i, j = ni, nj
            return i == len(s) and j == len(word)

        return sum(stretchy(w) for w in words)
```

## Complexity

Time `O(len(s) · number of words + total length of words)`, space `O(1)`.

## Mistakes to Avoid

- Driving the loop by one string's length only: the other may run out first and go out of range.
- Not checking that **both** strings are consumed at the end.
- Getting the length rule backwards: the run in `s` may be longer, never shorter than in `word`.

## Interview Explanation

I treat strings as runs of equal characters. Two pointers each consume a whole run and compare character and length: equal lengths are fine; otherwise the run in `s` must be at least 3 and no shorter than in `word`. After the loop, both strings must be fully consumed. Each word is one linear scan.
