---
title: "LeetCode 860: Lemonade Change"
summary: "LeetCode 860 note: track only the counts of $5 and $10 bills; for $15 change prefer 10 + 5, since $5 bills are more versatile"
description: "LeetCode 860 record from 2022-09-17"
date: 2022-09-17
tags: ["easy", "array", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-17
- Submissions: Runtime Error → Wrong Answer ×2 → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×3 → Runtime Error → Wrong Answer → Runtime Error → Accepted ×5

## Approach

Track **the count of each bill**, not the total: holding a $10 does not make change for $5. Keep a $5; a $10 needs one $5 back; a $20 needs $15, greedily as `10 + 5`, falling back to `5 + 5 + 5` ([Greedy]({{< relref "/algorithm/Greedy" >}})). A $5 can serve both $10 and $20 customers while a $10 serves only $20 ones, so save the $5s. $20 bills are never given back, so they need no count.

## My Attempts

This took 17 submissions:

- At first I tracked only **the total amount**: attempt 1 never even added incoming money, so `[5, 10]` returned `False`; attempt 2 added it, but in `[5, 10, 10]` the only bill on hand is a $10, which cannot give the third customer $5, yet it returned `True`. Enough money does not mean the right bills.
- With a dict of bills, one version put `return False` in an `else` that **the $5 case, needing no change, also reached**: `[5]` returned `False`.
- Several versions keyed by the change owed, `b - 5`, instead of the bill received, so receiving a $10 recorded `balance[5]`, effectively giving change from itself: `[10]` returned `True`. Keying by the bill then hit KeyErrors for missing keys.
- Two plain integers, `c5` and `c10`, finally passed.

## Solution

```python
class Solution:
    def lemonadeChange(self, bills: List[int]) -> bool:
        five = ten = 0
        for b in bills:
            if b == 5:
                five += 1
            elif b == 10:
                if five == 0:
                    return False
                five, ten = five - 1, ten + 1
            elif ten and five:
                ten, five = ten - 1, five - 1
            elif five >= 3:
                five -= 3
            else:
                return False
        return True
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Count bills, not the total amount.
- Key by the bill received, not by the change owed.
- Give $15 as 10 + 5 first.

## Interview Explanation

I count $5 and $10 bills: a $10 takes one $5, a $20 takes 10 + 5 when possible since $5s are more versatile, else three $5s, and I fail when change is impossible. Time `O(n)`.
