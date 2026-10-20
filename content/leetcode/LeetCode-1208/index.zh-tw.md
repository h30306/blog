---
title: "LeetCode 1208: Get Equal Substrings Within Budget"
summary: "LeetCode 1208 解題筆記：每個位置的花費是 |s[i] - t[i]|，題目變成「總和 <= maxCost 的最長子陣列」"
description: "2026-01-10 的 LeetCode 1208 解題紀錄"
date: 2026-01-10
tags: ["medium", "sliding-window", "string", "binary-search", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

位置 `i` 的花費是 `|ord(s[i]) - ord(t[i])|`，都是非負數。題目就變成：**花費陣列裡總和 `<= maxCost` 的最長子陣列**。

花費都非負，視窗越大總和越大，條件單調，用「求最長」的滑動視窗。

## 我的解法

```python
class Solution:
    def equalSubstring(self, s: str, t: str, maxCost: int) -> int:
        left = cost = best = 0
        for right in range(len(s)):
            cost += abs(ord(s[right]) - ord(t[right]))
            while cost > maxCost:
                cost -= abs(ord(s[left]) - ord(t[left]))
                left += 1
            best = max(best, right - left + 1)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 花費有負數時不能用滑動視窗，但這題是絕對值，一定非負。

## 面試口說整理

把每個位置的花費算成 `|s[i] - t[i]|`，題目就變成總和不超過 `maxCost` 的最長子陣列。花費都是非負的，所以用滑動視窗：超過預算就縮左邊，記錄最長長度。時間 `O(n)`。
