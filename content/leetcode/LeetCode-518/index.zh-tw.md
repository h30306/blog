---
title: "LeetCode 518: Coin Change 2"
summary: "LeetCode 518 解題筆記，依照原始 learning note 重新整理"
description: "2026-08-23 的 LeetCode 518 學習紀錄，包含筆記修正點與正確解法"
date: 2026-08-23
tags: ["medium", "dynamic-programming", "unbounded-knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-23
來源：Day 43 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 518` is the clean `unbounded` counting anchor.
- I do not classify knapsack problems by surface wording alone. I ask three things: can each item be reused, what exactly does `dp[...]` represent, and what loop direction preserves that meaning in 1D compression. `LC 416` is `0/1` reachability so the target loop goes backward. `LC 518` is unbounded counting so the amount loop goes forward. `LC 322` is also unbounded, but its state is minimum coins, so the recurrence and invalid-state handling are different.
- explain `LC 518` as unbounded counting with forward loop direction
- explain why `LC 322` is a different answer shape from `LC 518`

## 當天筆記摘錄

#### Problem 2 - LC 518 Coin Change 2
- **Pattern:** unbounded knapsack counting combinations

#### Why This Fits
Each coin can be reused:
```text
any number of times
```

The question is:
```text
how many combinations make the amount?
```

#### Core State / Invariant
```text
dp[a] = number of combinations to make amount a using the coins processed so far
```

#### Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make amount 0: choose no coins
```

#### Transition
For each `coin`:
```text
dp[a] += dp[a - coin]
```

when:
```text
a >= coin
```

#### Why Loop Direction Matters
Iterate amount forward:
```text
for a from coin up to amount
```

Reason:
```text
forward iteration lets the current coin be reused in the same coin round
```

#### Complexity
```text
Time: O(len(coins) * amount)
Space: O(amount)
```

#### Common Mistakes
- iterating amount backward and accidentally enforcing `0/1`
- putting amount as the outer loop and counting permutations instead of combinations
- saying `dp[a]` is minimum coins instead of number of ways
- forgetting why `dp[0] = 1`

#### Strong Spoken Explanation
I define `dp[a]` as the number of combinations to make amount `a` using the coins processed so far. The base case is `dp[0] = 1`, because there is exactly one way to make amount zero: choose nothing. For each coin, I iterate amounts forward so the same coin can be reused in the same round. The transition is `dp[a] += dp[a - coin]`. Keeping coins as the outer loop makes the answer combinations rather than permutations.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def change(self, amount: int, coins: List[int]) -> int:
        dp = [0] * (amount + 1)
        dp[0] = 1

        for coin in coins:
            for a in range(coin, amount + 1):
                dp[a] += dp[a - coin]

        return dp[amount]
```

## 複雜度

Time O(len(coins) * amount), Space O(amount).

## 要特別避免的錯誤

- Putting amount outside counts permutations.
- Iterating amounts backward turns it into 0/1 knapsack.
- Confusing this with LC 322, which minimizes coin count.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
