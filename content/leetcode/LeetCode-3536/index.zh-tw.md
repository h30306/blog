---
title: "LeetCode 3536: Maximum Product of Two Digits"
summary: "LeetCode 3536 解題筆記：找出最大和第二大的位數相乘；找到新的最大值時，舊的最大值要移到第二名"
description: "2025-05-04 的 LeetCode 3536 解題紀錄"
date: 2025-05-04
tags: ["easy", "math", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-05-04
- 提交紀錄：Runtime Error ×4 → Wrong Answer ×2 → Accepted

## 解題思路

答案是最大的兩個位數相乘（同一個數字出現兩次可以用兩次）。最簡單是把位數排序取最後兩個；一次掃描的話，維護 `max1 >= max2`：

- 新的位數 `> max1`：**舊的 `max1` 變成 `max2`**，新的變成 `max1`。
- 否則如果 `> max2`：更新 `max2`。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 四次 RE | `map(n, str)` 參數順序反了；接著是字串跟整數 `0` 比較、字串相乘等型別錯誤 |
| 兩次 WA | 型別修好了，但找到新的最大值時，**舊的最大值沒有移到第二名**。例如 `n = 789`：答案是 `9 × 8 = 72`，兩版都回傳 0。第一版的條件是 `>=`，相同的 7 也只會蓋掉第一名，所以 `n = 707` 回傳 0，答案是 49 |
| AC | 改成 `max1, max2 = s, max1` |

## 正確解法

```python
class Solution:
    def maxProduct(self, n: int) -> int:
        digits = sorted(int(c) for c in str(n))
        return digits[-1] * digits[-2]
```

## 複雜度

時間 `O(d log d)`，`d` 是位數（最多 10 位），空間 `O(d)`。

## 要特別避免的錯誤

- 字串和整數混著比較。
- 維護前兩名時，新的第一名出現，舊的第一名要變成第二名。

## 面試口說整理

答案是最大的兩個位數相乘。我把位數排序取最後兩個；如果要一次掃描，就維護第一名和第二名，新的第一名出現時舊的第一名降成第二名。時間 `O(d)`。
