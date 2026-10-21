---
title: "LeetCode 1002: Find Common Characters"
summary: "LeetCode 1002 note: count each word and intersect all Counters (minimum count per character), then expand"
description: "LeetCode 1002 record from 2022-09-27"
date: 2022-09-27
tags: ["easy", "array", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-27
- Submissions: Runtime Error → Accepted ×3

## Approach

Each character appears in the answer as many times as its minimum count over **all words** ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1). Python's `Counter & Counter` takes per-character minimums; intersect over all words and expand with `elements()`.

## My Attempts

Attempt 1 intersected a `set` with a string (`set & str`, TypeError), and a set **drops multiplicity** anyway: `["bb"]` should give two `b`s. Switching to `Counter &` passed.

## Solution

```python
class Solution:
    def commonChars(self, words: List[str]) -> List[str]:
        common = Counter(words[0])
        for w in words[1:]:
            common &= Counter(w)
        return list(common.elements())
```

## Complexity

Time `O(total characters)`, space `O(k)`.

## Mistakes to Avoid

- `set` loses multiplicity: `["bb"]` gives `["b", "b"]`.
- `set & str` mixes types and raises TypeError.

## Interview Explanation

I count each word and intersect the Counters, taking each character's minimum count, then expand into a list. Time is linear in the total length.
