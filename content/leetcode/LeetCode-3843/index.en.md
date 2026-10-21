---
title: "LeetCode 3843: First Element with Unique Frequency"
summary: "LeetCode 3843 note: count each value, then count how many values share each count; the first element from the left whose count is its own is the answer"
description: "LeetCode 3843 record from 2026-02-16"
date: 2026-02-16
tags: ["medium", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-16
- Submissions: Accepted (first try)

## Approach

Two levels of counting ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1):

- `cnt`: value -> count.
- `freq_of_freq`: count -> how many distinct values have that count.

"Unique count" means `freq_of_freq[cnt[x]] == 1`. For the first one, scan the original array from the left.

## My Solution

```python
class Solution:
    def firstUniqueFreq(self, nums: List[int]) -> int:
        cnt = Counter(nums)
        freq_of_freq = Counter(cnt.values())
        for x in nums:
            if freq_of_freq[cnt[x]] == 1:
                return x
        return -1
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- "First" follows the original array's order, not `cnt`'s.

## Interview Explanation

I count each value, then count how many values share each count. Scanning the original array from the left, the first element whose count belongs to only one value is the answer. Time `O(n)`.
