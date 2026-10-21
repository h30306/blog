---
title: "LeetCode 125: Valid Palindrome"
summary: "LeetCode 125 解題筆記：左右指針跳過非英數字元，再比較小寫是否相同；數字也要算進去"
description: "2022-08-16 的 LeetCode 125 解題紀錄"
date: 2022-08-16
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
第一次嘗試：2022-08-16
- 提交紀錄：Runtime Error ×2 → Accepted ×2 → Wrong Answer ×2 → Accepted ×8 → Wrong Answer → Accepted ×2

## 解題思路

左右指針往中間走（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）：兩邊各自跳過不是**英文字母或數字**的字元，再比較轉成小寫後是否相同。

## 我的嘗試

2022-08 第一次寫的是「用 `isalnum` 過濾、轉小寫、跟反轉比」，前兩版是 generator 少打了 `in s`、`sif` 黏在一起的語法錯誤，修好就 AC。之後兩次重寫：2022-10 改用 `isalpha` 過濾（也忘了轉小寫），2026 年用左右指針、自己寫了只判斷英文字母的函式，兩次都**漏掉數字**，例如 `"1A"`：`1` 和 `a` 不同，答案 `False`，回傳 `True`。

## 正確解法

```python
class Solution:
    def isPalindrome(self, s: str) -> bool:
        l, r = 0, len(s) - 1
        while l < r:
            if not s[l].isalnum():
                l += 1
            elif not s[r].isalnum():
                r -= 1
            elif s[l].lower() != s[r].lower():
                return False
            else:
                l, r = l + 1, r - 1
        return True
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 題目說的是 alphanumeric，**數字也要比**，不能只留字母。

## 面試口說整理

我用左右指針往中間走，遇到不是英數字元就跳過，其他的轉小寫比較，有一對不同就不是回文。時間 `O(n)`、空間 `O(1)`。
