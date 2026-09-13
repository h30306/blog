---
title: "LeetCode 309: Best Time to Buy and Sell Stock with Cooldown"
summary: "LeetCode 309 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-17 的 LeetCode 309 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-17
tags: ["medium", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-17
來源：Day 23 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 309 Best Time to Buy and Sell Stock with Cooldown
- **Pattern:** state-machine DP with one-day post-sell restriction.

#### Why This Fits
The problem is still:
```text
best profit under exact holding conditions after day i
```

But now selling changes what is legal on the next day:
```text
after a sell, you cannot buy immediately the next day
```

That means the simple `hold/cash` model is not enough unless the cooldown effect is represented explicitly.

#### Core State / Invariant
One clean 3-state version:
```text
hold = best profit after day i while holding one stock
sold = best profit after day i if we sold today
rest = best profit after day i while not holding and not selling today
```

Meaning matters more than the formula:
- `hold` means we own a stock at end of day
- `sold` means we just sold today, so tomorrow is cooldown
- `rest` means we are free to buy tomorrow

#### Transitions
```text
hold = max(previous_hold, previous_rest - price)
sold = previous_hold + price
rest = max(previous_rest, previous_sold)
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- reusing `sold` immediately for a same-day buy transition
- collapsing all non-hold states into one state and losing cooldown meaning
- memorizing `3` variables without being able to explain what each means
- returning `hold` instead of realized-profit states at the end

#### Strong Spoken Explanation
I model the best profit under three end-of-day conditions: holding, sold-today, and resting. Cooldown matters because the day after a sell is not buy-eligible, so a new buy can only come from `rest`, not from `sold`. Each transition follows directly from that state meaning, which is why I do not need to memorize the formula.

#### Final Answer Meaning
```text
answer = max(sold, rest)
```

Reason:
- final realized profit must be a non-holding state
- ending in `hold` means the profit is not fully realized yet

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        hold = float('-inf')
        sold = float('-inf')
        rest = 0

        for price in prices:
            hold, sold, rest = max(hold, rest - price), hold + price, max(rest, sold)

        return max(sold, rest)
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Buying immediately after a sell.
- Using one cash state without modeling cooldown.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
