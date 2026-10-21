---
title: "LeetCode 647: Palindromic Substrings"
summary: "LeetCode 647 解題筆記：中心擴展，每擴展成功一次就是一個回文子字串"
description: "2022-11-01 的 LeetCode 647 解題紀錄"
date: 2022-11-01
tags: ["medium", "two-pointers", "string", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

跟 LC 5 一樣用中心擴展，`2n - 1` 個中心（字元和字元之間），往外擴的每一步只要兩端相同，就多了一個回文子字串。

## 我的嘗試

一次 AC，跟 LC 5 一樣用奇數、偶數兩個中心各擴展一次。

## 正確解法

```python
class Solution:
    def countSubstrings(self, s: str) -> int:
        count = 0
        for center in range(2 * len(s) - 1):
            l, r = center // 2, center // 2 + center % 2
            while l >= 0 and r < len(s) and s[l] == s[r]:
                count += 1
                l, r = l - 1, r + 1
        return count
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 奇數和偶數長度的中心都要算。

## 面試口說整理

我用中心擴展，每個字元和每兩個字元之間都當成中心，往外擴的每一步兩端相同就多一個回文子字串。時間 `O(n²)`、空間 `O(1)`。
