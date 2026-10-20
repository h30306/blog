---
title: "LeetCode 2269: Find the K-Beauty of a Number"
summary: "LeetCode 2269 解題筆記：把數字轉成字串，枚舉每個長度 k 的子字串；0 不能當除數"
description: "2026-01-04 的 LeetCode 2269 解題紀錄"
date: 2026-01-04
tags: ["easy", "sliding-window", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-04
- 提交紀錄：Runtime Error → Accepted

## 解題思路

把 `num` 轉成字串，每個長度 `k` 的子字串就是一個固定視窗。轉回整數後：

- 是 0 就跳過（0 不是任何數的因數，而且不能拿來除）。
- 否則看 `num % sub == 0`。

前導 0 是允許的，`int("04")` 就是 4。

## 我的嘗試

第一版最後寫成 `return len(res)`，但 `res` 是計數用的整數，`len()` 直接 TypeError。改成 `return res` 就 AC 了。

## 正確解法

```python
class Solution:
    def divisorSubstrings(self, num: int, k: int) -> int:
        s = str(num)
        count = 0
        for right in range(k - 1, len(s)):
            sub = int(s[right - k + 1:right + 1])
            if sub and num % sub == 0:             # 0 不是因數
                count += 1
        return count
```

`num` 最多 10 位，每次轉整數的成本可以忽略；如果要嚴格 `O(n)`，可以用 `sub = sub * 10 + 新位數 - 舊位數 * 10^k` 滾動更新。

## 複雜度

時間 `O(n · k)`，`n` 是位數，空間 `O(n)`。

## 要特別避免的錯誤

- 子字串是 0 時直接拿來除：ZeroDivisionError。
- 對整數呼叫 `len()`。

## 面試口說整理

我把數字轉成字串，枚舉每個長度 `k` 的子字串轉回整數，不是 0 而且能整除 `num` 就計數。位數最多 10，直接切字串就夠快，要更嚴格可以用滾動的方式更新子字串的值。
