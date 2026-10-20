---
title: "LeetCode 1888: Minimum Number of Flips to Make the Binary String Alternating"
summary: "LeetCode 1888 解題筆記：把移到尾巴的操作變成在 s + s 上滑動長度 n 的視窗；視窗跟 0101… 不同的數量是 diff，跟 1010… 不同的就是 n - diff"
description: "2026-01-03 的 LeetCode 1888 解題紀錄"
date: 2026-01-03
tags: ["medium", "sliding-window", "string", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-03
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

Type-1 操作（把開頭移到尾巴）做幾次都不用花錢，做完之後的字串一定是 `s` 的某個旋轉。**所有旋轉都是 `s + s` 裡長度 `n` 的子字串**，所以在 `s + s` 上滑動長度 `n` 的視窗。

每個視窗要變成交替字串，只有兩種目標：`0101…` 或 `1010…`。用絕對位置的奇偶性決定期望的字元，維護 `diff` = 視窗內跟 `0101…` 不同的數量。每個位置一定剛好跟其中一個目標不同，所以跟 `1010…` 不同的數量是 `n - diff`。

## 我的嘗試

第一版同時維護兩個計數，移出左邊元素時要用**左邊那個位置**的期望值判斷，但我複製貼上後用的還是右邊位置的 `expected1`、`expected2`。例如 `s = "011"`：轉成 `"101"` 不用翻，答案是 0；這版回傳 1。

改用 `expected1_left`、`expected2_left` 就 AC 了。

## 正確解法

```python
class Solution:
    def minFlips(self, s: str) -> int:
        n = len(s)
        t = s + s
        diff = 0                                   # 視窗內跟 0101... 不同的數量
        best = n
        for i, c in enumerate(t):
            diff += c != "01"[i % 2]
            if i >= n:
                diff -= t[i - n] != "01"[(i - n) % 2]   # 用左邊位置自己的期望值
            if i >= n - 1:
                best = min(best, diff, n - diff)
        return best
```

只維護一個計數，另一個用 `n - diff` 算，就不會有兩組變數複製貼上出錯的問題。

## 複雜度

時間 `O(n)`，空間 `O(n)`（`s + s`；也可以用 `i % n` 省掉）。

## 要特別避免的錯誤

- 移出元素時用了進來元素的期望值。
- 只考慮 `s` 本身，沒考慮旋轉。

## 面試口說整理

把開頭移到尾巴不用花錢，所以任何旋轉都能免費得到，而所有旋轉都是 `s + s` 裡長度 `n` 的子字串。我在 `s + s` 上滑動長度 `n` 的視窗，用位置奇偶性維護跟 `0101…` 不同的數量，跟 `1010…` 不同的就是 `n` 減它，每個視窗取兩者較小值。時間 `O(n)`。
