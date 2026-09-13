---
title: "LeetCode 474: Ones and Zeroes"
summary: "LeetCode 474 解題筆記，依照原始 learning note 重新整理"
description: "2026-08-19 的 LeetCode 474 學習紀錄，包含筆記修正點與正確解法"
date: 2026-08-19
tags: ["medium", "dynamic-programming", "knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-19
來源：Day 45 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 474`: pass after invariant wording repair
- explain `LC 474` as a two-capacity `0/1` knapsack with backward loops in both dimensions

## 當天筆記摘錄

#### Problem 1 - LC 474 Ones and Zeroes
- **Pattern:** two-capacity `0/1` knapsack maximization.

#### Why This Fits
Each string can be picked:
```text
at most once
```

Each picked string consumes:
- some zeros
- some ones

The value of picking it is:
```text
+1 string in the subset
```

#### Core State / Invariant
```text
dp[i][j] = maximum number of strings we can pick from the strings processed so far
using at most i zeros and j ones
```

#### Base Case
Initialize the whole table to:
```text
0
```

Reason:
```text
before processing any strings, the best answer is 0
```

#### Transition
For a string with `zeros` and `ones`:
```text
dp[i][j] = max(dp[i][j], dp[i - zeros][j - ones] + 1)
```

#### Why Both Loops Go Backward
The transition reads:
```text
dp[i - zeros][j - ones]
```

That source state must still belong to:
```text
previous strings only
```

If either capacity loop goes forward, the same string can be reused again in the same iteration.

#### Complexity
```text
Time: O(len(strs) * m * n)
Space: O(m * n)
```

#### Common Mistakes
- forgetting this is two-capacity, not one-capacity
- saying the value is zeros or ones instead of number of strings chosen
- going forward in one dimension and backward in the other
- omitting `processed so far` from the invariant

#### Strong Spoken Explanation
This is a two-capacity `0/1` knapsack. Each string is an item, its cost is `(zeroCount, oneCount)`, and its value is `1` because taking that string increases the answer by one. I use `dp[i][j]` to mean the maximum number of strings I can pick from the strings processed so far using at most `i` zeros and `j` ones. For each string, I count its zeros and ones, then iterate both capacities backward and update `dp[i][j] = max(dp[i][j], dp[i - zeros][j - ones] + 1)`. Both loops must go backward so the current string is only used once.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def findMaxForm(self, strs: List[str], m: int, n: int) -> int:
        dp = [[0] * (n + 1) for _ in range(m + 1)]

        for s in strs:
            zeros = s.count('0')
            ones = len(s) - zeros
            for z in range(m, zeros - 1, -1):
                for o in range(n, ones - 1, -1):
                    dp[z][o] = max(dp[z][o], dp[z - zeros][o - ones] + 1)

        return dp[m][n]
```

## 複雜度

Time O(len(strs)*m*n), Space O(m*n).

## 要特別避免的錯誤

- Iterating capacities forward and reusing the same string.
- Tracking only one capacity.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
