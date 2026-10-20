---
title: "LeetCode 1402: Reducing Dishes"
summary: "LeetCode 1402 note: sort and take dishes from most satisfying down; each new dish goes first and shifts the chosen ones one slot later, adding the current chosen sum, so keep going while that sum is positive"
description: "LeetCode 1402 record from 2026-07-08"
date: 2026-07-08
tags: ["hard", "dynamic-programming", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-08
- Submissions: Accepted (first try)

## Approach

Once the dishes are chosen, **cooking the most satisfying ones last** maximizes the total (rearrangement inequality). So after sorting, the chosen dishes are always **the largest few**.

Start from the most satisfying and add dishes one at a time. Each new dish goes first and shifts every chosen dish one slot later, multiplying each once more:

```text
new total = old total + (sum of all chosen satisfactions, including the new dish)
```

As long as the chosen sum is positive, adding increases the total; stop once it is `<= 0`.

## My Solution

```python
class Solution:
    def maxSatisfaction(self, satisfaction: List[int]) -> int:
        satisfaction.sort(reverse=True)
        total = suffix = 0                         # suffix: sum of the chosen satisfactions
        for s in satisfaction:
            suffix += s
            if suffix <= 0:
                break
            total += suffix                        # every chosen dish moves one slot later
        return total
```

My accepted version ran it in reverse: take everything, compute the total, then remove dishes from the smallest up, each removal lowering the total by the remaining sum, keeping the best seen. It is the same idea.

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Picking only positive dishes: a negative dish placed first makes every later dish count once more, which can be better. The answer 14 for `[-1, -8, 0, 5, -9]` uses the `-1`.

## Interview Explanation

Chosen dishes should be cooked with the most satisfying last, so the chosen set is the largest few. I add from the largest down, putting each new dish first, which shifts the others and adds the current chosen sum to the total; I keep going while that sum is positive. Time `O(n log n)`.
