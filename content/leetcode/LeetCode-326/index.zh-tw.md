---
title: "LeetCode 326: Power of Three"
summary: "LeetCode 326 解題筆記：一直除以 3 直到除不盡，剩 1 就是；不用迴圈的話，3^19 能被 n 整除就是"
description: "2022-08-23 的 LeetCode 326 解題紀錄"
date: 2022-08-23
tags: ["easy", "math", "recursion"]
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

`n <= 0` 一定不是。迴圈做法：只要 `n % 3 == 0` 就除以 3，最後剩 1 才是。進階要求不用迴圈：32 位元範圍內最大的 3 的次方是 `3^19 = 1162261467`，而 3 是質數，所以它的因數全部都是 3 的次方：`n > 0 and 3**19 % n == 0`（[Number Theory]({{< relref "/algorithm/Number-Theory" >}})）。

## 我的解法

```python
class Solution:
    def isPowerOfThree(self, n: int) -> bool:
        return n > 0 and 3**19 % n == 0
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- `0` 和負數要排除。
- 這個技巧只對質數的次方有效：底數是合數時（例如 4），最大次方的因數不一定是它的次方，`2` 整除 `4^15`，但 `2` 不是 4 的次方。

## 面試口說整理

3 是質數，32 位元內最大的 3 的次方是 3 的 19 次方，它的因數全部都是 3 的次方，所以我檢查 n 大於 0 而且能整除 3 的 19 次方。時間 `O(1)`。
