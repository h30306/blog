---
title: "LeetCode 948: Bag of Tokens"
summary: "LeetCode 948 note: after sorting, buy score with the cheapest token and buy power with the most expensive one; trade for power only when score > 0, and stop when neither move works"
description: "LeetCode 948 record from 2026-01-24"
date: 2026-01-24
tags: ["medium", "two-pointers", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-24
- Submissions: Wrong Answer → Time Limit Exceeded → Accepted

## Approach

Each token is used once: face-up spends power for 1 score, face-down spends 1 score for power. Greedy:

- To gain score, use the **cheapest** token (left end).
- To gain power, use the **most expensive** token (right end).

After sorting, use converging pointers:

1. Enough power for the left token: buy it, score +1, update the best score.
2. Not enough but score `> 0`: sell the right token for power.
3. Neither: stop.

The answer is the **best score seen**, because the last move may be a sale that lowers the score.

## My Attempts

1. **Attempt 1, WA**: played face-down without checking the score, so the score could go negative. For `tokens = [1, 3, 9]`, `power = 0`, nothing is affordable and the answer is 0; this version went negative to get 9 power, bought 1 and 3, and returned 1.
2. **Attempt 2, TLE**: added the `score > 0` check but no `break` when neither move applies, so the pointers stopped moving and the loop never ended, e.g. `tokens = [4, 7, 9]`, `power = 1`.

## Solution

```python
class Solution:
    def bagOfTokensScore(self, tokens: List[int], power: int) -> int:
        tokens.sort()
        left, right = 0, len(tokens) - 1
        score = best = 0
        while left <= right:
            if power >= tokens[left]:
                power -= tokens[left]
                left += 1
                score += 1
                best = max(best, score)
            elif score > 0:
                power += tokens[right]
                right -= 1
                score -= 1
            else:
                break
        return best
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Playing face-down with a score of 0.
- Forgetting `break` when neither move is possible.
- Returning the final score instead of the best one.

## Interview Explanation

I sort the tokens, gain score with the cheapest and gain power with the most expensive. With enough power I buy the left token; otherwise, if I have score, I sell the right one; if neither works I stop. The last move may be a sale that lowers the score, so I track the best score along the way. Time `O(n log n)`.
