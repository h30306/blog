---
title: "LeetCode 507: Perfect Number"
summary: "LeetCode 507 解題筆記：因數成對出現，只要枚舉到 √n，每找到 d 就同時加上 d 和 n / d"
description: "2022-08-25 的 LeetCode 507 解題紀錄"
date: 2022-08-25
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
第一次嘗試：2022-08-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

因數 `d` 和 `n / d` 成對出現，枚舉 `d` 從 2 到 `√n`（[Number Theory]({{< relref "/algorithm/Number-Theory" >}}) 模板二的寫法）：整除時加上 `d`，`d != n / d` 時再加上 `n / d`。1 一定是因數但 `n` 本身不算，所以總和從 1 開始，而且 `n = 1` 要排除。

## 我的解法

```python
class Solution:
    def checkPerfectNumber(self, num: int) -> bool:
        if num == 1:
            return False
        total = 1
        d = 2
        while d * d <= num:
            if num % d == 0:
                total += d
                if d != num // d:
                    total += num // d
            d += 1
        return total == num
```

## 複雜度

時間 `O(√n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 不能算到 `n` 本身。
- 完全平方數的 `√n` 只能加一次。
- `n = 1` 的真因數和是 0。

## 面試口說整理

因數是成對的，我只枚舉到根號 n，每找到一個因數 d 就同時加上 d 和 n / d，平方根只加一次，總和從 1 開始、不含 n 本身，最後比較是否等於 n。時間 `O(√n)`。
