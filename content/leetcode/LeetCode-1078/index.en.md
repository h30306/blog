---
title: "LeetCode 1078: Occurrences After Bigram"
summary: "LeetCode 1078 note: split into words and check every three consecutive words, collecting the third when the first two match"
description: "LeetCode 1078 record from 2022-10-04"
date: 2022-10-04
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-10-04
- Submissions: Runtime Error → Accepted ×3

## Approach

Split into words and check each `i` ([String]({{< relref "/algorithm/String" >}}) Template 6): if `words[i] == first` and `words[i + 1] == second`, collect `words[i + 2]`. Looping only to `len(words) - 2` guarantees the third word exists.

## My Attempts

Attempt 1 checked only `i + 1 < len(text)` **but read `text[i + 2]`**: `"b b"` with `first = second = "b"` raised IndexError. Checking `i + 2` passed.

## Solution

```python
class Solution:
    def findOcurrences(self, text: str, first: str, second: str) -> List[str]:
        w = text.split()
        return [w[i + 2] for i in range(len(w) - 2)
                if w[i] == first and w[i + 1] == second]
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Since `i + 2` is accessed, bound-check `i + 2`.

## Interview Explanation

I split into words and check every window of three, collecting the third when the first two equal first and second, looping only up to the third-to-last word. Time `O(n)`.
