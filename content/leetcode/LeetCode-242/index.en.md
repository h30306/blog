---
title: "LeetCode 242: Valid Anagram"
summary: "LeetCode 242 note: two strings are anagrams exactly when their character counts match; compare Counters or sorted strings"
description: "LeetCode 242 record from 2022-08-22"
date: 2022-08-22
tags: ["easy", "hash-table", "string", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-22
- Submissions: Accepted ×3 → Runtime Error ×2 → Accepted → Runtime Error → Wrong Answer → Accepted → Wrong Answer ×4

## Approach

Anagrams have identical character counts ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1). `Counter(s) == Counter(t)` does it in one line; by hand, one dict gets `+1` for each character of `s` and `-1` for each of `t`, and **every** value must end at 0.

## My Attempts

In 2022-08 both `sorted` and `Counter` passed; then I tried counting by hand:

- `tracker.get(x, 0) + 1` **never stored the result**, so the map stayed empty and `all(...)` on nothing is `True`: `"a"` and `"c"` returned `True`.

A 2022-11 rewrite failed four more times:

- The second loop decremented `alpha_count[s]`, where `s` was the leftover variable from the first loop rather than the current character `t`, and only the **sum** was checked, letting positives and negatives cancel: `"ac"` and `"aa"` returned `True`.
- The last version used `not all(values)`, meaning "**some** count is 0": `"ba"` and `"b"` returned `True`.

## Solution

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False
        cnt = defaultdict(int)
        for a, b in zip(s, t):
            cnt[a] += 1
            cnt[b] -= 1
        return all(v == 0 for v in cnt.values())
```

## Complexity

Time `O(n)`, space `O(k)` for `k` distinct characters.

## Mistakes to Avoid

- Check that **every** count is 0, not their sum: `+1` and `-1` cancel out.
- `tracker.get(x, 0) + 1` computes a value but never stores it.

## Interview Explanation

One hash map adds one for each character of the first string and subtracts one for the second; if every count ends at zero, they are anagrams. Time `O(n)`; with lowercase letters only, a size-26 array works.
