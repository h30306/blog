---
title: "LeetCode 69: Sqrt(x)"
summary: "LeetCode 69 解題筆記：找最大的 mid 讓 mid² <= x；閉區間二分結束時 r 就是答案"
description: "2022-05-12 的 LeetCode 69 解題紀錄"
date: 2022-05-12
tags: ["easy", "math", "binary-search", "newtons-method"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-05-12
- 提交紀錄：Wrong Answer → Accepted → Wrong Answer → Accepted

## 解題思路

要找最大的 `k` 使 `k² <= x`（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板四）。閉區間 `[0, x]` 二分：`mid² <= x` 就往右找更大的，否則往左。迴圈結束時 `r` 停在最後一個滿足的位置。

## 我的嘗試

2022 年 5 月第一版用了 `/`，`mid` 是浮點數，例如 `x = 5` 回傳 1.5；改成 `//` 就 AC 了。8 月重寫時一版的結果多了 1，例如 `x = 5` 回傳 3。

## 正確解法

```python
class Solution:
    def mySqrt(self, x: int) -> int:
        l, r = 0, x
        while l <= r:
            mid = (l + r) // 2
            if mid * mid <= x:
                l = mid + 1
            else:
                r = mid - 1
        return r
```

## 複雜度

時間 `O(log x)`，空間 `O(1)`。

## 要特別避免的錯誤

- `mid` 要用整數除法。
- 答案是無條件捨去，要回傳最後一個 `mid² <= x` 的值。

## 面試口說整理

我在 0 到 `x` 之間二分，平方不超過 `x` 就往右找，超過就往左；結束時右界就是最大的平方不超過 `x` 的整數。時間 `O(log x)`。
