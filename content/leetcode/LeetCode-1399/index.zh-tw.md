---
title: "LeetCode 1399: Count Largest Group"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-23
tags: ["LeetCode", "blog", "daily", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-23
- 總花費時間：15:00.00

## 解題思路

一開始我完全不知道這題到底在幹嘛...  
但在看了留言區的解釋後，了解到題目是要把數字根據「各位數字加總」來分組，最後回傳**最大組別大小的組數量**。  

我的直覺是使用一個 hash map 來記錄 **位數加總 → 出現次數（即組大小）**，並且用一個 `max_count` 常數來記錄目前最大的組大小。  
遍歷從 `1` 到 `n` 的每個數字後，我們可以得到最大的組大小，再遍歷 hash map 計算有多少組是這個大小，就是答案了。

這是一個 `O(n)` 的解法，只需要遍歷一遍數字。

## 解法


```python
class Solution:
    def countLargestGroup(self, n: int) -> int:
        seen = {}
        max_count = 0
        for i in range(1, n+1):
            digit_sum = sum(map(int, list(str(i))))
            count = seen.get(digit_sum, 0)
            max_count = max(max_count, count+1)
            seen[digit_sum] = count + 1

        return len([v for v in seen.values() if v == max_count])
```

## 收穫

NA

## 遇到的問題

NA