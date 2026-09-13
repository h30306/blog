---
title: "LeetCode 122: Best Time To Buy And Sell Stock II"
summary: "LeetCode 解題筆記：Best Time To Buy And Sell Stock II"
description: "2026-05-17 的 LeetCode 學習紀錄"
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
來源筆記：`notes/day22-week5-day1-stock-i-ii-btree-index-internals.md`

## 解題思路

這篇整理 Best Time To Buy And Sell Stock II 的解題筆記，重點放在 unlimited-transactions state machine、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** unlimited-transactions state machine.

## Why This Fits
This is the simplest full stock-state problem:
- `hold = best profit while holding a stock after day i`
- `cash = best profit while not holding a stock after day i`

Because transactions are unlimited, the key difference from Stock I is:
```text
after selling, you are allowed to re-enter later
```

## Core Transitions
```text
hold = max(previous_hold, previous_cash - price)
cash = max(previous_cash, previous_hold + price)
```

## Interview-Ready Explanation
I define `hold` as the best profit if I end the day holding one stock, and `cash` as the best profit if I end the day not holding stock. On each day, I either keep the previous state or transition by buying or selling once. The value of the problem is not the formula itself, but that each transition comes directly from the meaning of the state.

## Common Mistakes
- updating states in the wrong order without preserving previous values
- treating this as arbitrary greedy accumulation without understanding state meaning
- not being able to explain why buy/sell transitions are legal

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
