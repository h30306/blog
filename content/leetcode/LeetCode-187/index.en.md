---
title: "LeetCode 187: Repeated DNA Sequences"
summary: "LeetCode 187 note: count every length-10 substring in a hash map and return those seen more than once"
description: "LeetCode 187 record from 2022-11-14"
date: 2022-11-14
tags: ["medium", "hash-table", "string", "bit-manipulation", "sliding-window"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-14
- Submissions: Accepted (first try)

## Approach

Enumerate every length-10 substring ([String]({{< relref "/algorithm/String" >}}) Template 3, the fixed window of [Sliding Window]({{< relref "/algorithm/Sliding-Window" >}}) Template 1), count them in a hash map ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1), and return those with count above 1.

## My Attempts

Passed on the first try. The loop ran to `len(s)`, adding tail fragments shorter than 10, but each appears once, so the answer was unaffected.

## Solution

```python
class Solution:
    def findRepeatedDnaSequences(self, s: str) -> List[str]:
        cnt = Counter(s[i:i + 10] for i in range(len(s) - 9))
        return [seq for seq, c in cnt.items() if c > 1]
```

## Complexity

Time `O(10n)`, space `O(10n)`.

## Mistakes to Avoid

- Start indices go up to `len(s) - 10`; otherwise tail fragments shorter than 10 get counted.
- Do not use `s.count(seq)`: it counts **non-overlapping** occurrences and misses `"AAAAAAAAAAA"`.

## Interview Explanation

I count every length-10 substring in a hash map and return those seen more than once. Each substring has fixed length 10, so time and space are `O(n)`; to optimize further, encode A, C, G, T in 2 bits each and use a rolling hash for `O(1)` per shift.
