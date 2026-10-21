---
title: "LeetCode 367: Valid Perfect Square"
summary: "LeetCode 367 解題筆記：在 [1, num] 上二分找 mid² == num，不用 sqrt"
description: "2022-08-23 的 LeetCode 367 解題紀錄"
date: 2022-08-23
tags: ["easy", "math", "binary-search"]
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
- 提交紀錄：Accepted ×2

## 解題思路

題目不能用內建的開根號。`mid²` 隨 `mid` 遞增，在 `[1, num]` 上二分（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板四）：等於就是完全平方數，太小往右、太大往左。

## 我的嘗試

兩次都 AC 了；11 月那一版找不到時其實沒有寫回傳值（回傳 `None`），只是 LeetCode 把 `None` 當成 `False`。

## 正確解法

```python
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        l, r = 1, num
        while l <= r:
            mid = (l + r) // 2
            sq = mid * mid
            if sq == num:
                return True
            if sq < num:
                l = mid + 1
            else:
                r = mid - 1
        return False
```

## 複雜度

時間 `O(log num)`，空間 `O(1)`。

## 要特別避免的錯誤

- 找不到時要回傳 `False`，不是什麼都不回傳（`None`）。

## 面試口說整理

平方隨數字遞增，所以我在 1 到 `num` 之間二分，平方剛好等於 `num` 就是完全平方數。時間 `O(log num)`。
