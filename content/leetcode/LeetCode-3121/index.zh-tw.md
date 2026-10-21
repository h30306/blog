---
title: "LeetCode 3121: Count the Number of Special Characters II"
summary: "LeetCode 3121 解題筆記：記錄每個字母小寫最後一次出現和大寫第一次出現的位置，小寫最後一次在大寫第一次之前才算"
description: "2024-04-21 的 LeetCode 3121 解題紀錄"
date: 2024-04-21
tags: ["medium", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2024-04-21
- 提交紀錄：Wrong Answer ×4 → Accepted

## 解題思路

「所有小寫都出現在第一個大寫之前」等於「**小寫最後一次出現的位置** < **大寫第一次出現的位置**」。掃一次記錄兩個位置（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})），兩者都存在而且順序正確的字母就算 special。

## 我的嘗試

2024 年比賽時錯了四次：

- 第一版用 `w not in upper` 判斷大寫是否記過，但 `w` 是大寫、dict 的 key 存的是小寫，**永遠判斷成沒記過**，第一次出現的位置被後面的大寫覆蓋：`"AaA"` 答案 0，回傳 1。
- 改用集合追蹤狀態之後，一版把「小寫之後**又出現大寫**」也當成錯誤：`"aAA"` 答案 1，回傳 0。
- 下一版修好了，但**大寫先出現、小寫後出現**的情況雖然記了下來卻沒有用來排除：`"AaA"` 回傳 1。補上這個檢查才 AC。

## 正確解法

```python
class Solution:
    def numberOfSpecialChars(self, word: str) -> int:
        last_lower = {}
        first_upper = {}
        for i, c in enumerate(word):
            if c.islower():
                last_lower[c] = i
            elif c.lower() not in first_upper:
                first_upper[c.lower()] = i
        return sum(1 for c, i in last_lower.items()
                   if c in first_upper and i < first_upper[c])
```

## 複雜度

時間 `O(n)`，空間 `O(26)`。

## 要特別避免的錯誤

- 大寫要記**第一次**、小寫要記**最後一次**。
- 存成 dict 的 key 時大小寫要一致，否則「已經記過了」的判斷永遠不成立。
- 大寫在小寫之前（例如 `"Aa"`）也不合格。

## 面試口說整理

我掃一次，記錄每個字母小寫最後出現的位置和大寫第一次出現的位置，兩個都存在而且小寫在前面的字母才算。時間 `O(n)`。
