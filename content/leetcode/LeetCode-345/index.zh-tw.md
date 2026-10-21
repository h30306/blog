---
title: "LeetCode 345: Reverse Vowels of a String"
summary: "LeetCode 345 解題筆記：跟 LC 917 一樣的左右指針，只是條件換成「是不是母音」（大小寫都要算）"
description: "2022-08-23 的 LeetCode 345 解題紀錄"
date: 2022-08-23
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
第一次嘗試：2022-08-23
- 提交紀錄：Accepted ×3

## 解題思路

左右指針各自跳過非母音，兩邊都是母音就交換（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。母音包含大寫，用一個集合 `"aeiouAEIOU"` 判斷。

## 我的解法

```python
class Solution:
    def reverseVowels(self, s: str) -> str:
        vowels = set("aeiouAEIOU")
        a = list(s)
        l, r = 0, len(a) - 1
        while l < r:
            if a[l] not in vowels:
                l += 1
            elif a[r] not in vowels:
                r -= 1
            else:
                a[l], a[r] = a[r], a[l]
                l, r = l + 1, r - 1
        return "".join(a)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 大寫母音也要算。

## 面試口說整理

我用左右指針跳過不是母音的字元，兩邊都是母音時交換再往中間走。時間 `O(n)`。
