---
title: "LeetCode 728: Self Dividing Numbers"
summary: "LeetCode 728 解題筆記：逐一檢查範圍內的每個數，每一位都不能是 0 而且要能整除這個數"
description: "2022-08-31 的 LeetCode 728 解題紀錄"
date: 2022-08-31
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
第一次嘗試：2022-08-31
- 提交紀錄：Wrong Answer ×2 → Runtime Error ×3 → Wrong Answer → Runtime Error ×7 → Accepted ×2 → Runtime Error ×2 → Accepted

## 解題思路

範圍很小（最多 `10^4`），逐一檢查就好。用 `% 10`、`// 10` 取出每一位（[Math]({{< relref "/algorithm/Math" >}}) 模板五）：有任何一位是 **0** 就不合格（不能除以 0，題目也規定不能含 0），否則檢查 `x % d == 0`。

## 我的嘗試

這題提交了 18 次：

- 第一版忘了 `return`；第二版用 `//` 判斷整除，`i // d != 0` 幾乎永遠成立，兩位數全部被排除：`(2, 11)` 少了 `11`。
- 改成 `%` 之後，遇到 `10` 這種含 0 的數就 ZeroDivisionError，接下來試了十幾次。其中一版改成「跳過 0 這一位」，**`10` 就被算進去了**，但含 0 的數本身就不合格。
- 最後把判斷寫成一個 helper，遇到 0 直接回傳 `False` 才 AC。

## 正確解法

```python
class Solution:
    def selfDividingNumbers(self, left: int, right: int) -> List[int]:
        def ok(x):
            n = x
            while n:
                d = n % 10
                if d == 0 or x % d:
                    return False
                n //= 10
            return True
        return [x for x in range(left, right + 1) if ok(x)]
```

## 複雜度

時間 `O((right - left) · log right)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 整除要用 `%`，不是 `//`。
- 含 0 的數直接不合格，不是跳過那一位。

## 面試口說整理

我逐一檢查範圍內的數，用取餘數拿出每一位，遇到 0 或不能整除就不合格。時間是範圍長度乘上位數。
