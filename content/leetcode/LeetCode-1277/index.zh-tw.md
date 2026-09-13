---
title: "LeetCode 1277: Count Square Submatrices With All Ones"
summary: "LeetCode 1277 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-04 的 LeetCode 1277 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-04
tags: ["medium", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-04
來源：Day 32 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 1277`: pass after state-definition repair
- explain `LC 1277` using the same local square state as `LC 221`, but with `sum(dp)` as the final aggregation

## 當天筆記摘錄

#### Problem 2 - LC 1277 Count Square Submatrices With All Ones
- **Pattern:** 2D DP on square geometry with count aggregation.

#### Why This Fits
This is the same local square-growth logic as `LC 221`, but the question changed from:
```text
what is the largest square?
```

to:
```text
how many all-1 squares exist in total?
```

So the state can stay almost the same, but the final aggregation changes.

#### Core State / Invariant
```text
dp[r][c] = side length of the largest all-1 square whose bottom-right corner is (r, c)
```

#### Transition
If `matrix[r][c] == 0`:
```text
dp[r][c] = 0
```

If `matrix[r][c] == 1` and not on the first row or first column:
```text
dp[r][c] = 1 + min(dp[r - 1][c], dp[r][c - 1], dp[r - 1][c - 1])
```

Boundary `1` cells contribute:
```text
dp[r][c] = 1
```

#### Why Summing DP Works
If `dp[r][c] = k`, then that cell is the bottom-right corner of:
- one `1 x 1` square
- one `2 x 2` square
- ...
- one `k x k` square

So each `dp[r][c]` contributes exactly `k` valid squares to the final count.

#### Final Answer
```text
answer = sum(dp[r][c] for all cells)
```

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- reusing the `LC 221` state but still returning only the max
- forgetting that each side length contributes multiple squares
- using `max(...)` instead of `min(...)`
- not being able to explain why summing side lengths is valid

#### Strong Spoken Explanation
I reuse the same DP state as `LC 221`: `dp[r][c]` is the side length of the largest all-1 square ending at `(r, c)`. The recurrence stays the same because square growth still depends on top, left, and diagonal. The difference is the output: if a cell has largest side length `k`, it contributes `k` different valid squares ending there, so I sum all DP values instead of tracking only the maximum.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def countSquares(self, matrix: List[List[int]]) -> int:
        m, n = len(matrix), len(matrix[0])
        dp = [0] * (n + 1)
        total = 0

        for r in range(1, m + 1):
            prev_diag = 0
            for c in range(1, n + 1):
                old = dp[c]
                if matrix[r - 1][c - 1] == 1:
                    dp[c] = 1 + min(dp[c], dp[c - 1], prev_diag)
                    total += dp[c]
                else:
                    dp[c] = 0
                prev_diag = old

        return total
```

## 複雜度

Time O(mn), Space O(n).

## 要特別避免的錯誤

- Returning only the maximum side length like LC 221.
- Forgetting each side length from 1..dp[r][c] is a separate square.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
