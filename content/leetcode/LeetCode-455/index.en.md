---
title: "LeetCode 455: Assign Cookies"
summary: "LeetCode 455 note: sort children and cookies, satisfying the least greedy child with the smallest cookie that suffices; each pointer walks once"
description: "LeetCode 455 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "array", "two-pointers", "greedy", "sorting"]
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
- Submissions: Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Accepted

## Approach

Greedy: the least greedy child is easiest to satisfy, so give them the smallest cookie that works and save bigger ones ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 2). After sorting both, look at cookies one by one: if it satisfies the current child, give it (advance the child pointer); otherwise try the next, larger cookie.

## My Attempts

This took 10 submissions in 2022:

- Attempt 1 zipped the two sorted arrays and compared them one-to-one, so a cookie too small left that child with nothing: appetites `[5]` and cookies `[5, 4]` paired 4 with 5, returning 0 instead of 1.
- Loop versions then kept reading `g[0]` after every child was fed, or counted 1 with an empty cookie list, going out of range or overcounting.

## Solution

```python
class Solution:
    def findContentChildren(self, g: List[int], s: List[int]) -> int:
        g.sort()
        s.sort()
        i = 0
        for size in s:
            if i < len(g) and size >= g[i]:
                i += 1
        return i
```

## Complexity

Time `O(m log m + n log n)`, space `O(1)` besides sorting.

## Mistakes to Avoid

- Do not `zip` the sorted arrays one-to-one: skip a cookie that is too small rather than giving up on that child.
- Stop once every child is satisfied instead of reading `g[i]` further.

## Interview Explanation

I sort appetites and cookies and scan cookies from smallest: if it satisfies the least greedy remaining child, that child is done, otherwise the next larger cookie is tried. Each pointer moves once; sorting dominates at `O(n log n)`.
