---
title: "LeetCode 402: Remove K Digits"
summary: "LeetCode 402 note: a monotonically increasing stack; while deletions remain, pop any top larger than the current digit, then strip leading zeros"
description: "LeetCode 402 record from 2022-11-17"
date: 2022-11-17
tags: ["medium", "string", "stack", "greedy", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-17
- Submissions: Wrong Answer ×2 → Runtime Error → Accepted ×2

## Approach

To minimize the result, earlier digits matter most ([Stack]({{< relref "/algorithm/Stack" >}}) Template 4). Keep an increasing stack from left to right: while the current digit is smaller than the top and deletions remain (`k > 0`), pop the top, since a smaller digit in an earlier position always wins. If `k` remains afterward, delete from the end (the rest increases, so the end is largest). Strip leading zeros and return `"0"` if nothing is left.

## My Attempts

- Attempt 1 guessed "take the minimum among the first `k + 1` digits", which is not the right greedy: `"22"`, `k = 1` returned `"22"`.
- Switching to "delete the first digit larger than its successor", the bound `i != len(num) - 1` was insufficient and `i` overran after deletions (IndexError), with no leading-zero stripping. `i < len(num) - 1` plus `str(int(num))` passed, though rebuilding the string per deletion costs `O(nk)`.

## Solution

```python
class Solution:
    def removeKdigits(self, num: str, k: int) -> str:
        st = []
        for d in num:
            while k and st and st[-1] > d:
                st.pop()
                k -= 1
            st.append(d)
        if k:
            st = st[:-k]
        return "".join(st).lstrip("0") or "0"
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- If `k` remains after the scan, delete from the end, as in `"22"`, `k = 1`.
- Strip leading zeros and return `"0"` for an empty result.
- Rebuilding the string after each deletion is `O(n²)`.

## Interview Explanation

Earlier digits matter most, so I keep an increasing stack and pop a larger top whenever deletions remain, delete any leftover count from the end, and strip leading zeros. Each digit enters and leaves once, so time is `O(n)`.
