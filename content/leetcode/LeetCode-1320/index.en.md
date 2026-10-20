---
title: "LeetCode 1320: Minimum Distance to Type a Word Using Two Fingers"
summary: "LeetCode 1320 note: after typing word[i], one finger is always on word[i], so the state is only the other finger's position; dp[other] is the least distance with the other finger at other"
description: "LeetCode 1320 record from 2026-08-25"
date: 2026-08-25
tags: ["hard", "dynamic-programming", "state-machine", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-25
- Submissions: Accepted ×2 (3D DP → 1D DP)

## Approach

The keyboard is a 6-column grid, letter `c` sits at `(c // 6, c % 6)`, and distance is Manhattan distance. Fingers may start anywhere, so the first move is free; a special position `26` means "not used yet", with distance 0 from it.

The direct state is `dp[i][f1][f2]` (after letter `i`, both finger positions), `27 × 27 × n`.

**Observation**: after typing `word[i]`, one finger is on `word[i]`. So only **the other finger** needs tracking: `dp[other]`. Typing `word[i]` with previous letter `prev = word[i - 1]`:

- **Use the finger that just typed `prev`**: the other finger stays, `dp'[other] = dp[other] + dist(prev, cur)`.
- **Use the other finger**: it moves from `other` to `cur`, and the finger on `prev` becomes "the other", `dp'[prev] = dp[other] + dist(other, cur)`.

## My Solution

```python
class Solution:
    def minimumDistance(self, word: str) -> int:
        def dist(a: int, b: int) -> int:
            if a == 26:
                return 0                           # an unused finger's first move is free
            return abs(a // 6 - b // 6) + abs(a % 6 - b % 6)

        INF = float("inf")
        dp = [INF] * 27                            # dp[other]: the other finger is at other
        dp[26] = 0
        for i in range(1, len(word)):
            prev, cur = ord(word[i - 1]) - 65, ord(word[i]) - 65
            ndp = [INF] * 27
            for other in range(27):
                if dp[other] == INF:
                    continue
                ndp[other] = min(ndp[other], dp[other] + dist(prev, cur))   # same finger
                ndp[prev] = min(ndp[prev], dp[other] + dist(other, cur))    # switch fingers
            dp = ndp
        return min(dp)
```

My first accepted version was the 3D `dp[i][f1][f2]` at 277ms; noticing that one finger always sits on the previous letter compressed it to 1D at 50ms.

## Complexity

Time `O(27 · n)`, space `O(27)`.

## Mistakes to Avoid

- A finger's starting position costs nothing: handle it with a "not used yet" state.
- After switching, the finger that typed `prev` becomes "the other", so the state is `prev`.

## Interview Explanation

After typing a letter one finger is on it, so the state only tracks the other finger, with 26 meaning unused. For the next letter, either the same finger moves there and the other stays, or the other finger moves there and the first one becomes "the other". Taking the minimum of both transitions gives `O(27n)`.
