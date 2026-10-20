---
title: "LeetCode 3648: Minimum Sensors to Cover Grid"
summary: "LeetCode 3648 解題筆記：每個感測器蓋住 (2k + 1) × (2k + 1) 的正方形，兩個方向各自做無條件進位的除法再相乘"
description: "2025-08-16 的 LeetCode 3648 解題紀錄"
date: 2025-08-16
tags: ["medium", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-16
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

切比雪夫距離 `<= k` 的範圍是一個邊長 `2k + 1` 的正方形。兩個方向互相獨立：

- 列的方向需要 `ceil(n / (2k + 1))` 個。
- 行的方向需要 `ceil(m / (2k + 1))` 個。

答案是兩者相乘。

## 我的嘗試

第一版寫成 `n // (2k + 1) + 1`，**剛好整除時多了 1**。例如 `n = 9`、`m = 3`、`k = 0`：每個感測器只蓋自己，答案是 27，這版算出 `10 × 4 = 40`。改成判斷有沒有整除才加 1 就 AC 了。

## 正確解法

```python
class Solution:
    def minSensors(self, n: int, m: int, k: int) -> int:
        side = 2 * k + 1
        return -(-n // side) * -(-m // side)       # 無條件進位的除法
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 無條件進位寫成 `a // b + 1`：整除時多 1。用 `-(-a // b)` 或 `(a + b - 1) // b`。
- 用浮點數 `a / b == a // b` 判斷整除：大數時可能有誤差。

## 面試口說整理

每個感測器蓋一個邊長 `2k + 1` 的正方形，列和行的方向互相獨立，各自需要 `n` 和 `m` 除以邊長再無條件進位，兩個相乘就是答案。時間 `O(1)`。
