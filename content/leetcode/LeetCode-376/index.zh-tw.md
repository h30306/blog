---
title: "LeetCode 376: Wiggle Subsequence"
summary: "LeetCode 解題筆記：Wiggle Subsequence"
description: "2026-05-23 的 LeetCode 學習紀錄"
date: 2026-05-23
tags: ["medium", "dynamic-programming", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-23
來源筆記：`notes/day25-week5-day4-wiggle-min-swaps-index-design.md`

## 解題思路

這篇整理 Wiggle Subsequence 的解題筆記，重點放在 state-machine DP / greedy over alternating direction、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** state-machine DP / greedy over alternating direction.

## Why This Fits
At each position, the only thing that matters is:
```text
what is the best wiggle subsequence length if my last step was up or down?
```

That is a clean exact-end-state question, so state-machine reasoning fits naturally.

## Core State / Invariant
```text
up   = best wiggle length ending at current index with last difference positive
down = best wiggle length ending at current index with last difference negative
```

If:
- `nums[i] > nums[i - 1]`, a positive jump can extend a sequence whose last jump was negative:
  - `up = down + 1`
- `nums[i] < nums[i - 1]`, a negative jump can extend a sequence whose last jump was positive:
  - `down = up + 1`
- equal values do not help either direction

## Why Greedy Compression Works
For wiggle behavior, only turning points matter.

If you already have an upward move, keeping a more extreme endpoint is always at least as good as keeping a weaker one, because it preserves or improves the chance of a future alternating move.

That is why the full DP collapses cleanly into rolling `up/down`.

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- treating equal adjacent values as a valid wiggle step
- forgetting that `up` and `down` are lengths, not differences
- trying to keep the full subsequence instead of the best length under each ending direction
- giving a greedy answer without being able to justify why local compression is safe

## Strong Spoken Explanation
I track two exact states: the best wiggle length ending here if the last movement is up, and the best if the last movement is down. When I see a larger value than the previous one, I can extend a sequence whose last movement was down; when I see a smaller value, I can extend one whose last movement was up. Equal values do not change either state. The reason the solution compresses to two variables is that for future wiggles only the best length under each ending direction matters.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
