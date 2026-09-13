---
title: "LeetCode 983: Minimum Cost For Tickets"
summary: "LeetCode 解題筆記：Minimum Cost For Tickets"
description: "2026-05-07 的 LeetCode 學習紀錄"
date: 2026-05-07
tags: ["leetcode", "medium", "dynamic-programming"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-07
來源筆記：`notes/day20-week4-weekend-day1-retry-safe-create-api.md`

## 解題思路

這篇整理 Minimum Cost For Tickets 的解題筆記，重點放在 1D DP on travel-day index、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 1D DP on travel-day index.

## Why DP Fits
The decision only matters on travel days.

At each travel day `days[i]`, there are only 3 choices:
- buy 1-day pass
- buy 7-day pass
- buy 30-day pass

Each choice jumps to:
```text
the first future travel day not covered by that pass
```

## State
```text
dp[i] = minimum cost to cover all travel days starting from days[i]
```

## Base Case
```text
dp[n] = 0
```

Reason:
```text
if there are no travel days left, no more cost is needed
```

## Transition
If we buy:
- 1-day pass: jump to first index `j1` where `days[j1] >= days[i] + 1`
- 7-day pass: jump to first index `j7` where `days[j7] >= days[i] + 7`
- 30-day pass: jump to first index `j30` where `days[j30] >= days[i] + 30`

Then:
```text
dp[i] = min(
    costs[0] + dp[j1],
    costs[1] + dp[j7],
    costs[2] + dp[j30]
)
```

## Why `n + 1` DP Size Matters
Need:
```text
dp[n] = 0
```

because after one pass covers all remaining travel days, the next uncovered index becomes:
```text
n
```

## Why DP Fills Right To Left
`dp[i]` depends on:
- `dp[j1]`
- `dp[j7]`
- `dp[j30]`

Those are future indices, so later states must already be known.

## Complexity
For the straightforward scan-forward version:
```text
Time: O(n^2)
Space: O(n)
```

## Common Mistakes
- forgetting `dp[n] = 0`
- allocating only `n` states instead of `n + 1`
- trying to force prefix-sum thinking into a coverage-range problem
- forgetting that pass duration can be partially "wasted" and still be optimal

## Interview-Ready Explanation
This is 1D DP on the travel-day index. I define `dp[i]` as the minimum cost to cover all travel days starting from `days[i]`. The base case is `dp[n] = 0`, because no travel days left means no more cost. At each state, I choose whether to buy a 1-day, 7-day, or 30-day pass. Each pass covers a range of future travel days, so I jump to the first travel-day index not covered by that pass and add that future DP cost. Then I take the minimum of the three choices. In the straightforward implementation, the time complexity is `O(n^2)` and the space complexity is `O(n)`.

## Problem 3 - Timed DP Repair Set
- **Scope:** `LC 91 Decode Ways`, `LC 139 Word Break`, `LC 279 Perfect Squares`

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough.
