---
title: "LeetCode 3306: Count of Substrings Containing Every Vowel and K Consonants II"
summary: "LeetCode 3306 note: \"exactly k consonants\" is not monotonic; compute \"all five vowels and at least k consonants\" minus \"at least k + 1\", both \"at least\" counting windows"
description: "LeetCode 3306 record from 2026-01-21"
date: 2026-01-21
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
First Attempt: 2026-01-21
- Submissions: Wrong Answer ×2 → Accepted → Runtime Error → Accepted

## Approach

"Exactly `k` consonants" is not monotonic. But "all five vowels and **at least** `m` consonants" is (a larger window only makes it easier), so:

```text
exactly k = at least k − at least k + 1
```

The "at least" count: shrink while valid until invalid, then `count += left`.

## My Attempts

My version took another route: with exactly `k` consonants, extra vowels on the left can be dropped or kept, so `extra` tracked "how many more vowels can be dropped on the left", adding `1 + extra` per right end.

| Version | Problem |
|---|---|
| Attempt 1 | Added only 1 per right end, ignoring the extra vowels on the left. For `word = "euioeaa"`, `k = 0`, the answer is 4; it returned 2 |
| Attempt 2 | Added `extra`, but as a local variable reset to 0 every round. Extra vowels dropped in earlier rounds were no longer counted; the same example returned 3 |
| AC | Moved `extra` outside the loop, resetting it only when too many consonants forced a consonant out |
| RE | A rewrite put `extra = 0` inside the consonant-shrinking loop, so when no shrink happened `extra` was undefined: UnboundLocalError |
| AC | Moved the initialization back outside the loop |

The `extra` approach works, but needs care about when to reset it; the at-least difference needs no extra state.

## Solution

```python
class Solution:
    def countOfSubstrings(self, word: str, k: int) -> int:
        def at_least(m: int) -> int:               # all five vowels, at least m consonants
            vowels = Counter()
            consonants = left = count = 0
            for c in word:
                if c in "aeiou":
                    vowels[c] += 1
                else:
                    consonants += 1
                while len(vowels) == 5 and consonants >= m:
                    d = word[left]
                    if d in "aeiou":
                        vowels[d] -= 1
                        if vowels[d] == 0:
                            del vowels[d]
                    else:
                        consonants -= 1
                    left += 1
                count += left
            return count

        return at_least(k) - at_least(k + 1)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Sliding directly on "exactly": not monotonic, and extra vowels on the left get missed.
- With the `extra` approach, reset it only when a consonant leaves.

## Interview Explanation

"Exactly `k` consonants" is not monotonic, so I compute "at least `k`" minus "at least `k + 1`". "All five vowels and at least `m` consonants" is monotonic, so an "at least" sliding window shrinks while valid, and every left end from 0 to `left - 1` is valid, so I add `left`. Time `O(n)`.
