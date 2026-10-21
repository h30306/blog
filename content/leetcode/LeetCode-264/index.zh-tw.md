---
title: "LeetCode 264: Ugly Number II"
summary: "LeetCode 264 解題筆記：三個指針分別指向下一個要乘 2、3、5 的醜數，每次取最小的，相等的指針都要前進"
description: "2022-11-14 的 LeetCode 264 解題紀錄"
date: 2022-11-14
tags: ["medium", "hash-table", "math", "dynamic-programming", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-14
- 提交紀錄：Time Limit Exceeded ×3 → Accepted ×3

## 解題思路

每個醜數都是某個更小的醜數乘上 2、3 或 5。維護三個指針 `i2`、`i3`、`i5`，下一個醜數是 `min(u[i2] * 2, u[i3] * 3, u[i5] * 5)`，然後**所有**等於這個值的指針都要前進，避免重複（例如 6 = 2 × 3 = 3 × 2）（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 模板一）。

## 我的嘗試

前三版從 1 開始逐一檢查每個整數是不是醜數（第二版還加了 `seen` 集合），但第 `n` 個醜數可能很大，**一個一個檢查太慢**，TLE 了三次。改成三指針才 AC。

## 正確解法

```python
class Solution:
    def nthUglyNumber(self, n: int) -> int:
        u = [1]
        i2 = i3 = i5 = 0
        while len(u) < n:
            nxt = min(u[i2] * 2, u[i3] * 3, u[i5] * 5)
            u.append(nxt)
            if nxt == u[i2] * 2: i2 += 1
            if nxt == u[i3] * 3: i3 += 1
            if nxt == u[i5] * 5: i5 += 1
        return u[-1]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 三個 `if` 要分開寫，不能用 `elif`：相同的值要讓所有對應的指針都前進。
- 從 1 開始逐一檢查是不是醜數會 TLE，第 1690 個醜數超過 20 億。

## 面試口說整理

每個醜數都是更小的醜數乘上 2、3 或 5，我用三個指針指向下一個要乘的醜數，每次取三個乘積的最小值，等於它的指針都往前，避免重複。時間 `O(n)`。
