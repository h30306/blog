---
title: "LeetCode 1833: Maximum Ice Cream Bars"
summary: "LeetCode 1833 note: buy the cheapest first; the problem asks for counting sort, and with values up to 10^5 each price buys min(count, coins // price)"
description: "LeetCode 1833 record from 2026-06-21"
date: 2026-06-21
tags: ["medium", "greedy", "sorting", "counting-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-21
- Submissions: Accepted ×2 (sorting, then counting sort)

## Approach

To buy the most, buy the cheapest first (exchange argument: in any purchase, swapping an expensive bar for an unbought cheaper one keeps the count and does not raise the cost).

The problem asks for counting sort: prices are at most `10^5`, so count each price and walk upward, buying `min(cnt, coins // price)` at each price. Once the coins cannot cover the current price, nothing pricier is affordable either, so stop. This is [Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1.

## My Solution

The first version sorted and bought one at a time; the second switched to counting sort as required:

```python
class Solution:
    def maxIceCream(self, costs: List[int], coins: int) -> int:
        cnt = [0] * (max(costs) + 1)
        for c in costs:
            cnt[c] += 1
        bought = 0
        for price in range(1, len(cnt)):
            if price > coins:
                break
            take = min(cnt[price], coins // price)
            coins -= take * price
            bought += take
        return bought
```

## Complexity

Time `O(n + M)` with `M` the highest price, space `O(M)`.

## Mistakes to Avoid

- You may not afford every bar at one price; take `min(cnt, coins // price)`.

## Interview Explanation

Buying cheapest first always maximizes the count. Since counting sort is required, I count each price and, from low to high, buy as many as I can at each price, stopping when the coins cannot cover the current price. Time `O(n + M)`.
