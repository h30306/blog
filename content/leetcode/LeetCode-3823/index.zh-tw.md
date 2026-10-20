---
title: "LeetCode 3823: Reverse Letters Then Special Characters in a String"
summary: "LeetCode 3823 解題筆記：兩次對撞指針，第一次只交換字母，第二次只交換特殊字元"
description: "2026-01-31 的 LeetCode 3823 解題紀錄"
date: 2026-01-31
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
第一次嘗試：2026-01-31
- 提交紀錄：Accepted（一次通過）

## 解題思路

先把字母反轉、放回原本字母的位置；再把特殊字元反轉、放回原本特殊字元的位置。

每一次都是「反轉，但跳過另一種字元」的對撞指針：兩邊各自先跳到要處理的那種字元，交換，再一起往中間走。兩次反轉處理的位置互不重疊，所以順序不影響結果。

## 我的解法

```python
class Solution:
    def reverseByType(self, s: str) -> str:
        chars = list(s)

        def reverse(keep) -> None:
            left, right = 0, len(chars) - 1
            while left < right:
                while left < right and not keep(chars[left]):
                    left += 1
                while left < right and not keep(chars[right]):
                    right -= 1
                chars[left], chars[right] = chars[right], chars[left]
                left += 1
                right -= 1

        reverse(str.isalpha)
        reverse(lambda ch: not ch.isalpha())
        return "".join(chars)
```

原本的版本把兩次反轉各寫一遍，條件剛好相反。這裡把「要處理哪種字元」抽成參數，共用同一個函式。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 內層跳過的 `while` 沒有檢查 `left < right`：可能越過中間，交換到錯的位置。
- 直接修改字串：要先轉成 list。

## 面試口說整理

我做兩次對撞指針的反轉：第一次只交換字母，左右指針各自跳過不是字母的位置；第二次只交換特殊字元。兩次處理的位置互不重疊，所以可以分開做。共用一個以判斷函式為參數的反轉函式，時間 `O(n)`。
