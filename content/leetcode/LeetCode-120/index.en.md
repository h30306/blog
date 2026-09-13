---
title: "LeetCode 120: Triangle"
summary: "LeetCode note for Triangle, rebuilt from the original learning note"
description: "Cleaned LeetCode 120 article from 2026-06-27 with note repair points and final solution"
date: 2026-06-27
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
First Attempt: 2026-06-27
Source: Day 30 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- explain `LC 120` as in-place DP with exact state meaning after overwrite
- walk the edge cases for `LC 120` left edge, right edge, and middle cells

## Learning Note Extract

#### Problem 2 - LC 120 Triangle
- **Pattern:** DP on jagged rows / in-place bottom-up accumulation.

#### Why This Fits
Each position in row `r` depends only on legal parents from row `r - 1`.

The row shape is not rectangular, but the dependency is still local and acyclic, so DP fits cleanly.

#### Core State / Invariant
For the in-place version:
```text
triangle[r][c] = minimum path sum to reach position (r, c) after update
```

#### Edge Rules
Left edge:
```text
c == 0
```

Can only come from:
```text
triangle[r - 1][0]
```

Right edge:
```text
c == r
```

Can only come from:
```text
triangle[r - 1][c - 1]
```

Middle cells:
```text
triangle[r][c] += min(triangle[r - 1][c - 1], triangle[r - 1][c])
```

#### Final Answer
After all updates:
```text
answer = min(triangle[last_row])
```

Because any position in the last row can be the endpoint of a valid top-to-bottom path.

#### Complexity
```text
Time: O(total cells)
Space: O(1) extra
```

For `n` rows:
```text
Time: O(n^2)
```

#### Common Mistakes
- thinking in-place update means it is not DP
- forgetting the left and right edges each have only one legal parent
- saying every cell has two parents
- giving vague complexity like `O(n * m)` when the structure is a triangle, not a rectangle

#### Strong Spoken Explanation
I update the triangle in place so that each entry becomes the minimum path sum to reach that position. The left edge has only one parent directly above, the right edge has only one parent above-left, and middle cells can come from either of the two parents in the previous row. After processing all rows, the minimum answer is the minimum value in the last row.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def minimumTotal(self, triangle: List[List[int]]) -> int:
        dp = triangle[-1][:]

        for r in range(len(triangle) - 2, -1, -1):
            for c in range(len(triangle[r])):
                dp[c] = triangle[r][c] + min(dp[c], dp[c + 1])

        return dp[0]
```

## Complexity

Time O(number of cells), Space O(width of last row).

## Mistakes To Watch

- Trying to greedily choose the smaller child at each row.
- Forgetting that row lengths change.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
