---
title: "LeetCode 3816: Lexicographically Smallest String After Deleting Duplicate Characters"
summary: "LeetCode 3816 note: a monotonic stack that deletes a larger top while another copy exists, then trims duplicate letters off the end since a prefix is always smaller"
description: "LeetCode 3816 record from 2026-01-18"
date: 2026-01-18
tags: ["hard", "stack", "monotonic-stack", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-18
- Submissions: Wrong Answer ×5 (01-18) → RE, WA, RE, WA → Accepted → Accepted (07-27)

## Approach

You may delete any copy of a letter that currently appears at least twice; make the string lexicographically smallest. It resembles LC 316, except **each letter must keep at least one copy, not exactly one**.

Let `cnt[ch]` be how many `ch` the current string still has (on the stack plus unprocessed). Left to right:

1. On `c`, while the top is larger than `c` and `cnt[top] > 1` (another copy exists), delete it and decrement `cnt`.
2. Push `c`.

One more step at the end: **if the last letter still has another copy, delete it too**, because a prefix of a string is always lexicographically smaller, e.g. `"ab" < "abb"`.

## My Attempts

### January: deleting right to left, five WAs

I first scanned right to left, recording indices to delete and rebuilding the string at the end. The logic never captured "a larger letter before a smaller one should go", giving five WAs.

### July: a monotonic stack tracking too much

I switched to a monotonic stack while maintaining two counters, `count` (unprocessed) and `seen` (on the stack). Two Runtime Errors came from reading `stack[-1]` after `pop`, in the wrong order; two WAs came from trimming the end while checking only the original last character, not the new last character after each deletion.

The final version uses a single `cnt`, meaning "how many of this letter the current string still has". Decrementing it on deletion covers copies both on the stack and still ahead.

## Solution

```python
from collections import Counter

class Solution:
    def lexSmallestAfterDeletion(self, s: str) -> str:
        cnt = Counter(s)
        stack = []
        for ch in s:
            while stack and stack[-1] > ch and cnt[stack[-1]] > 1:
                cnt[stack.pop()] -= 1
            stack.append(ch)
        while cnt[stack[-1]] > 1:                 # trim duplicate letters off the end
            cnt[stack.pop()] -= 1
        return "".join(stack)
```

### Compared with LC 316

| | LC 316 | LC 3816 |
|---|---|---|
| Requirement | exactly one of each letter | at least one of each letter |
| Deletable when | it appears again later | more than one copy remains |
| Letter already on the stack | skipped | pushed anyway |
| At the end | nothing | trim trailing duplicates |

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Reading `stack[-1]` after `pop`: it is the new top, and the stack may already be empty.
- Not re-checking the new last letter on each trim step.
- Reusing the LC 316 approach: this one needs no `seen`, and needs the extra trimming step at the end.

## Interview Explanation

`cnt` tracks how many copies of each letter the current string has. I build the answer left to right with a monotonic stack: while the top is larger than the current letter and has another copy, delete it and decrement `cnt`. Afterwards, trailing letters with other copies are deleted too, since a prefix is always lexicographically smaller. Each character enters and leaves once, so time is `O(n)`.
