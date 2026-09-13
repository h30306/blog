---
title: "LeetCode 121: Best Time To Buy And Sell Stock"
summary: "LeetCode 121 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-17 的 LeetCode 121 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-17
tags: ["easy", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-05-17
來源：Day 22 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 121 Best Time To Buy And Sell Stock
- **Pattern:** 1-transaction state machine / running minimum.

#### Why This Fits
There is only one buy and one sell.

The two clean mental models are:
- running minimum price so far, then compute best profit
- 2-state DP:
  - `hold = best profit while holding one stock`
  - `cash = best profit while not holding stock`

#### Core Invariant
```text
At day i, each state means the best profit achievable under that exact holding condition.
```

#### Interview-Ready Explanation
For Stock I, I only need to know the cheapest buy price seen so far and the best sell profit I can realize afterward. In state-machine terms, I can model `hold` and `cash`, but because only one transaction is allowed, this collapses into tracking the running minimum price and updating the best profit with `price - min_price`.

#### Common Mistakes
- memorizing the formula without knowing the state meaning
- allowing more than one buy/sell cycle
- saying "greedy" without explaining the invariant

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        min_price = float('inf')
        best = 0

        for price in prices:
            min_price = min(min_price, price)
            best = max(best, price - min_price)

        return best
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Selling before buying.
- Using multiple transactions; this version allows one transaction only.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
