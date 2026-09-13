---
title: "LeetCode 1071: Greatest Common Divisor of Strings"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-08-09
tags: ["leetcode", "daily", "easy", "string", "gcd", "math"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: Easy
第一次嘗試： 2025-08-09
- 總花費時間：00:00.00

## 解題思路

把「最大公因字串」想成一個基底子字串，重複拼接後可以同時組成 `str1` 與 `str2`。答案一定是兩字串的共同前綴，且長度需同時整除兩字串長度。從長到短嘗試候選長度並逐一驗證。

## 解法

步驟概述：

- 設 `m = len(str1)`、`n = len(str2)`。
- 定義 `isValid(k)`：檢查 `str1[:k]` 作為基底，是否可重複形成兩字串。需滿足 `m % k == 0`、`n % k == 0`，且重複後等於原字串。
- 自 `k = m` 由大到小枚舉，回傳第一個通過驗證的前綴；皆不通過則回傳空字串。

## 收穫

- 合法答案長度必須同時整除 `m` 與 `n`。
- 若 `str1 + str2 != str2 + str1`，代表沒有共同基底，可快速判斷無解。
- 可優化：只檢查 `gcd(m, n)` 的因數，或直接測試 `str1[:gcd(m, n)]`。
- 複雜度：最壞約 O((m + n) × d)，`d` 為 `m` 與 `n` 的共同因數個數；空間 O(1)。

## 遇到的問題