---
title: "LeetCode 3823: Reverse Letters Then Special Characters in a String"
summary: "LeetCode 3823 note: two converging-pointer passes, swapping only letters the first time and only special characters the second"
description: "LeetCode 3823 record from 2026-01-31"
date: 2026-01-31
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-31
- Submissions: Accepted (first try)

## Approach

Reverse the letters back into the letter positions, then reverse the special characters back into theirs.

Each pass is "reverse while skipping the other kind of character" with converging pointers: each side skips ahead to a character of the kind being processed, they swap, and both move inward. The two passes touch disjoint positions, so their order does not matter.

## My Solution

```python
class Solution:
    def reverseByType(self, s: str) -> str:
        chars = list(s)

        def reverse(keep) -> None:
            left, right = 0, len(chars) - 1
            while left < right:
                while left < right and not keep(chars[left]):
                    left += 1
                while left < right and not keep(chars[right]):
                    right -= 1
                chars[left], chars[right] = chars[right], chars[left]
                left += 1
                right -= 1

        reverse(str.isalpha)
        reverse(lambda ch: not ch.isalpha())
        return "".join(chars)
```

My original wrote the two passes out separately with opposite conditions. Here "which kind to process" is a parameter, so both passes share one function.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Inner skipping loops without a `left < right` check: the pointers can cross the middle and swap the wrong positions.
- Modifying the string directly: convert it to a list first.

## Interview Explanation

I run two converging-pointer reversals: the first swaps only letters, with each pointer skipping non-letters; the second swaps only special characters. The passes touch disjoint positions, so they can be done separately. One reversal function takes the predicate as a parameter, and the total is `O(n)`.
