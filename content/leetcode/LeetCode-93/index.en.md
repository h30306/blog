---
title: "LeetCode 93: Restore IP Addresses"
summary: "LeetCode 93 note: cut into exactly 4 pieces, each 1 to 3 digits long, valued 0 to 255, with no leading zero except 0 itself"
description: "LeetCode 93 record from 2022-11-05"
date: 2022-11-05
tags: ["medium", "string", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-05
- Submissions: Accepted ×2

## Approach

Partition backtracking ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) Variation 5): each level cuts 1 to 3 characters; a piece is valid when `0 <= int(piece) <= 255` and `piece == "0" or piece[0] != "0"`. Record after 4 pieces only if the string is used up. Prune when the remaining length is outside `remaining pieces × 1` to `remaining pieces × 3`.

## My Attempts

Both 2022-11 submissions passed. The first did not cap pieces at 3 characters, relying on `int(piece) < 256` to reject long ones, and had no remaining-length pruning.

## Solution

```python
class Solution:
    def restoreIpAddresses(self, s: str) -> List[str]:
        res, path = [], []
        def dfs(start):
            left = 4 - len(path)
            if left == 0:
                if start == len(s):
                    res.append(".".join(path))
                return
            if not left <= len(s) - start <= 3 * left:
                return
            for end in range(start + 1, min(start + 3, len(s)) + 1):
                piece = s[start:end]
                if (piece == "0" or piece[0] != "0") and int(piece) <= 255:
                    path.append(piece)
                    dfs(end)
                    path.pop()
        dfs(0)
        return res
```

## Complexity

Time `O(3^4)`, space `O(1)` excluding output.

## Mistakes to Avoid

- Leading zeros: `"01"` is invalid while `"0"` is fine.
- Exactly 4 pieces, and the whole string must be used.

## Interview Explanation

I backtrack over cuts of 1 to 3 characters, each at most 255 with no leading zero except 0 itself, recording when four pieces use up the string and pruning when the remaining length cannot fit.
