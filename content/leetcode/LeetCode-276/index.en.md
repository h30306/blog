---
title: "LeetCode 276: Paint Fence"
summary: "LeetCode note for Paint Fence, rebuilt from the original learning note"
description: "Cleaned LeetCode 276 article from 2026-05-24 with note repair points and final solution"
date: 2026-05-24
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-24
Source: Day 27 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 1 - LC 276 Paint Fence
- **Pattern:** counting DP with exact end-state relationship.

#### Why This Fits
The only thing that matters at the end of post `i` is:
```text
are the last 2 posts the same color or different colors?
```

That is a clean state split because the rule is:
```text
no more than 2 adjacent posts may have the same color
```

#### Core State / Invariant
```text
same = number of valid ways where the last 2 posts have the same color
diff = number of valid ways where the last 2 posts have different colors
```

#### Base Cases
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

#### Transition
If we add one more post:
```text
new_same = diff
new_diff = (same + diff) * (k - 1)
```

Why:
- `new_same`: the new post can only match the previous post if the previous 2 were different, otherwise 3 in a row would appear
- `new_diff`: from either previous state, choose any color different from the last color

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- memorizing `same/diff` formulas without explaining the legality rule
- forgetting that `same` cannot come from previous `same`
- mishandling `n = 1`
- using combinations language instead of exact state meaning

#### Strong Spoken Explanation
I split the count into 2 exact end states: valid paintings where the last 2 posts are the same, and valid paintings where the last 2 posts are different. That is enough because the constraint is only about avoiding 3 consecutive equal colors. If I want the new last 2 posts to be the same, the previous state must have ended in `diff`; otherwise I would create 3 equal posts in a row. If I want them different, I can come from either previous state and choose any of the `k - 1` colors that differ from the last post.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def numWays(self, n: int, k: int) -> int:
        if n == 1:
            return k
        same = k
        diff = k * (k - 1)
        for _ in range(3, n + 1):
            same, diff = diff, (same + diff) * (k - 1)
        return same + diff
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Allowing three adjacent posts with the same color.
- Forgetting n=1.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
