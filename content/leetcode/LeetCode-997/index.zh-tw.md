---
title: "LeetCode 997: Find the Town Judge"
summary: "LeetCode 997 解題筆記：法官被其他 n - 1 個人信任而且不信任任何人，所以 in-degree - out-degree == n - 1"
description: "2022-09-27 的 LeetCode 997 解題紀錄"
date: 2022-09-27
tags: ["easy", "array", "hash-table", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-27
- 提交紀錄：Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×2 → Runtime Error → Wrong Answer ×3 → Runtime Error ×2 → Wrong Answer ×4 → Accepted ×2 → Runtime Error → Wrong Answer ×2 → Accepted

## 解題思路

把信任關係看成有向圖。法官的條件是：被**每個其他人**信任（in-degree 是 `n - 1`）、**不信任任何人**（out-degree 是 0）。用一個陣列記 `in - out`，等於 `n - 1` 的就是法官（只有法官可能達到，因為 in-degree 最多 `n - 1`）。`n = 1`、沒有任何信任關係時，那個人就是法官。

## 我的嘗試

這題 2022-09 和 2022-11 共提交了 21 次：

- 一開始用猜的：`n == len(trust)` 就回傳 `False`、直接回傳 `n`，`n = 2`、沒有信任關係時回傳 2，答案 -1。
- 改成數 in-degree，只檢查「被 `n - 1` 個人信任」，**沒有檢查他自己不信任任何人**；之後補上了這個條件，又在 `n = 1`、`trust` 是空的時錯了（答案是 1，回傳 -1），然後特判 `trust == []` 回傳 1，`n = 2` 時又錯了。
- 2022-11 重寫時把兩個特例（`n == 1` 回傳 1、否則 -1）分開處理才 AC。用 `in - out == n - 1` 就不需要這些特判。

## 正確解法

```python
class Solution:
    def findJudge(self, n: int, trust: List[List[int]]) -> int:
        score = [0] * (n + 1)
        for a, b in trust:
            score[a] -= 1
            score[b] += 1
        for i in range(1, n + 1):
            if score[i] == n - 1:
                return i
        return -1
```

## 複雜度

時間 `O(n + t)`，空間 `O(n)`。

## 要特別避免的錯誤

- 兩個條件都要：被 `n - 1` 個人信任，而且自己不信任任何人。
- `n = 1`、`trust` 是空的時答案是 1。

## 面試口說整理

法官被其他所有人信任而且不信任任何人，所以我用一個陣列記每個人被信任的次數減掉信任別人的次數，等於 n - 1 的就是法官。時間 `O(n + t)`。
