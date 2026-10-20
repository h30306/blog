---
title: "LeetCode 1147: Longest Chunked Palindrome Decomposition"
summary: "LeetCode 1147 note: build strings inward from both ends and cut a pair as soon as they match; cutting early is best, and any leftover middle counts as one chunk"
description: "LeetCode 1147 record from 2026-07-01"
date: 2026-07-01
tags: ["hard", "dynamic-programming", "greedy", "two-pointers", "rolling-hash", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-01
- Submissions: Accepted ×2 (written on 2026-07-01 and 08-24)

## Approach

**Greedy: cut as soon as a prefix equals the matching suffix**.

Cutting early is best: if the shortest equal prefix/suffix is `A` and a longer one `B` is taken as a chunk, `B` starts and ends with `A`, so it splits further into `A + middle + A`, giving more chunks.

Two pointers move inward, accumulating `left_str` on the left and prepending to `right_str` on the right; when they match, add 2 chunks and start over. At the end:

- if the pointers meet on one character (the center of an odd length), or
- there is an unmatched string left,

that middle part is one more chunk.

## My Solution

```python
class Solution:
    def longestDecomposition(self, text: str) -> int:
        left, right = 0, len(text) - 1
        left_str = right_str = ""
        chunks = 0
        while left < right:
            left_str += text[left]
            right_str = text[right] + right_str
            if left_str == right_str:              # cut as soon as possible
                chunks += 2
                left_str = right_str = ""
            left += 1
            right -= 1
        if left == right or left_str:              # the leftover middle is one chunk
            chunks += 1
        return chunks
```

## Complexity

Time `O(n^2)` (each string comparison is up to `O(n)`) with `n <= 1000`; rolling hashes make it `O(n)`. Space `O(n)`.

## Mistakes to Avoid

- Count the leftover middle as one chunk.
- Prepend on the right (`text[right] + right_str`) so the order matches the original string.

## Interview Explanation

Greedily I build strings inward from both ends and cut a pair as soon as they match, since a longer matching prefix/suffix could always be split into shorter ones for more chunks. If a middle part remains, it is one chunk. Time `O(n^2)`, or `O(n)` with rolling hashes.
