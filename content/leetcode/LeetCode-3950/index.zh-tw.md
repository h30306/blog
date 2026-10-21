---
title: "LeetCode 3950: Exactly One Consecutive Set Bits Pair"
summary: "LeetCode 3950 解題筆記：n & (n >> 1) 的每個 1 代表一對相鄰的 1，剛好一對就是它只有一個 1"
description: "2026-06-11 的 LeetCode 3950 解題紀錄"
date: 2026-06-11
tags: ["easy", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-06-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

`n >> 1` 把每一位往右移一格，跟 `n` 做 AND 之後，第 `i` 位是 1 代表 `n` 的第 `i` 和 `i + 1` 位都是 1（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}) 模板二）。所以 `pairs = n & (n >> 1)` 的 1 的個數就是相鄰配對數；剛好一對就是 `pairs` 不是 0 而且只有一個 1。重疊的也算，例如 `111` 有兩對。

## 我的解法

```python
class Solution:
    def consecutiveSetBits(self, n: int) -> bool:
        pairs = n & (n >> 1)
        return pairs != 0 and pairs & (pairs - 1) == 0
```

我當時把 `bin(n)` 轉成字串，數 `"11"` 出現幾次（逐位比對，重疊的也會數到）。

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- `str.count("11")` 不會數重疊的，`"111".count("11")` 是 1；要逐位比對或用位元運算。

## 面試口說整理

`n & (n >> 1)` 的每個 1 代表一對相鄰的 1，所以我檢查它不是 0、而且 `x & (x - 1)` 是 0，也就是剛好一個 1。時間 `O(1)`。
