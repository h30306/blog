---
title: "LeetCode 14: Longest Common Prefix"
summary: "LeetCode 14 note: bound by the shortest string and check each position across all strings; the first mismatch gives the answer's length"
description: "LeetCode 14 record from 2019-09-19"
date: 2019-09-19
tags: ["easy", "array", "string", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2019-09-19
- Submissions: Wrong Answer → Accepted → Wrong Answer → Runtime Error → Wrong Answer ×4 → Runtime Error → Wrong Answer ×3 → Accepted ×2

## Approach

The common prefix cannot exceed the shortest string. `zip(*strs)` yields every string's character at the same position; continue while they all match and stop at the first mismatch. **If the loop finishes, the whole shortest string is the prefix**, which must be returned too.

## My Attempts

The 2019 attempt submitted only two lines of special cases. In 2022-05 "compare each position of the shortest string" passed at once. A 2022-08 rewrite with `zip(*strs)` failed ten times, nearly all for one reason:

- **Nothing was returned when the loop finished normally**, only on a mismatch: `[""]`, where `zip` never runs, returned `None`.
- Adding a fallback returned `""`, **but finishing means the whole shortest string is the prefix**: `["a"]` should be `"a"`; it returned `""`. Going back to the shortest-string version passed.

## Solution

```python
class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        n = 0
        for chars in zip(*strs):
            if len(set(chars)) != 1:
                break
            n += 1
        return strs[0][:n]
```

## Complexity

Time `O(total characters)`, space `O(m)` for `m` strings.

## Mistakes to Avoid

- Return after the loop too, or a shortest string that is entirely the prefix yields `None`.
- With an empty string `zip` never runs and the answer is empty.

## Interview Explanation

With zip I take every string's character at each position, extend the length while they all match, stop at the first mismatch, and return that prefix of the first string. Time is linear in the total length.
