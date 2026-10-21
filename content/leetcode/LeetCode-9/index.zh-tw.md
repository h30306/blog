---
title: "LeetCode 9: Palindrome Number"
summary: "LeetCode 9 解題筆記：負數一定不是回文；不轉字串的話，把後半段的數字反轉，跟前半段比較"
description: "2019-09-17 的 LeetCode 9 解題紀錄"
date: 2019-09-17
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2019-09-17
- 提交紀錄：Accepted → Wrong Answer ×2 → Accepted → Runtime Error ×2 → Accepted ×2 → Runtime Error ×2 → Accepted ×3

## 解題思路

負數有 `-` 號，一定不是回文；結尾是 0 的正數也不是（開頭不會是 0）。進階要求不轉字串：用 `% 10`、`// 10` 把後半段的位數一個個取下來反轉（[Math]({{< relref "/algorithm/Math" >}}) 模板五），直到反轉的數 `>=` 剩下的數。位數是偶數時兩者相等；奇數時中間那位在 `rev` 裡，比較 `rev // 10`。

## 我的嘗試

- 2019 年第一次用字串反轉就 AC 了。隔天重寫時把負數的情況寫成 `return True`，**意思寫反了**：`-6` 回傳 `True`。
- 2022-05 試著切成兩半比較，但用 `/` 算中點，**得到浮點數不能當 slice 的 index**（TypeError），後來又改回字串反轉。

## 正確解法

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0 or (x % 10 == 0 and x != 0):
            return False
        rev = 0
        while x > rev:
            rev = rev * 10 + x % 10
            x //= 10
        return x == rev or x == rev // 10
```

## 複雜度

時間 `O(log x)`，空間 `O(1)`。

## 要特別避免的錯誤

- 負數回傳 `False`。
- 結尾是 0 的正數要先排除，不然 `10` 會被判斷成回文。
- `/` 是浮點數除法，不能拿來當 index。

## 面試口說整理

負數和結尾是 0 的正數先排除，接著把後半段的位數反轉，直到反轉的數不小於剩下的數，再比較兩者，位數是奇數時把中間那位除掉。時間 `O(log x)`，不用轉字串。
