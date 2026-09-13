---
title: "LeetCode 55: Jump Game"
summary: "LeetCode 解題筆記：Jump Game"
description: "2026-05-01 的 LeetCode 學習紀錄"
date: 2026-05-01
tags: ["medium", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-01
來源筆記：`notes/day16-week4-day2-jump-game-idempotency-grpc.md`

## 解題思路

這篇整理 Jump Game 的解題筆記，重點放在 Greedy reachable frontier、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Greedy reachable frontier.

## Why Greedy Fits
At each index, the only future-relevant information is:
```text
how far to the right we can reach so far
```

We do not need to try every jump path. If an index is reachable, then the exact path that reached it no longer matters; only the farthest frontier matters.

## Core Invariant
```text
farthest = farthest index reachable after scanning positions up to i
```

## Failure Condition
```text
if i > farthest:
    current index is unreachable -> return False
```

## Update Rule
```text
farthest = max(farthest, i + nums[i])
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- calling the best solution DP just because it scans left to right
- thinking greedy means "always physically take the biggest jump now"
- storing per-index state when only one frontier variable is needed

## Interview-Ready Explanation
I scan left to right and keep the farthest index reachable so far. If I ever reach an index beyond that frontier, the answer is false. Otherwise I extend the frontier with `i + nums[i]`. If the frontier reaches the last index, the array is solvable.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough after greedy correction.
