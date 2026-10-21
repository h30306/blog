---
title: "LeetCode 374: Guess Number Higher or Lower"
summary: "LeetCode 374 解題筆記：依 guess 的回傳值調整範圍；-1 代表猜太大，1 代表猜太小"
description: "2022-08-23 的 LeetCode 374 解題紀錄"
date: 2022-08-23
tags: ["easy", "binary-search", "interactive"]
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
- 提交紀錄：Accepted ×4

## 解題思路

標準的二分搜尋（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一），只是比較換成呼叫 `guess`：回傳 `-1` 代表我的數字比答案大，往左；`1` 代表比答案小，往右；`0` 就猜中了。

## 我的解法

```python
class Solution:
    def guessNumber(self, n: int) -> int:
        l, r = 1, n
        while True:
            mid = (l + r) // 2
            g = guess(mid)
            if g == 0:
                return mid
            if g < 0:
                r = mid - 1
            else:
                l = mid + 1
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `guess` 回傳的是「我猜的數字相對答案」的方向，`-1` 是猜太大。

## 面試口說整理

我在 1 到 `n` 之間二分，依照 `guess` 的回傳值決定往左還是往右，回傳 0 就是答案。時間 `O(log n)`。
