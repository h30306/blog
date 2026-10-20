---
title: "LeetCode 2953: Count Complete Substrings"
summary: "LeetCode 2953 note: split where neighboring letters differ by more than 2; in each segment enumerate the number of distinct letters d, slide a fixed window of d × k, and track how many letters appear exactly k times"
description: "LeetCode 2953 record from 2026-01-04"
date: 2026-01-04
tags: ["hard", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-04
- Submissions: Wrong Answer ×3 → Accepted

## Approach

Handle the two conditions separately:

1. **Neighbors differ by `<= 2`**: wherever a letter differs from the previous one by `> 2`, no complete substring can cross. So **split into segments** there and count each separately.
2. **Every letter exactly `k` times**: with `d` distinct letters the length must be `d × k`. `d` is only 1 to 26, so run one **fixed-length `d × k`** sliding window per `d`.

The window tracks `good`, the number of letters appearing exactly `k` times. Length `d × k` with `good == d` means those `d` letters appear `k` times each and nothing else is present.

`good` changes only when a count crosses `k`: reaching `k` on add is +1, reaching `k + 1` is -1, and the reverse on removal.

## My Attempts

My approach scanned the whole string for each window size `k, 2k, ..., 26k`, resetting the window at positions where the difference was `> 2`.

| Version | Problem |
|---|---|
| Attempt 1 | The shrink condition was `right - left > win_size` and there was no check that the length equals `win_size`, so wrong-length windows were counted. For `word = "bd"`, `k = 1`, the answer is 3 (`b`, `d`, `bd`); it returned 4 |
| Attempt 2 | Added the length check, but at a break it reset the window and `continue`d **without adding the break character to the new window**. For `word = "ah"`, `k = 1`, the answer is 2; it returned 1 |
| Attempt 3 | Added the break character, but still `continue`d past the check for the length-1 window; the same example still returned 1 |
| Attempt 4, AC | Reordered the steps and added a `win_size > 1` condition; it passed in 5.5 seconds |

Each window rechecked every count with `for c in count.values()`, which is why it was slow. Splitting first and maintaining a `good` counter makes each move `O(1)`.

## Solution

```python
class Solution:
    def countCompleteSubstrings(self, word: str, k: int) -> int:
        def count_segment(seg: str) -> int:
            res = 0
            for d in range(1, 27):                 # d distinct letters in the substring
                size = d * k
                if size > len(seg):
                    break
                cnt = [0] * 26
                good = 0                           # letters appearing exactly k times
                for right, ch in enumerate(seg):
                    c = ord(ch) - 97
                    cnt[c] += 1
                    if cnt[c] == k:
                        good += 1
                    elif cnt[c] == k + 1:
                        good -= 1
                    if right >= size:
                        c = ord(seg[right - size]) - 97
                        if cnt[c] == k:
                            good -= 1
                        elif cnt[c] == k + 1:
                            good += 1
                        cnt[c] -= 1
                    if right >= size - 1 and good == d:
                        res += 1
            return res

        total = start = 0
        for i in range(1, len(word) + 1):
            if i == len(word) or abs(ord(word[i]) - ord(word[i - 1])) > 2:
                total += count_segment(word[start:i])
                start = i
        return total
```

## Complexity

Time `O(26 · n)`, space `O(26)` excluding the sliced segments.

## Mistakes to Avoid

- Not fixing the window length: "every letter exactly `k` times" is not monotonic, so fix the number of distinct letters first.
- Break handling: splitting into segments first is cleanest, rather than special-casing inside the window.
- Rechecking every letter's count per window: a large constant factor.

## Interview Explanation

Substrings cannot cross a place where neighbors differ by more than 2, so I split the string into segments. Every letter appearing exactly `k` times means the length is the number of distinct letters times `k`, so per segment I try `d` from 1 to 26 with a fixed window of `d × k`, tracking how many letters appear exactly `k` times; when that equals `d` the substring is complete. `O(26n)` overall.
