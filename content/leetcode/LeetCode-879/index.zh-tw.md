---
title: "LeetCode 879: Profitable Schemes"
summary: "LeetCode 879 解題筆記，依照原始 learning note 重新整理"
description: "2026-08-19 的 LeetCode 879 學習紀錄，包含筆記修正點與正確解法"
date: 2026-08-19
tags: ["hard", "dynamic-programming", "knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-19
來源：Day 46 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 879`: pass after state-definition repair
- explain `LC 879` with a state definition that exactly matches the code

## 當天筆記摘錄

#### Problem 1 - LC 879 Profitable Schemes
- **Pattern:** counting `0/1` knapsack with member capacity and capped profit threshold.

#### Why This Fits
Each crime can be:
```text
taken once or skipped
```

It consumes:
- some members

It contributes:
- some profit

The question is not to maximize profit.

It is:
```text
how many subsets satisfy members <= n and profit >= minProfit?
```

#### Core State / Invariant
For the implemented version used today:
```text
dp[p][m] = number of schemes that achieve at least profit p using at most m members
```

Profit is capped into:
```text
0..minProfit
```

#### Base Case
For every member limit `m`:
```text
dp[0][m] = 1
```

Reason:
```text
the empty set already achieves profit at least 0 and fits under any member cap
```

#### Transition
For a crime needing `g` members and giving profit `earn`:
```text
prevProfit = max(0, p - earn)
dp[p][m] += dp[prevProfit][m - g]
```

with modulo.

#### Why Profit Is Capped
Once a scheme already achieves:
```text
profit >= minProfit
```

extra profit does not create a new validity category.

So all larger profits can be merged into:
```text
the minProfit bucket
```

#### Complexity
```text
Time: O(len(group) * n * minProfit)
Space: O(n * minProfit)
```

#### Common Mistakes
- mixing `exactly m members` with `at most m members`
- using a state explanation that does not match the code
- forgetting why `dp[0][m] = 1` is valid in the `at most` formulation
- not capping profit at `minProfit`

#### Strong Spoken Explanation
This is a counting `0/1` knapsack. Each crime can be taken once, it consumes some members, and it contributes profit. The state I used is `dp[p][m] = number of schemes that achieve at least profit p using at most m members`. I cap the profit dimension at `minProfit` because once a scheme reaches that threshold, extra profit does not change whether it is valid. I initialize `dp[0][m] = 1` for all member limits because the empty set already satisfies profit at least `0`. Then for each crime I iterate both dimensions backward and add the previous-state count from `dp[max(0, p - earn)][m - g]`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def profitableSchemes(self, n: int, minProfit: int, group: List[int], profit: List[int]) -> int:
        mod = 10 ** 9 + 7
        dp = [[0] * (n + 1) for _ in range(minProfit + 1)]
        dp[0][0] = 1

        for members, gain in zip(group, profit):
            for p in range(minProfit, -1, -1):
                for used in range(n - members, -1, -1):
                    if dp[p][used] == 0:
                        continue
                    np = min(minProfit, p + gain)
                    dp[np][used + members] = (dp[np][used + members] + dp[p][used]) % mod

        return sum(dp[minProfit]) % mod
```

## 複雜度

Time O(crimes * minProfit * n), Space O(minProfit * n).

## 要特別避免的錯誤

- Iterating forward and using a crime multiple times.
- Not capping profit at minProfit.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
