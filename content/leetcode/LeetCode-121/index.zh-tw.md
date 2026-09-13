---
title: "LeetCode 121: Best Time To Buy And Sell Stock"
summary: "LeetCode 解題筆記：Best Time To Buy And Sell Stock"
description: "2026-05-17 的 LeetCode 學習紀錄"
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
來源筆記：`notes/day22-week5-day1-stock-i-ii-btree-index-internals.md`

## 解題思路

這篇整理 Best Time To Buy And Sell Stock 的解題筆記，重點放在 1-transaction state machine / running minimum、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 1-transaction state machine / running minimum.

## Why This Fits
There is only one buy and one sell.

The two clean mental models are:
- running minimum price so far, then compute best profit
- 2-state DP:
  - `hold = best profit while holding one stock`
  - `cash = best profit while not holding stock`

## Core Invariant
```text
At day i, each state means the best profit achievable under that exact holding condition.
```

## Interview-Ready Explanation
For Stock I, I only need to know the cheapest buy price seen so far and the best sell profit I can realize afterward. In state-machine terms, I can model `hold` and `cash`, but because only one transaction is allowed, this collapses into tracking the running minimum price and updating the best profit with `price - min_price`.

## Common Mistakes
- memorizing the formula without knowing the state meaning
- allowing more than one buy/sell cycle
- saying "greedy" without explaining the invariant

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
