---
title: "LeetCode 599: Minimum Index Sum of Two Lists"
summary: "LeetCode 599 note: map list1's strings to indices, sum both indices while scanning list2, and keep every string with the minimum sum"
description: "LeetCode 599 record from 2022-08-28"
date: 2022-08-28
tags: ["easy", "array", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-28
- Submissions: Runtime Error ×3 → Wrong Answer ×4 → Accepted → Runtime Error → Accepted ×4

## Approach

Store `list1` as a "string → index" hash map ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})); while scanning `list2`, compute the index sum for each common string. A smaller sum resets the answer and an equal one appends to it.

## My Attempts

This took 13 submissions:

- The first three were syntax errors and the fourth forgot the `return`.
- The next three tracked the index in `i` by hand but **never did `i += 1`**, so every string in `list1` had index 0: for `["c", "e"]`, `["e", "c"]` both sums are 1 and the answer is `["c", "e"]`; they returned `["e"]`. Adding the increment passed.
- A two-dict rewrite that evening had one more misspelled name (NameError).

## Solution

```python
class Solution:
    def findRestaurant(self, list1: List[str], list2: List[str]) -> List[str]:
        pos = {s: i for i, s in enumerate(list1)}
        best, res = float("inf"), []
        for j, s in enumerate(list2):
            if s in pos:
                total = pos[s] + j
                if total < best:
                    best, res = total, [s]
                elif total == best:
                    res.append(s)
        return res
```

## Complexity

Time `O(n + m)`, space `O(n)`.

## Mistakes to Avoid

- When tracking an index by hand, remember to increment it, or just use `enumerate`.
- `list.index` costs `O(m)` per call, making the whole thing `O(nm)`.

## Interview Explanation

I map the first list's strings to indices, then scan the second list, computing index sums for common strings; a smaller sum resets the answer and a tie appends. Time `O(n + m)`.
