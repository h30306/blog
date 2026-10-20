---
title: "LeetCode 1304: Find N Unique Integers Sum up to Zero"
summary: "LeetCode 1304 解題筆記：放 1..n/2 和它們的相反數，兩兩抵銷；n 是奇數時再加一個 0"
description: "2025-07-21 的 LeetCode 1304 解題紀錄"
date: 2025-07-21
tags: ["easy", "math", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-07-21
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

成對放 `i` 和 `-i`（`i = 1..n/2`），每一對和是 0，而且都不重複。`n` 是奇數時再放一個 `0`。

## 我的嘗試

1. 第一版用 `range(-n//2, n//2 + 1)`，**偶數時多了一個數**（包含 0）。例如 `n = 2`：回傳 `[-1, 0, 1]`，三個數。
2. 第二版偶數時把上界少 1，變成 `[-1, 0]`，和不是 0。
3. 改成先產生 `-n//2..n//2`，偶數時把中間的 0 拿掉，就 AC 了。

## 正確解法

```python
class Solution:
    def sumZero(self, n: int) -> List[int]:
        res = []
        for i in range(1, n // 2 + 1):
            res += [i, -i]                         # 兩兩抵銷
        if n % 2:
            res.append(0)
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 偶數個時不能有 0（不然就多一個數，或要拿掉別的數）。

## 面試口說整理

我成對放 `i` 和 `-i`，每一對的和是 0，放 `n / 2` 對；`n` 是奇數時再補一個 0。時間 `O(n)`。
