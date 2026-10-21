---
title: "LeetCode 3121: Count the Number of Special Characters II"
summary: "LeetCode 3121 note: track each letter's last lowercase index and first uppercase index; it counts only when the former comes first"
description: "LeetCode 3121 record from 2024-04-21"
date: 2024-04-21
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
First Attempt: 2024-04-21
- Submissions: Wrong Answer ×4 → Accepted

## Approach

"Every lowercase occurrence precedes the first uppercase one" means **last lowercase index** < **first uppercase index**. One pass records both ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})); a letter is special when both exist in that order.

## My Attempts

It failed four times during the 2024 contest:

- Attempt 1 checked `w not in upper` to see whether an uppercase letter was recorded, but `w` was uppercase while the keys were lowercase, **so it always looked unrecorded** and later uppercase letters overwrote the first index: `"AaA"` should be 0; it returned 1.
- After switching to sets that tracked state, one version treated **another uppercase after the lowercase** as a violation: `"aAA"` should be 1; it returned 0.
- The next fixed that but, although it recorded **uppercase-before-lowercase**, never used it to disqualify: `"AaA"` returned 1. Adding that check passed.

## Solution

```python
class Solution:
    def numberOfSpecialChars(self, word: str) -> int:
        last_lower = {}
        first_upper = {}
        for i, c in enumerate(word):
            if c.islower():
                last_lower[c] = i
            elif c.lower() not in first_upper:
                first_upper[c.lower()] = i
        return sum(1 for c, i in last_lower.items()
                   if c in first_upper and i < first_upper[c])
```

## Complexity

Time `O(n)`, space `O(26)`.

## Mistakes to Avoid

- Record the **first** uppercase and the **last** lowercase index.
- Use one case for the dict keys, or the "already recorded" check never fires.
- Uppercase before lowercase (like `"Aa"`) also disqualifies a letter.

## Interview Explanation

In one pass I record each letter's last lowercase index and first uppercase index, counting letters where both exist and the lowercase one comes first. Time `O(n)`.
