---
title: "LeetCode 3707: Equal Score Substrings"
summary: "LeetCode 3707 note: accumulate the left score while scanning, with the right side as total minus left; scores are alphabet positions 1 to 26, not ord"
description: "LeetCode 3707 record from 2025-10-11"
date: 2025-10-11
tags: ["easy", "prefix-sum", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-10-11
- Submissions: Wrong Answer → Accepted

## Approach

Compute the total score, then accumulate the left score from the left; the right side is `total - left` ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) Template 2). Both sides must be non-empty, so stop before the last character.

## My Attempts

Attempt 1 used `ord(char)` as the score. `ord` is the alphabet position plus 96, so sides of different lengths gain a different `96 × length`. For `"bac"`, `"ba"` scores 2 + 1 = 3 and `"c"` scores 3, so the answer is `True`; with `ord` it is 195 versus 99, returning `False`. Using `ord(char) - ord("a") + 1` passed.

## Solution

```python
class Solution:
    def scoreBalance(self, s: str) -> bool:
        scores = [ord(c) - ord("a") + 1 for c in s]
        total, left = sum(scores), 0
        for x in scores[:-1]:
            left += x
            if left * 2 == total:
                return True
        return False
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The score is the alphabet position 1 to 26: subtract `ord("a")` and add 1.
- The right side cannot be empty, so the last character is not a split point.

## Interview Explanation

I compute the whole string's score, then accumulate from the left; when the left is exactly half the total, a split works. Scores are alphabet positions, `ord(c) - ord('a') + 1`. Time `O(n)`.
