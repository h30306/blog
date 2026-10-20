---
title: "LeetCode 1750: Minimum Length of String After Deleting Similar Ends"
summary: "LeetCode 1750 note: when both ends match, each side eats its whole run of that character; a string of one repeated character can be deleted entirely"
description: "LeetCode 1750 record from 2026-01-24"
date: 2026-01-24
tags: ["medium", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-24
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Each operation deletes a prefix made of one repeated character and a suffix made of one repeated character, provided both use the same character and do not overlap.

Greedy: when both ends match, **deleting the whole run of that character on each end** never hurts. Deleting less just leaves the same character at the ends to be deleted next time.

With converging pointers:

1. When both ends are the same character, remember it as `c`.
2. Move the left pointer right past every `c`, and the right pointer left past every `c`.
3. Stop when the ends differ or the pointers cross; the remaining length is `right - left + 1`.

## My Attempts

### Attempt 1: returning the number deleted

```python
while left < right:
    if s[left] == s[right]:
        removed += 2
        left += 1
        right += 1          # should be right -= 1
    else:
        return removed      # the problem wants the remaining length
return removed
```

Three problems: it returned **the number of deleted characters** instead of the remaining length, so `"a"` returned 0 (correct: 1); the right pointer used `+= 1` and moved outward; and it deleted one character at a time instead of whole runs.

### Attempt 2: not stopping when the ends differ

The second version ate whole runs and returned `len(s) - removed`, but `left += 1` and `right -= 1` sat outside the `if`: **when the ends differed, the pointers still moved inward and kept deleting matching characters inside**. For `"aaab"`, the ends are `a` and `b`, so nothing can be deleted and the answer is 4; this version skipped the ends, deleted the inner `"aa"`, and returned 2.

Deletions only happen at the ends, so **stop as soon as the ends differ**. The final version puts "the ends match" into the `while` condition and ends the loop otherwise.

## Solution

```python
class Solution:
    def minimumLength(self, s: str) -> int:
        left, right = 0, len(s) - 1
        while left < right and s[left] == s[right]:
            c = s[left]
            while left <= right and s[left] == c:
                left += 1
            while right >= left and s[right] == c:
                right -= 1
        return right - left + 1
```

The left loop runs while `left <= right`, so when everything is `c`, the left pointer reaches `right + 1` and the answer is exactly 0.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Writing the right pointer update as `+= 1`.
- Deleting one character at a time.
- Continuing inward after the ends differ: deletions only happen at the ends, so stop as soon as they differ.
- Returning the number deleted instead of the remaining length.

## Interview Explanation

I use converging pointers: when both ends match, the left pointer eats every copy of that character moving right and the right pointer eats every copy moving left, since deleting more is always better. I stop when the ends differ or the pointers cross, and the remaining length is the answer; if everything was one character, the left pointer passes the right one and the length is 0. Time `O(n)`.
