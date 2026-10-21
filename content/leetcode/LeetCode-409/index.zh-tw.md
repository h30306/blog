---
title: "LeetCode 409: Longest Palindrome"
summary: "LeetCode 409 解題筆記：每個字元取偶數個放兩邊，只要有任何奇數次的字元，中間還能再放一個"
description: "2022-08-23 的 LeetCode 409 解題紀錄"
date: 2022-08-23
tags: ["easy", "hash-table", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Wrong Answer ×4 → Accepted → Wrong Answer → Accepted

## 解題思路

回文兩邊對稱，所以每個字元最多用 `v // 2 * 2` 個（偶數）。奇數次的字元剩下的那一個，只有**一個**可以放在正中間：只要有任何奇數次，答案再加 1（[Greedy]({{< relref "/algorithm/Greedy" >}})，[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 計數）。大小寫是不同的字元。

## 我的嘗試

2022 年錯了四次，都在處理奇數次的字元：

- 第一版用 `v / 2`（浮點數），而且偶數次只加了一半：`"aa"` 回傳 `1.0`。
- 第二版奇數次的字元**只加 1**，忽略了可以用掉的 `v - 1` 個：`"bbb"` 答案 3，回傳 1。
- 第三版改成加 `v - 1`，但這時候**忘了中間的 1**：`"bbb"` 回傳 2；第四版又改成加 `v` 再加 1，變成 4。

2026 年重寫時邏輯對了，但寫成 `return res + 1 if plus_one else 0`，**條件運算子的優先順序比 `+` 低**，整句變成 `(res + 1) if plus_one else 0`，沒有奇數次時回傳 0：`"aa"` 回傳 0。

## 正確解法

```python
class Solution:
    def longestPalindrome(self, s: str) -> int:
        cnt = Counter(s)
        res = sum(v // 2 * 2 for v in cnt.values())
        return res + (1 if any(v % 2 for v in cnt.values()) else 0)
```

## 複雜度

時間 `O(n)`，空間 `O(k)`。

## 要特別避免的錯誤

- 奇數次的字元也能用掉 `v - 1` 個，不是只能放一個在中間。
- `res + 1 if odd else 0` 會被解讀成 `(res + 1) if odd else 0`，要加括號。
- `v / 2` 是浮點數，要用 `//`。

## 面試口說整理

我數每個字元的次數，每個字元都取偶數個放在兩邊，只要有任何字元是奇數次，中間就能再多放一個。時間 `O(n)`。
