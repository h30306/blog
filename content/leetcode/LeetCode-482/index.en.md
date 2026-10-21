---
title: "LeetCode 482: License Key Formatting"
summary: "LeetCode 482 note: remove every dash and uppercase first, then cut groups of k from the end so only the first group may be shorter"
description: "LeetCode 482 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Wrong Answer ×8 → Output Limit Exceeded → Accepted

## Approach

Only the first group may be shorter, so cut groups of `k` **from the end**. Remove every `-`, uppercase, take a first group of length `len % k` (or `k` when that is 0), then groups of `k`, joined with `"-".join` ([String]({{< relref "/algorithm/String" >}}) Template 1).

## My Attempts

This took 10 submissions, all on counting "a `-` every `k` characters from the back":

- The first four **did not uppercase**: `"a"` returned `"a"` instead of `"A"`.
- With `upper()` added, the counter started at 1 and used `c <= k`, **making groups of `k + 1`**: `"B2a"`, `k = 1` should be `"B-2-A"`; it returned `"B2-A"`.
- Switching to `c < k` sent the very first character into the `else` when `k = 1`, **adding a stray `-`**: `"2"` returned `"2-"`.
- Starting the counter at 0 fixed it, but a leftover `print` caused Output Limit Exceeded; removing it passed.

## Solution

```python
class Solution:
    def licenseKeyFormatting(self, s: str, k: int) -> str:
        t = s.replace("-", "").upper()
        first = len(t) % k or k
        groups = [t[:first]] + [t[i:i + k] for i in range(first, len(t), k)]
        return "-".join(g for g in groups if g)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Uppercase the result.
- Groups hold `k` characters; when counting from the back, the counter's start value and comparison must agree, or groups are off by one or a leading `-` appears.
- When `s` is all dashes the answer is empty.

## Interview Explanation

I strip dashes and uppercase, make the first group `len % k` long (or k when that is 0), cut the rest into groups of k, and join them with dashes. Time `O(n)`.
