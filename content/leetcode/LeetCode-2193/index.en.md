---
title: "LeetCode 2193: Minimum Number of Moves to Make Palindrome"
summary: "LeetCode 2193 note: greedily fix the outer pair: take the last character and swap its leftmost partner to the front, costing that index; the unpaired character ends in the middle, costing its distance there"
description: "LeetCode 2193 record from 2026-09-02"
date: 2026-09-02
tags: ["hard", "two-pointers", "greedy", "string", "binary-indexed-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-02
- Submissions: Wrong Answer → Runtime Error → Wrong Answer → Accepted

## Approach

Fix the outermost pair each round, as if two pointers were closing in from both ends:

1. Take the last character `c = s[-1]` and find its leftmost occurrence `i`.
2. If `i` is not the last position, swap `s[i]` all the way to the front for `i` moves; the ends now match, so remove both and continue with the middle.
3. If `i` is the last position, `c` appears only once: it is the unpaired character and **must end in the middle**. Its distance to the middle is `i // 2`; add that and remove it.

Why anchor on the last character and use its leftmost partner: keeping the right end fixed and moving only the left partner is the cheapest way to fix this pair, and the leftmost partner crosses the fewest characters. Swaps involving the unpaired character do not change the relative order of the others, so its cost can be counted up front and the character removed.

## My Attempts

The algorithm was right from the start; the mistakes were about types and pasting:

1. **WA**: the unpaired cost was `i / 2`, a float in Python 3, so it returned something like `2.0` and was judged wrong.
2. **RE**: the `class Solution:` line was missing from the pasted code.
3. **WA**: same as the first, still returning a float.
4. **AC**: returned `int(res)`.

Integer division `i // 2` avoids this: `i` is always even at that point (the remaining length is odd), so `//` and `/` give the same value, but `//` stays an integer.

## Solution

```python
class Solution:
    def minMovesToMakePalindrome(self, s: str) -> int:
        s = list(s)
        moves = 0
        while s:
            i = s.index(s[-1])                     # leftmost occurrence of the last character
            if i == len(s) - 1:
                moves += i // 2                    # unpaired: distance to the middle
            else:
                moves += i                         # swap the partner to the front
                s.pop(i)
            s.pop()
        return moves
```

## Complexity

Time `O(n^2)`: each round's `index` and `pop` are `O(n)`, fine for `n <= 2000`. For speed, a Binary Indexed Tree (BIT) can track removed positions to compute move distances in `O(n log n)`.

## Mistakes to Avoid

- `/` is float division in Python 3; use `//` when counting.
- The unpaired cost is not `i`: it only needs to reach the middle, not the front.

## Interview Explanation

Each round I fix the outermost pair: take the last character, find its leftmost partner, swap the partner to the front at a cost of its index, and remove the pair. If the last character appears only once, it ends in the middle, so I add its distance to the middle and remove it. Each round is `O(n)`, `O(n^2)` total; a BIT over positions brings it to `O(n log n)`.
