---
title: "LeetCode 790: Domino and Tromino Tiling"
summary: "LeetCode 解題筆記：Domino and Tromino Tiling"
description: "2026-05-24 的 LeetCode 學習紀錄"
date: 2026-05-24
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-24
來源筆記：`notes/day27-week5-weekend-day1-paint-fence-domino-tromino-btree-deep-dive.md`

## 解題思路

這篇整理 Domino and Tromino Tiling 的解題筆記，重點放在 profile DP / full-state plus gap-state compression、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** profile DP / full-state plus gap-state compression.

## Why This Fits
The hard part of this problem is not counting tiles.

It is recognizing that when tiling a `2 x n` board, the frontier can end in only a small number of meaningful shapes:
- fully filled
- one corner missing

That is exactly profile-DP reasoning.

## Core State / Invariant
```text
full[i] = number of ways to fully tile a 2 x i board
gap[i]  = number of ways to tile a 2 x i board with exactly one corner missing
```

The `gap` state uses symmetry:
- top-missing and bottom-missing have the same count
- so one variable is enough, and the factor `2` appears in `full`

## Base Cases
```text
full[0] = 1
full[1] = 1
gap[0] = 0
gap[1] = 0
```

Why:
- empty board has one valid tiling: do nothing
- `2 x 1` board has one vertical domino tiling
- you cannot create a one-corner-missing board of width `0` or `1` under the recurrence start

## Transition
```text
full[i] = full[i - 1] + full[i - 2] + 2 * gap[i - 1]
gap[i] = gap[i - 1] + full[i - 2]
```

## Why These Transitions Make Sense
For `full[i]`:
- place one vertical domino after a full `2 x (i - 1)` board
- place two horizontal dominoes after a full `2 x (i - 2)` board
- place one tromino to close a previous gap; there are 2 mirrored gap orientations

For `gap[i]`:
- extend an earlier gap with one horizontal domino
- create a new gap by attaching one tromino to a full `2 x (i - 2)` board

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- treating the problem like plain Fibonacci without explaining the gap state
- forgetting why the `2 * gap[i - 1]` term exists
- using a gap state but not defining what shape it means
- shaky base cases around `full[0]`

## Strong Spoken Explanation
I model the board frontier, not individual tile placements. The board can end either fully covered or with exactly one corner missing, so I use `full[i]` and `gap[i]`. A full board of width `i` can come from a full board of width `i - 1` plus one vertical domino, from a full board of width `i - 2` plus two horizontal dominoes, or from closing one of the 2 mirrored gap states at width `i - 1` with a tromino. A gap board of width `i` can either extend a previous gap or be created from a full board of width `i - 2` with one tromino.

## Problem 3 - Timed Stock State Drill: LC 122 And LC 309
- **Pattern:** state-machine recall under pressure.

## Purpose
By Weekend Day 1, the stock thread should no longer depend on memorized formulas.

The drill is checking whether you can immediately say:
```text
state =
base case =
transition =
answer =
```

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
