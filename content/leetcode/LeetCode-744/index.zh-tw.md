---
title: "LeetCode 744: Find Smallest Letter Greater Than Target"
summary: "LeetCode 744 解題筆記：找第一個 > target 的字母（upper bound）；找不到就繞回第一個"
description: "2022-09-03 的 LeetCode 744 解題紀錄"
date: 2022-09-03
tags: ["easy", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-03
- 提交紀錄：Wrong Answer ×2 → Runtime Error ×2 → Wrong Answer ×5 → Accepted ×2 → Wrong Answer → Time Limit Exceeded ×2 → Accepted

## 解題思路

已排序的字母裡找第一個**嚴格大於** `target` 的，也就是 upper bound（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一），用 `bisect_right`。如果所有字母都 `<= target`，題目要繞回第一個，用 `% len` 處理。

## 我的嘗試

這題提交了 15 次。一開始想用 `ord` 加 26 處理繞回：比 `target` 小的字母都加 26 再取最小，但最後回傳了數字（`123`）或 `chr` 之後沒有減回 26（`'{'`），例如 `['a', 'h']`、`target = 'j'`：答案 `'a'`。改成二分之後有兩版區間縮不動（TLE）。

## 正確解法

```python
class Solution:
    def nextGreatestLetter(self, letters: List[str], target: str) -> str:
        return letters[bisect.bisect_right(letters, target) % len(letters)]
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 是嚴格大於，等於 `target` 的不算，所以是 `bisect_right`。
- 回傳的是字母，不是 `ord` 的數字。

## 面試口說整理

我用 `bisect_right` 找第一個嚴格大於目標的字母的位置，超出範圍時取餘數繞回第一個。時間 `O(log n)`。
