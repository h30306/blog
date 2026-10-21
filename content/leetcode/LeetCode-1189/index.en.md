---
title: "LeetCode 1189: Maximum Number of Balloons"
summary: "LeetCode 1189 note: each letter supports count // needed balloons, with l and o needed twice; take the minimum"
description: "LeetCode 1189 record from 2022-10-18"
date: 2022-10-18
tags: ["easy", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-10-18
- Submissions: Runtime Error → Wrong Answer ×4 → Accepted → Runtime Error ×3 → Wrong Answer → Accepted ×2

## Approach

`balloon` needs one each of `b, a, n` and two each of `l, o`. Count `text` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1); each letter supports `cnt[c] // need[c]` balloons, and the answer is the minimum over the five.

## My Attempts

This took 12 submissions:

- Attempt 1 assigned the letter `s` itself to `res` instead of its count `C[s]` (TypeError).
- The next four filtered with `C[s] < res` first, **comparing the raw count rather than the halved one**, so a single `l` failed `1 < 1` and was skipped: `"nolab"` should be 0; they returned 1.
- Moving to a walrus first caused syntax errors, then `(new := C[s] // 2 < res)` **bound `new` to the comparison `True`**: `"ban"` returned `True`. Moving the parenthesis to `(new := C[s] // 2) < res` passed.

## Solution

```python
class Solution:
    def maxNumberOfBalloons(self, text: str) -> int:
        cnt = Counter(text)
        need = Counter("balloon")
        return min(cnt[c] // need[c] for c in need)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Divide by the needed amount first, then take the minimum; do not filter with raw counts.
- Parenthesize the walrus: `(new := x // 2) < res`, otherwise `new` gets the comparison result.

## Interview Explanation

I count text, divide each letter's count by how many balloon needs (two for l and o), and take the minimum of the five. Time `O(n)`.
