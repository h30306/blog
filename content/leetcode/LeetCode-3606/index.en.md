---
title: "LeetCode 3606: Coupon Code Validator"
summary: "LeetCode 3606 note: filter valid coupons, then sort by (category order, code); character ranges must include z, Z and 9"
description: "LeetCode 3606 record from 2025-07-06"
date: 2025-07-06
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
First Attempt: 2025-07-06
- Submissions: Wrong Answer ×4 → Accepted

## Approach

Two steps:

1. **Filter**: `code` non-empty with only letters, digits and underscores; the category is one of the four; `isActive` is `True`.
2. **Sort**: by the given category order, then by `code` lexicographically. Use `(category order, code)` as the sort key ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 5), with the category order from a dictionary.

## My Attempts

| Version | Problem |
|---|---|
| Attempts 1 and 2 | Checked characters with `range(ord("a"), ord("z"))`, **which excludes `z`, `Z` and `9`**. For `code = ["9"]` (valid) it returned nothing. Attempt 1 also did not sort |
| Attempt 3 | Fixed the ranges but sorted only by `code`, forgetting the category first |
| Attempt 4 | Sorted by `(code, category)`, the wrong order. For `code = ["_a", "a"]` with categories `["pharmacy", "grocery"]` the answer is `["a", "_a"]`; both returned `["_a", "a"]` |
| AC | Changed to `(category, code)` |

The four categories happen to be in alphabetical order, so sorting by the category string also works; a dictionary states the order without relying on that coincidence.

## Solution

```python
class Solution:
    def validateCoupons(self, code: List[str], businessLine: List[str], isActive: List[bool]) -> List[str]:
        order = {"electronics": 0, "grocery": 1, "pharmacy": 2, "restaurant": 3}
        valid = [
            (order[b], c)
            for c, b, active in zip(code, businessLine, isActive)
            if active and b in order and c and all(ch.isalnum() or ch == "_" for ch in c)
        ]
        return [c for _, c in sorted(valid)]
```

`str.isalnum()` also returns `True` for non-ASCII letters; the input here is ASCII only, so that is fine.

## Complexity

Time `O(L + n log n)` with `L` the total code length, space `O(n)`.

## Mistakes to Avoid

- `range(a, b)` excludes `b`.
- With a multi-part sort key, the order of the parts is the priority.

## Interview Explanation

I filter valid coupons: non-empty code of letters, digits and underscores, a listed category, and active. Then I sort by (category order, code), with the order from a dictionary. Time `O(n log n)`.
