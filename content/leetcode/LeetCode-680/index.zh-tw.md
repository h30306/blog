---
title: "LeetCode 680: Valid Palindrome II"
summary: "LeetCode 680 解題筆記：左右指針遇到第一對不同時，只有兩種刪法：刪左邊或刪右邊，檢查剩下的是否為回文"
description: "2022-08-30 的 LeetCode 680 解題紀錄"
date: 2022-08-30
tags: ["easy", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-30
- 提交紀錄：Wrong Answer ×7 → Runtime Error ×2 → Time Limit Exceeded → Runtime Error ×3 → Wrong Answer → Runtime Error → Wrong Answer ×3 → Runtime Error → Wrong Answer → Accepted ×2

## 解題思路

左右指針往中間比（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。遇到第一對不同的 `s[l] != s[r]`，最多只能刪一個，所以只有兩種可能：刪掉 `s[l]`（檢查 `s[l+1..r]`）或刪掉 `s[r]`（檢查 `s[l..r-1]`），任一個是回文就成立。之前比過的部分已經對稱，不用再檢查。

## 我的嘗試

這題提交了 22 次，前面幾版的思路是「數有幾對不同，超過一對就失敗」：但刪掉一個字元後，後面的配對會整個錯開，不能只數。例如 `"bca"`：只有一對不同（`b` 和 `a`），但刪哪一個都不是回文，答案 `False`，這幾版回傳 `True`。另外第一版還把 index 拿來比而不是字元。

## 正確解法

```python
class Solution:
    def validPalindrome(self, s: str) -> bool:
        def pal(l, r):
            while l < r:
                if s[l] != s[r]:
                    return False
                l, r = l + 1, r - 1
            return True
        l, r = 0, len(s) - 1
        while l < r:
            if s[l] != s[r]:
                return pal(l + 1, r) or pal(l, r - 1)
            l, r = l + 1, r - 1
        return True
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 不能只數「有幾對不同」：刪掉一個字元之後，後面的配對位置會整個錯開。

## 面試口說整理

左右指針往中間比，遇到第一對不同時只有刪左邊或刪右邊兩種選擇，我分別檢查剩下的區間是不是回文。時間 `O(n)`、空間 `O(1)`。
