---
title: "LeetCode 504: Base 7"
summary: "LeetCode 504 解題筆記：對絕對值不斷取 % 7 和 // 7，最後加上負號並反轉；0 要特別處理"
description: "2022-08-25 的 LeetCode 504 解題紀錄"
date: 2022-08-25
tags: ["easy", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-25
- 提交紀錄：Runtime Error → Accepted

## 解題思路

進位轉換（[Math]({{< relref "/algorithm/Math" >}}) 模板七）：對 `abs(num)` 一直取 `% 7` 得到最低位、`// 7` 往前，最後反轉，負數再補 `-`。`num = 0` 時迴圈不會執行，要直接回傳 `"0"`。

## 我的嘗試

第一次提交貼錯了題目，送出的是另一題（BST 的眾數）的程式碼（AttributeError）。十幾秒後換成正確的程式就 AC 了。

## 正確解法

```python
class Solution:
    def convertToBase7(self, num: int) -> str:
        if num == 0:
            return "0"
        n, digits = abs(num), []
        while n:
            digits.append(str(n % 7))
            n //= 7
        return ("-" if num < 0 else "") + "".join(reversed(digits))
```

## 複雜度

時間 `O(log n)`，空間 `O(log n)`。

## 要特別避免的錯誤

- 0 要特別處理。
- 對負數用絕對值做，Python 的 `%` 對負數會回傳正的餘數。

## 面試口說整理

我對絕對值一直取除以 7 的餘數得到每一位，整除後繼續，最後反轉並加上負號；0 直接回傳。時間 `O(log n)`。
