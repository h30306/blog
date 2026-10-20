---
title: "LeetCode 2781: Length of the Longest Valid Substring"
summary: "LeetCode 2781 note: forbidden words are at most 10 long, so each right end checks only the last 10 suffixes; on a match push the left end past it, using the shortest match (the rightmost start)"
description: "LeetCode 2781 record from 2026-01-14"
date: 2026-01-14
tags: ["hard", "sliding-window", "hash-table", "string", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-14
- Submissions: WA ×2 → AC → TLE → WA → AC ×2 (the Trie version was written on 2026-01-15)

## Approach

A window `[left, right]` is valid ⇔ it contains no forbidden word. Adding a character on the right creates **new substrings that all end at `right`**, so only suffixes ending at `right` need checking.

Forbidden words have at most 10 characters, so check suffixes of length 1 to 10:

- Check from short to long (start `i` moving left from `right`); the first forbidden suffix has the rightmost start.
- Move the left end to `i + 1` and **`break`**: a longer forbidden word starts further left, and moving there would not be enough.

A suffix may not start before `left` (those characters are already outside the window).

## My Attempts

Neither of the first two versions had a `break`. Checking short to long, a short forbidden word pushed `left` to `i + 1`, then a longer one set `left` to a smaller `i + 1`, **moving the left end backward** so the window again contained the short word.

For `word = "baba"`, `forbidden = ["a", "ba"]`, any substring with `a` is invalid, so the answer is 1 (`"b"`). At `right = 1`, `"a"` set `left = 2`, then `"ba"` set `left` back to 1, leaving the forbidden `"a"` in the window. At `right = 2`, `"ab"` then counted as valid, and both versions returned 2.

Adding `break` passed. I later rewrote it with a reversed Trie: the first try hit TLE from a missing `right += 1`, and the second got WA from the same missing `break`.

## Solution

```python
class Solution:
    def longestValidSubstring(self, word: str, forbidden: List[str]) -> int:
        banned = set(forbidden)
        max_len = max(map(len, forbidden))         # at most 10
        left = best = 0
        for right in range(len(word)):
            for i in range(right, max(left, right - max_len + 1) - 1, -1):
                if word[i:right + 1] in banned:
                    left = i + 1                   # the shortest match starts furthest right
                    break
            best = max(best, right - left + 1)
        return best
```

Trie version: insert forbidden words **reversed**, walk left from `right` while descending the Trie, stop when there is no edge, and on an end marker push `left` and `break`. It avoids slicing substrings.

## Complexity

Time `O(n · L^2)` (up to `L = 10` suffixes per right end, each slice and hash `O(L)`); the Trie version is `O(n · L)`. Space is the total length of the forbidden words.

## Mistakes to Avoid

- No `break` after a match: a longer forbidden word drags the left end back.
- Checking suffix starts before `left`: those are outside the window.

## Interview Explanation

A new character only creates substrings ending at it, and forbidden words are at most 10 long, so each right end checks just the last 10 suffixes. Checking short to long, the first match has the rightmost start, so I move the left end past it and stop, since a longer match would drag the left end back. Time `O(n · 10^2)`, and a reversed Trie avoids the slicing.
