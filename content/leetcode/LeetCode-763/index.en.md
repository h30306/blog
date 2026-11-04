---
title: "LeetCode 763: Partition Labels"
summary: "LeetCode 763 note: record each letter's last index, extend the current part's end while scanning, and cut when the scan reaches it"
description: "LeetCode 763 record from 2026-11-03"
date: 2026-11-03
tags: ["medium", "hash-table", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-11-03
- Submissions: Accepted (first try)

## Approach

A letter can appear in only one part, so a part must extend at least to the **last occurrence** of every letter inside it ([Greedy]({{< relref "/algorithm/Greedy" >}})):
1. One pass records `last`, each letter's last index.
2. A second pass keeps the current part's end, `end = max(end, last[c])`.
3. When `i == end`, no letter in the part appears again, so cut here.

Cutting each part as early as possible gives the most parts.

## My Attempts

Accepted on the first try. My version cut when the next `i` passed `end` and appended the last part after the loop. The version below cuts right at `i == end`, so there is no last part to add separately.

## Solution

```python
class Solution:
    def partitionLabels(self, s: str) -> List[int]:
        last = {c: i for i, c in enumerate(s)}
        res = []
        start = end = 0
        for i, c in enumerate(s):
            end = max(end, last[c])
            if i == end:              # no letter in this part appears later
                res.append(end - start + 1)
                start = i + 1
        return res
```

## Complexity

Time `O(n)`, space `O(1)` (at most 26 letters).

## Mistakes to Avoid

- Using first occurrences: whether you can cut depends on where letters appear **last**.
- Deciding the cut from the current letter's `last[c]` alone: use the part's running `end`, or earlier letters' ends are ignored.

## Interview Explanation

A letter can only be in one part, so I first record each letter's last index. Then I scan the string and extend the current part's end to the furthest last index of any letter in it; when I reach that end, nothing in the part appears again, so I cut there. Cutting as early as possible gives the most parts. Time `O(n)`, space `O(1)`.
