---
title: "LeetCode 4019: Merge Close Characters II"
summary: "LeetCode 4019 note: kept characters never change again, so record each character's last position in the result; a new character within k of it gets merged away"
description: "LeetCode 4019 record from 2026-09-13"
date: 2026-09-13
tags: ["medium", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-09-13
- Submissions: Wrong Answer → Accepted

## Approach

Each step picks the close pair with the smallest `i`, so merging **settles from the left**: the processed, kept prefix has no close pair and never changes again.

So build the result left to right ([String]({{< relref "/algorithm/String" >}}) Template 1):

- Record each character's last position **in the result**, `last[ch]`.
- A new character would land at `len(res)`; if `len(res) - last[ch] <= k`, it is close to the earlier one and gets merged away.
- Otherwise append it and update `last[ch]`.

Distances use positions in the result, because the problem renumbers indices after each deletion.

## My Attempts

Attempt 1 tried converting original indices to current positions by subtracting "recent deletions", keeping deleted positions in a deque window, but **only subtracted deletions inside the window**, so distances were wrong. For `"ccccca"`, `k = 1` all the `c`s merge into one, answer `"ca"`; it returned `"cca"`. Recording positions in the result directly passed.

## Solution

```python
class Solution:
    def mergeCharacters(self, s: str, k: int) -> str:
        last, res = {}, []
        for ch in s:
            if ch in last and len(res) - last[ch] <= k:
                continue                           # close to an earlier copy, merged
            last[ch] = len(res)
            res.append(ch)
        return "".join(res)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Indices are renumbered after deletions; measure distance in result positions.

## Interview Explanation

Since the pair with the smallest `i` always merges first, the kept prefix never changes. I build the result left to right, recording each character's last position in it; a new character within `k` of that position is merged away, otherwise it is appended. Time `O(n)`.
