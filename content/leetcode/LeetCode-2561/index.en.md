---
title: "LeetCode 2561: Rearranging Fruits"
summary: "LeetCode 2561 note: every value's total must be even; sort the excess, and each cheap half item swaps with an expensive one at min(its value, 2 × global minimum)"
description: "LeetCode 2561 record from 2026-09-15"
date: 2026-09-15
tags: ["hard", "greedy", "hash-table", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-15
- Submissions: Wrong Answer → Accepted ×2

## Approach

1. **Feasibility**: the baskets must end up equal, so every value's total count must be even, half in each. Any odd count means -1.
2. **What to swap**: each value is over or under in basket 1 by `|count1 - total / 2|`. List the excess from both sides (`need`); its length is `2 × swaps`, and each swap exchanges one excess item from each side.
3. **Cheapest pairing**: a swap costs the smaller of the two values. Sort `need` and pair each item in the cheap half with an expensive one, paying the cheap value.
4. **Use the minimum as a go-between**: the globally cheapest fruit `m` can be swapped back and forth twice to exchange a pair for `2m`. So each swap costs `min(need[i], 2m)`.

This is the pairing idea from [Greedy]({{< relref "/algorithm/Greedy" >}}) Template 4.

## My Attempts

Attempt 1 tried pairing from both ends with two deques, but the `while` that cancels the common part used `v` from `for k, v in ...items()`. **`v` never changes inside the loop**, so the counts kept dropping until the other side reached zero and went negative. For `basket1 = [3, 3, 1]`, `basket2 = [1, 1, 1]` the answer is 1 (swap a 3 for a 1); this version drove the count of 1 to -2 and returned 0. It also ignored the go-between trick.

Switching to the approach above passed.

## Solution

```python
class Solution:
    def minCost(self, basket1: List[int], basket2: List[int]) -> int:
        c1, total = Counter(basket1), Counter(basket1) + Counter(basket2)
        need = []
        for v, c in total.items():
            if c % 2:
                return -1
            need += [v] * abs(c // 2 - c1[v])
        need.sort()
        m = min(total)
        return sum(min(x, 2 * m) for x in need[:len(need) // 2])
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Do not put a value read before the loop, and never updated, in the loop condition.
- Remember the global minimum as a go-between; it can be cheaper than a direct swap.

## Interview Explanation

It is only possible if every value's total is even. I list each basket's excess fruits and sort them; each item in the cheap half swaps with an expensive one for its own value, or through the global minimum for twice that minimum, whichever is less. Time `O(n log n)`.
