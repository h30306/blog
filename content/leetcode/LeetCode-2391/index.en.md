---
title: "LeetCode 2391: Minimum Amount of Time to Collect Garbage"
summary: "LeetCode 2391 note: pickup time is the total garbage count; each truck only drives to the last house with its type, using a prefix sum of travel"
description: "LeetCode 2391 record from 2025-07-15"
date: 2025-07-15
tags: ["medium", "prefix-sum", "string", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-15
- Submissions: Accepted ×2

## Approach

Only one truck moves at a time, so the total is the sum of every truck's time, in two parts:

- **Pickup**: 1 minute per unit, which is the total length of all strings.
- **Driving**: each truck only drives to the house where its type **last appears**, with the distance from a prefix sum of `travel` ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) Template 4).

## My Solution

I originally accumulated "unpaid travel" per truck while scanning and added it when the truck's type appeared; the second version moved the pickup time into one final sum. Rewritten as "last occurrence + prefix sum":

```python
class Solution:
    def garbageCollection(self, garbage: List[str], travel: List[int]) -> int:
        prefix = [0]
        for d in travel:
            prefix.append(prefix[-1] + d)
        last = {}
        for i, g in enumerate(garbage):
            for t in set(g):
                last[t] = i
        return sum(map(len, garbage)) + sum(prefix[i] for i in last.values())
```

## Complexity

Time `O(total characters + n)`, space `O(n)`.

## Mistakes to Avoid

- A type that never appears means that truck never leaves.
- A truck stops at the last house with its type, not the last house overall.

## Interview Explanation

Total time is pickup plus driving. Pickup is the number of garbage units; each truck drives only to the last occurrence of its type, looked up in a prefix sum of `travel`. Time `O(total characters)`.
