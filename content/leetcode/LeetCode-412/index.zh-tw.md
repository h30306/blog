---
title: "LeetCode 412: Fizz Buzz"
summary: "LeetCode 412 解題筆記：先判斷 15 的倍數，再判斷 5 和 3；倍數要用 %，不是 //"
description: "2022-08-23 的 LeetCode 412 解題紀錄"
date: 2022-08-23
tags: ["easy", "math", "string", "simulation"]
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
- 提交紀錄：Wrong Answer ×4 → Accepted

## 解題思路

從 `1` 到 `n` 逐一判斷：`i % 15 == 0` 要**先**判斷（不然會先被 3 或 5 攔走），接著 `% 3`、`% 5`，都不是就放 `str(i)`。

## 我的嘗試

前四次都 WA：

- 第一版用 `//` 判斷倍數（`i // 15 == 0` 是「小於 15」），迴圈也只跑 `range(3)`。
- 接下來幾版把開頭寫死成 `["1", "2"]` 再從 3 開始，`//` 沒改之前全部都變成 `FizzBuzz`；改成 `%` 之後，**`n = 1` 時還是回傳兩個元素**。拿掉寫死的開頭才 AC。

## 正確解法

```python
class Solution:
    def fizzBuzz(self, n: int) -> List[str]:
        res = []
        for i in range(1, n + 1):
            if i % 15 == 0:
                res.append("FizzBuzz")
            elif i % 3 == 0:
                res.append("Fizz")
            elif i % 5 == 0:
                res.append("Buzz")
            else:
                res.append(str(i))
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 判斷倍數用 `%`。
- 範圍是 `1..n`，不要寫死開頭的元素。
- 數字要轉成字串。

## 面試口說整理

我從 1 到 n 逐一判斷，先看是不是 15 的倍數，再看 3 和 5，都不是就放數字的字串。時間 `O(n)`。
