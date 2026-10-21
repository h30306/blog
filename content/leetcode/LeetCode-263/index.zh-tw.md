---
title: "LeetCode 263: Ugly Number"
summary: "LeetCode 263 解題筆記：正數才可能是 ugly number，把因數 2、3、5 全部除掉，剩下 1 就是"
description: "2022-08-23 的 LeetCode 263 解題紀錄"
date: 2022-08-23
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
第一次嘗試：2022-08-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

`n <= 0` 一定不是。否則把 2、3、5 一直除到除不盡，如果最後剩下 1，代表沒有其他質因數（[Number Theory]({{< relref "/algorithm/Number-Theory" >}})）。

## 我的解法

```python
class Solution:
    def isUgly(self, n: int) -> bool:
        if n <= 0:
            return False
        for p in (2, 3, 5):
            while n % p == 0:
                n //= p
        return n == 1
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `0` 和負數要先排除，`0 % p == 0` 會讓迴圈停不下來。

## 面試口說整理

我先排除非正數，再把 2、3、5 一直除到除不盡，剩下 1 就是 ugly number。時間 `O(log n)`。
