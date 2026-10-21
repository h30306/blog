---
title: "LeetCode 762: Prime Number of Set Bits in Binary Representation"
summary: "LeetCode 762 解題筆記：數字最多 10^6 < 2^20，1 的個數最多 19，直接比對小質數集合"
description: "2022-09-06 的 LeetCode 762 解題紀錄"
date: 2022-09-06
tags: ["easy", "math", "bit-manipulation", "primality-test"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-06
- 提交紀錄：Accepted（一次通過）

## 解題思路

`right <= 10^6 < 2^20`，所以 1 的個數最多 19，質數只有 `2, 3, 5, 7, 11, 13, 17, 19`。逐一數 1 的個數（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})），看在不在這個集合裡。

## 我的解法

```python
class Solution:
    def countPrimeSetBits(self, left: int, right: int) -> int:
        primes = {2, 3, 5, 7, 11, 13, 17, 19}
        return sum(bin(x).count("1") in primes for x in range(left, right + 1))
```

## 複雜度

時間 `O((right - left) · log right)`，空間 `O(1)`。

## 要特別避免的錯誤

- 1 不是質數。

## 面試口說整理

範圍內的數最多 20 位元，1 的個數最多 19，所以我把 19 以內的質數放進集合，逐一數 1 的個數檢查。時間是範圍長度乘上位元數。
