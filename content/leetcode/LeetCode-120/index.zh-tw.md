---
title: "LeetCode 120: Triangle"
summary: "LeetCode 120 解題筆記，依照原始 learning note 重新整理"
description: "2026-06-27 的 LeetCode 120 學習紀錄，包含筆記修正點與正確解法"
date: 2026-06-27
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
第一次嘗試：2026-06-27
來源：Day 30 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- explain `LC 120` as in-place DP with exact state meaning after overwrite
- walk the edge cases for `LC 120` left edge, right edge, and middle cells

## 當天筆記摘錄

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

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

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

## 複雜度

Time O(number of cells), Space O(width of last row).

## 要特別避免的錯誤

- Trying to greedily choose the smaller child at each row.
- Forgetting that row lengths change.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
