---
title: "LeetCode 276: Paint Fence"
summary: "LeetCode Problem Solving - counting DP with exact end-state relationship"
description: "LeetCode study note from 2026-05-24"
date: 2026-05-24
tags: ["leetcode", "medium", "dynamic-programming"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-24
Source Note: `notes/day27-week5-weekend-day1-paint-fence-domino-tromino-btree-deep-dive.md`

## Intuition

I split the count into 2 exact end states: valid paintings where the last 2 posts are the same, and valid paintings where the last 2 posts are different. That is enough because the constraint is only about avoiding 3 con

Pattern: counting DP with exact end-state relationship

## Approach

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

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
