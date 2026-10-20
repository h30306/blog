---
title: "LeetCode 3622: Check Divisibility by Digit Sum and Product"
summary: "LeetCode 3622 解題筆記：算出位數和與位數積，判斷 n % (和 + 積) == 0；取模的方向不要寫反"
description: "2025-07-20 的 LeetCode 3622 解題紀錄"
date: 2025-07-20
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
第一次嘗試：2025-07-20
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

`n` 要能被「位數和 + 位數積」整除，也就是 `n % (sum + product) == 0`。位數和至少是 1，所以除數不會是 0。

## 我的嘗試

第一版寫成 `(product + sum) % n == 0`，方向反了。例如 `n = 2`：和是 2、積是 2，`2 % 4 = 2`，答案是 `False`；這版算 `4 % 2 = 0`，回傳 `True`。

## 正確解法

```python
from math import prod

class Solution:
    def checkDivisibility(self, n: int) -> bool:
        digits = [int(c) for c in str(n)]
        return n % (sum(digits) + prod(digits)) == 0
```

## 複雜度

時間 `O(d)`，空間 `O(d)`。

## 要特別避免的錯誤

- 「`n` 被 `x` 整除」是 `n % x == 0`，不是 `x % n == 0`。

## 面試口說整理

我把 `n` 拆成位數，算和與積，檢查 `n` 除以兩者相加的餘數是不是 0。時間 `O(d)`。
