---
title: "LeetCode 1768: Merge Strings Alternately"
summary: "LeetCode 1768 解題筆記：兩個指針輪流取字元，短的用完後接上長的剩下部分"
description: "2025-03-18 的 LeetCode 1768 解題紀錄"
date: 2025-03-18
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-03-18
- 提交紀錄：Accepted → Time Limit Exceeded → Accepted

## 解題思路

從 `word1` 開始，兩個字串輪流各取一個字元；其中一個用完之後，把另一個剩下的部分接在後面。

## 我的嘗試

第一版用 `zip` 取到短的那個用完，再用 `round(len(res) / 2)` 算出已經用了幾個字元，接上兩邊剩下的部分。結果正確，但用 `round` 算長度有點繞。

第二版改成手寫 index：

```python
idx = 0
while idx < len(word1) or idx < len(word2):
    res += word1[idx] + word2[idx]          # idx 從來沒有加 1
```

迴圈裡**忘記 `idx += 1`**，無限迴圈，TLE。而且條件用 `or` 的話，短的那個用完之後還會去讀它，會越界。改成 `and` 加上 `idx += 1` 就 AC 了。

## 正確解法

```python
class Solution:
    def mergeAlternately(self, word1: str, word2: str) -> str:
        res = []
        i = 0
        while i < len(word1) and i < len(word2):
            res.append(word1[i])
            res.append(word2[i])
            i += 1
        return "".join(res) + word1[i:] + word2[i:]
```

迴圈結束時，至少有一個字串已經用完，所以 `word1[i:] + word2[i:]` 只會接上還有剩的那一個。

## 複雜度

時間 `O(n + m)`，空間 `O(n + m)`。

## 要特別避免的錯誤

- `while` 迴圈裡忘記移動 index。
- 條件用 `or`：短的字串用完後會越界。
- 用 `+=` 串接字串：Python 字串不可變，每次都會建新字串；用 list 收集再 `join` 比較好。

## 面試口說整理

我用一個 index 同時走兩個字串，輪流各取一個字元，直到其中一個用完。迴圈結束時至少有一邊已經用完，所以直接接上兩邊剩下的部分。用 list 收集字元再 `join`，時間 `O(n + m)`。
