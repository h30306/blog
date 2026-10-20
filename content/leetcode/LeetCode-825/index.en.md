---
title: "LeetCode 825: Friends Of Appropriate Ages"
summary: "LeetCode 825 note: after sorting, the people someone can invite have ages in (0.5 × age + 7, age], a contiguous range kept with two same-direction pointers, minus the person themself"
description: "LeetCode 825 record from 2026-01-21"
date: 2026-01-21
tags: ["medium", "two-pointers", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-21
- Submissions: Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Accepted

## Approach

`x` sends a request to `y` when:

- `age[y] > 0.5 * age[x] + 7`
- `age[y] <= age[x]`
- The third rule (`age[y] > 100 and age[x] < 100`) can never apply once `age[y] <= age[x]`, so ignore it.

So a person aged `a` can invite everyone aged in **`(0.5a + 7, a]`**, except themself.

After sorting, that is a contiguous range `[left, right)`. Processing people from youngest to oldest, both ends only move right, so two same-direction pointers maintain it:

- `left`: skip everyone `<= 0.5a + 7`.
- `right`: take in everyone `<= a` (people of the same age included).

When the range is non-empty the person is inside it (someone qualifies only if `a > 0.5a + 7`), so add `right - left - 1`.

## My Attempts

| Version | Problem |
|---|---|
| Attempts 1–2, WA | Moved `right` forward and counted only the people left of `right`, so same-age pairs were counted in one direction, then patched with "+1 per repeated age"; the count was wrong. For `[16, 16, 16]` all three invite each other, so the answer is 6; both returned 4 |
| Attempt 3, RE | Switched to two pointers but computed the threshold from `ages[right]`, which goes out of range once `right` reaches `n`. `[20, 20]` raises IndexError |
| Attempts 4–5, WA | Used `ages[i]` for the threshold, but the `left` loop ran while `left < right`, so too-young people were not all skipped. For `[5, 5]`, the threshold for age 5 is 9.5 and nobody can be invited, so the answer is 0; this returned 1 |

Changing the `left` condition to `left < n` passed.

## Solution

```python
class Solution:
    def numFriendRequests(self, ages: List[int]) -> int:
        ages.sort()
        n = len(ages)
        ans = left = right = 0
        for age in ages:
            while left < n and ages[left] <= 0.5 * age + 7:
                left += 1                          # too young
            while right < n and ages[right] <= age:
                right += 1                         # not older than this person
            if right > left:
                ans += right - left - 1            # exclude this person
        return ans
```

Alternatively, ages are only 1 to 120, so a count array and an `O(120^2)` loop over age pairs also works.

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- People of the same age invite each other: count both directions.
- Bounding a pointer with `left < right`: too-young people may not all be skipped.
- Subtract the person themself only when the range is non-empty.

## Interview Explanation

After simplifying, a person aged `a` invites those aged in `(0.5a + 7, a]`; the third rule is implied by the second. I sort the ages and process people in order. Both ends of that range only move right, so two same-direction pointers maintain it, and the range size minus the person themself is their number of requests. Time `O(n log n)`.
