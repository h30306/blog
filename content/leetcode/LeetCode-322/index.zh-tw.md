---
title: "LeetCode 322: Coin Change"
summary: "LeetCode 322 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-25 的 LeetCode 322 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-25
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
第一次嘗試：2026-04-25
來源：Day 10 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- **LC 322 Coin Change:** Repaired.

## 當天筆記摘錄

#### Problem 1 - LC 322 Coin Change
- **Status:** Repaired.
- **Pattern:** Unbounded minimum-count DP.
- **Main lesson:** Correct DP setup was mostly fine; the bug was control flow and greedy intuition.

#### State
```text
dp[i] = minimum number of coins needed to make amount i
```

#### Base Case
```text
dp[0] = 0
```

#### Transition
```text
dp[i] = min(dp[i], dp[i - coin] + 1)
```

for each reachable `i - coin`.

#### Initialization
```text
dp[i] = infinity for unreachable amounts
```

#### Important Repairs
- Do not early return just because `dp[amount]` becomes finite once.
- Do not assume reverse-sorting coins makes the first reachable answer optimal.
- Do not size the DP array with `len(coins) + 1`; it must be `amount + 1`.

#### Interview-Ready Explanation
This is a minimum-count DP problem. I define `dp[i]` as the minimum number of coins needed to make amount `i`. The base case is `dp[0] = 0`. For each coin, I update `dp[i]` from `dp[i - coin] + 1` if the smaller amount is reachable. After filling the table, if `dp[amount]` is still infinity, the answer is `-1`.

#### Complexity
```text
Time: O(amount * len(coins))
Space: O(amount)
```

#### Must-Know Distinction
```text
Coin Change minimum count -> dp[0] = 0
Coin Change 2 counting ways -> dp[0] = 1
```

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def coinChange(self, coins: List[int], amount: int) -> int:
        inf = amount + 1
        dp = [0] + [inf] * amount

        for a in range(1, amount + 1):
            for coin in coins:
                if coin <= a:
                    dp[a] = min(dp[a], dp[a - coin] + 1)

        return -1 if dp[amount] == inf else dp[amount]
```

## 複雜度

Time O(amount * len(coins)), Space O(amount).

## 要特別避免的錯誤

- Confusing with LC 518 counting combinations.
- Not using an unreachable sentinel.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
