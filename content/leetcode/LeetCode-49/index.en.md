---
title: "LeetCode 49: Group Anagrams"
summary: "LeetCode 49 note: use each string's sorted form as a key; strings sharing a key form one anagram group"
description: "LeetCode 49 record from 2022-10-22"
date: 2022-10-22
tags: ["medium", "array", "hash-table", "string", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-22
- Submissions: Runtime Error → Wrong Answer ×2 → Time Limit Exceeded ×3 → Accepted → Runtime Error → Accepted ×3

## Approach

Anagrams are identical after sorting, so use `"".join(sorted(s))` (or `tuple(sorted(s))`) as the key ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 5) in a `defaultdict(list)` and return all values. A 26-length count tuple also works as a key and skips sorting.

## My Attempts

This took 11 submissions:

- Attempt 1 had a typo (`rse`, NameError); attempt 2 only searched existing groups and **never created a new one**, so it always returned an empty list.
- Attempt 3 added new groups but used `set` to match them: `["bb", "b"]` landed in one group.
- Comparing with `Counter` fixed the answers, but each string was compared with every group, **timing out three times**.
- Switching to "sorted string as key" passed. A 2022-10-27 rewrite wrote `values` instead of `values()` and raised one more RE.

## Solution

```python
class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        groups = defaultdict(list)
        for s in strs:
            groups["".join(sorted(s))].append(s)
        return list(groups.values())
```

## Complexity

Time `O(n · k log k)` for string length `k`, space `O(nk)`.

## Mistakes to Avoid

- Sets do not work: `"bb"` and `"b"` share a character set but are not anagrams.
- Comparing each string with every existing group is `O(n²)` and times out; a key finds the group directly.
- `dict.values` is a method and needs parentheses.

## Interview Explanation

I key a hash map by each string's sorted form, so anagrams share a key, and return the groups. Time `O(n · k log k)`; for long strings a 26-letter count tuple can be the key instead.
