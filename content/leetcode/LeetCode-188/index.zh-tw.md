---
title: "LeetCode 188: Best Time to Buy and Sell Stock IV"
summary: "LeetCode 188 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-17 的 LeetCode 188 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-17
tags: ["hard", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-05-17
來源：Day 24 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 188` is not a different family from `LC 123`.
- explain why `LC 188` is the generalized transaction-stage version of `LC 123`

## 當天筆記摘錄

#### Problem 2 - LC 188 Best Time to Buy and Sell Stock IV
- **Pattern:** generalized multi-transaction state-machine DP.

#### Why This Fits
`LC 188` is not a different family from `LC 123`.

It is:
```text
the same state-machine idea, repeated for every transaction stage up to k
```

#### Core State / Invariant
One clean definition:
```text
hold[t] = best profit if I end today holding one stock after having completed t - 1 sells
cash[t] = best profit if I end today not holding stock after having completed t sells
```

So:
- `hold[1]` corresponds to the first-buy stage
- `cash[1]` corresponds to the first-sell stage
- `hold[2]` corresponds to the second-buy stage
- `cash[2]` corresponds to the second-sell stage

This is why:
```text
LC 123 is just LC 188 with k = 2 hardcoded into named variables
```

#### Transition Pattern
In words:
- `hold[t]` either keeps holding from yesterday, or buys today using the best non-holding profit after `t - 1` completed transactions
- `cash[t]` either keeps the realized profit from yesterday, or sells today from the corresponding holding state and completes transaction `t`

Clean mental model:
```text
buy from previous cash stage
sell from matching hold stage
```

#### Initialization Intuition
Use arrays sized `k + 1` so transaction stage `0` is a real baseline:
- `cash[0] = 0`
- higher `cash` states start at `0` or unreachable depending on formulation
- all `hold` states should start unreachable except when a legal buy transition is made

The main benefit of `k + 1` indexing is:
```text
hold[1] can cleanly buy from cash[0]
```

#### Large-k Optimization
If:
```text
k >= n // 2
```

then the transaction cap is no longer binding.

Why:
- a full transaction needs at least 2 days
- so you cannot physically complete more than `n // 2` profitable transactions anyway

That means the problem collapses to:
```text
unlimited transactions
```

#### Why Unlimited-Transactions Greedy Works
On any increasing run such as:
```text
1 -> 3 -> 5 -> 8
```

you can either:
- take one transaction with profit `8 - 1`
- or sum adjacent gains:
  - `(3 - 1) + (5 - 3) + (8 - 5)`

Those are equal.

So once the transaction cap stops mattering, summing all positive day-to-day gains captures the full profit of each upward trend.

#### Complexity
```text
Time: O(nk)
Space: O(k)
```

#### Common Mistakes
- saying the extra dimension means days instead of transaction stage
- getting the stage indexing wrong and accidentally reading `cash[-1]`
- mutating a previous stage too early and corrupting the transition meaning
- forgetting the `k >= n // 2` optimization

#### Strong Spoken Explanation
I generalize Stock III by turning the hardcoded buy/sell stages into arrays over transaction count. For each stage `t`, I track the best profit if I end today holding a stock and the best profit if I end today not holding after completing `t` sells. The recurrence stays the same as Stock III; I just repeat it for every transaction stage up to `k`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maxProfit(self, k: int, prices: List[int]) -> int:
        n = len(prices)
        if k >= n // 2:
            return sum(max(0, prices[i] - prices[i - 1]) for i in range(1, n))

        hold = [float('-inf')] * (k + 1)
        cash = [0] * (k + 1)

        for price in prices:
            for t in range(1, k + 1):
                hold[t] = max(hold[t], cash[t - 1] - price)
                cash[t] = max(cash[t], hold[t] + price)

        return cash[k]
```

## 複雜度

Time O(nk), Space O(k).

## 要特別避免的錯誤

- Forgetting the unlimited shortcut when k >= n/2.
- Mixing transaction count at buy vs sell time.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
