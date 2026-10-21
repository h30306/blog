---
title: "LeetCode 342: Power of Four"
summary: "LeetCode 342 解題筆記：先確認是 2 的次方，再確認那個 1 在偶數位：n & 0x55555555 != 0，或 n % 3 == 1"
description: "2022-08-23 的 LeetCode 342 解題紀錄"
date: 2022-08-23
tags: ["easy", "math", "bit-manipulation", "recursion"]
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

4 的次方是 2 的次方，而且唯一的 1 在第 0、2、4… 位（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）。`0x55555555` 的二進位是 `0101...01`，剛好是所有偶數位，所以 `n & 0x55555555 != 0`。另一種判斷：`4^k = (3 + 1)^k ≡ 1 (mod 3)`，而 `2 × 4^k ≡ 2 (mod 3)`。

## 我的嘗試

一次 AC，當時就是 `n > 0 and n & (n - 1) == 0 and n % 3 == 1`，用的是 mod 3 的判斷。

## 正確解法

```python
class Solution:
    def isPowerOfFour(self, n: int) -> bool:
        return n > 0 and n & (n - 1) == 0 and n & 0x55555555 != 0
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只檢查 2 的次方不夠，`2`、`8` 不是 4 的次方。

## 面試口說整理

4 的次方一定是 2 的次方，而且那個 1 在偶數位，所以我先用 n & (n - 1) 檢查只有一個 1，再跟 0x55555555 做 AND 確認位置。時間 `O(1)`。
