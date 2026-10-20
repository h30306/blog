---
title: "LeetCode 1178: Number of Valid Words for Each Puzzle"
summary: "LeetCode 1178 note: a word only matters by its set of letters, so count 26-bit masks and enumerate each puzzle's submasks"
description: "LeetCode 1178 record from 2026-08-28"
date: 2026-08-28
tags: ["hard", "bit-manipulation", "hash-map", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-28
- Submissions: Accepted (first try)

## Approach

A word is valid for a puzzle when:

1. It contains the puzzle's first letter.
2. Every letter of the word appears in the puzzle.

Both conditions depend only on **which letters are used**, not their order or counts. So each word compresses to a 26-bit mask, and a `Counter` records how many words have each mask.

Each puzzle has exactly 7 letters, so:

- A valid word's mask is "a subset of the puzzle mask that includes the first letter".
- Apart from the first letter, the other 6 letters have only `2^6 = 64` subsets.

For each puzzle, enumerate those 64 subsets, add the first letter, and sum the `Counter` lookups.

### Enumerating subsets

```python
sub = mask
while True:
    process(sub)
    if sub == 0:
        break
    sub = (sub - 1) & mask
```

`(sub - 1) & mask` walks through every subset of `mask` from largest to smallest, ending at 0.

## My Solution

```python
from collections import Counter

class Solution:
    def findNumOfValidWords(self, words: List[str], puzzles: List[str]) -> List[int]:
        def to_mask(s: str) -> int:
            m = 0
            for ch in s:
                m |= 1 << (ord(ch) - ord("a"))
            return m

        word_count = Counter(to_mask(w) for w in words)

        res = []
        for p in puzzles:
            first = 1 << (ord(p[0]) - ord("a"))
            rest = to_mask(p[1:])
            count = 0
            sub = rest
            while True:
                count += word_count[sub | first]
                if sub == 0:
                    break
                sub = (sub - 1) & rest
            res.append(count)
        return res
```

Separating the first letter and enumerating subsets of the other 6 letters, then OR-ing in `first`, guarantees every mask includes the first letter.

## Complexity

Time `O(W + P · 2^6)`, where `W` is the total length of all words and `P` the number of puzzles. Space `O(number of words)`.

## Mistakes to Avoid

- Checking every word against every puzzle: `10^5 × 10^4` is too slow.
- Including the first letter in the enumerated subsets: masks without it get enumerated too.
- Skipping the empty subset: a word using only the first letter (e.g. `"aaaa"`) is found through the empty subset plus `first`.

## Interview Explanation

Validity depends only on the set of letters a word uses, so I convert each word to a 26-bit mask and count them. A puzzle has 7 letters, and a valid word's mask must be a subset of the puzzle's mask that includes the first letter, so I enumerate the 64 subsets of the other 6 letters, add the first letter, and look each up in the counter. Time `O(W + 64P)`. LeetCode tags it as Trie, but bitmasks are more direct.
