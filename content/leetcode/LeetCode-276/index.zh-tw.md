---
title: "LeetCode 276: Paint Fence"
summary: "LeetCode 解題筆記：Paint Fence"
description: "2026-05-24 的 LeetCode 學習紀錄"
date: 2026-05-24
tags: ["leetcode", "medium", "dynamic-programming"]

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

這篇整理 Paint Fence 的解題筆記，重點放在 counting DP with exact end-state relationship、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** counting DP with exact end-state relationship.

## Why This Fits
The only thing that matters at the end of post `i` is:
```text
are the last 2 posts the same color or different colors?
```

That is a clean state split because the rule is:
```text
no more than 2 adjacent posts may have the same color
```

## Core State / Invariant
```text
same = number of valid ways where the last 2 posts have the same color
diff = number of valid ways where the last 2 posts have different colors
```

## Base Cases
For `n = 1`:
```text
answer = k
```

For the rolling 2-state view after processing the second post:
```text
same = k
diff = k * (k - 1)
```

Why:
- to make the last 2 the same, choose one color for both posts
- to make them different, choose first color in `k` ways and second in `k - 1` ways

## Transition
If we add one more post:
```text
new_same = diff
new_diff = (same + diff) * (k - 1)
```

Why:
- `new_same`: the new post can only match the previous post if the previous 2 were different, otherwise 3 in a row would appear
- `new_diff`: from either previous state, choose any color different from the last color

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- memorizing `same/diff` formulas without explaining the legality rule
- forgetting that `same` cannot come from previous `same`
- mishandling `n = 1`
- using combinations language instead of exact state meaning

## Strong Spoken Explanation
I split the count into 2 exact end states: valid paintings where the last 2 posts are the same, and valid paintings where the last 2 posts are different. That is enough because the constraint is only about avoiding 3 consecutive equal colors. If I want the new last 2 posts to be the same, the previous state must have ended in `diff`; otherwise I would create 3 equal posts in a row. If I want them different, I can come from either previous state and choose any of the `k - 1` colors that differ from the last post.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
