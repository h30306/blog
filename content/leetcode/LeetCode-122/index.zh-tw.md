---
title: "LeetCode 122: Best Time To Buy And Sell Stock II"
summary: "LeetCode 122 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-17 的 LeetCode 122 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-17
tags: ["medium", "dynamic-programming", "greedy", "state-machine"]
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
來源：Day 22 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 2 - LC 122 Best Time To Buy And Sell Stock II
- **Pattern:** unlimited-transactions state machine.

#### Why This Fits
This is the simplest full stock-state problem:
- `hold = best profit while holding a stock after day i`
- `cash = best profit while not holding a stock after day i`

Because transactions are unlimited, the key difference from Stock I is:
```text
after selling, you are allowed to re-enter later
```

#### Core Transitions
```text
hold = max(previous_hold, previous_cash - price)
cash = max(previous_cash, previous_hold + price)
```

#### Interview-Ready Explanation
I define `hold` as the best profit if I end the day holding one stock, and `cash` as the best profit if I end the day not holding stock. On each day, I either keep the previous state or transition by buying or selling once. The value of the problem is not the formula itself, but that each transition comes directly from the meaning of the state.

#### Common Mistakes
- updating states in the wrong order without preserving previous values
- treating this as arbitrary greedy accumulation without understanding state meaning
- not being able to explain why buy/sell transitions are legal

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        profit = 0
        for i in range(1, len(prices)):
            if prices[i] > prices[i - 1]:
                profit += prices[i] - prices[i - 1]
        return profit
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Overcomplicating with buy/sell dates.
- Forgetting unlimited transactions means adjacent rises can be combined.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
