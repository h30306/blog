---
title: "LeetCode 819: Most Common Word"
summary: "LeetCode 819 note: replace punctuation with spaces, lowercase, split, count, and pick the most frequent word not banned"
description: "LeetCode 819 record from 2022-09-14"
date: 2022-09-14
tags: ["easy", "array", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-14
- Submissions: Wrong Answer ×2 → Runtime Error → Wrong Answer → Accepted ×2 → Wrong Answer → Accepted

## Approach

Normalize first: **replace** non-letters with spaces (deleting them would glue `a,b` into `ab`), lowercase, and `split()` ([String]({{< relref "/algorithm/String" >}}) Template 4). Put banned in a set, skip it while counting ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1), and take the most frequent.

## My Attempts

This took 8 submissions, each missing one normalization detail:

- Attempt 1 used `paragraph[:-1]` to drop trailing punctuation, **but there may be none**: `"a"` became an empty string.
- Attempt 2 **deleted** punctuation: `"a'a"` became `"aa"`, while the answer is `"a"`.
- After switching to spaces, one version had a misspelled variable (NameError) and two **forgot to lowercase**: `"Bob"` returned `"Bob"` instead of `"bob"`.

## Solution

```python
class Solution:
    def mostCommonWord(self, paragraph: str, banned: List[str]) -> str:
        words = "".join(c.lower() if c.isalpha() else " " for c in paragraph).split()
        ban = set(banned)
        cnt = Counter(w for w in words if w not in ban)
        return cnt.most_common(1)[0][0]
```

## Complexity

Time `O(n + b)`, space `O(n + b)`.

## Mistakes to Avoid

- Replace punctuation with spaces rather than deleting it.
- Matching is case-insensitive; lowercase everything.
- Do not drop the last character: the paragraph need not end with punctuation.

## Interview Explanation

I turn non-letters into spaces, lowercase, split, skip banned words via a set while counting, and return the most frequent word. Time `O(n + b)`.
