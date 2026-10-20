---
title: "LeetCode 3799: Word Squares II"
summary: "LeetCode 3799 note: four nested levels pruned by corner letters; sorting the words first makes the output lexicographic"
description: "LeetCode 3799 record from 2026-01-04"
date: 2026-01-04
tags: ["medium", "backtracking", "enumeration", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-04
- Submissions: Accepted (first try)

## Approach

Four distinct words serve as the top, left, right, and bottom sides, and the corner letters must match:

```text
top[0] == left[0]      top[3] == right[0]
bottom[0] == left[3]   bottom[3] == right[3]
```

Choose `top → left → right → bottom` in order, checking each new word against those already chosen and skipping deeper levels on a conflict.

The output must be sorted by `(top, left, right, bottom)`: **sort the words first**, and enumerating the four levels in order already produces lexicographic order.

## My Solution

```python
class Solution:
    def wordSquares(self, words: List[str]) -> List[List[str]]:
        words.sort()
        res = []
        for top in words:
            for left in words:
                if left == top or left[0] != top[0]:
                    continue
                for right in words:
                    if right in (top, left) or right[0] != top[3]:
                        continue
                    for bottom in words:
                        if bottom in (top, left, right):
                            continue
                        if bottom[0] == left[3] and bottom[3] == right[3]:
                            res.append([top, left, right, bottom])
        return res
```

My submitted version left a `print([word1, word2])` in the second loop. It still passed, but heavy output slows things down and should be removed.

### Faster: group by first letter

Each level looks for words starting with a specific letter, so build `by_first[c] = words starting with c` and scan only that group in the inner loops.

## Complexity

Worst case `O(n^4)`, but the corner constraints cut down the combinations actually explored.

## Mistakes to Avoid

- Not checking that the four words are distinct.
- Collecting results and sorting afterwards works too, but sorting the words first makes it unnecessary.
- Leaving a debugging `print` in.

## Interview Explanation

I choose the top, left, right, and bottom words in order, checking at each step that the corner letters match the words already chosen and that no word repeats, and stop going deeper on a mismatch. Because the words are sorted first, enumerating the levels in order yields the required lexicographic order. Grouping words by first letter would let each level look only at plausible candidates.
