---
title: "LeetCode 3932: Count K-th Roots in a Range"
summary: "LeetCode 3932 解題筆記：答案是 floor(r^(1/k)) - floor((l-1)^(1/k))，開根號用整數二分避免浮點誤差，0 也要算"
description: "2026-05-17 的 LeetCode 3932 解題紀錄"
date: 2026-05-17
tags: ["medium", "binary-search", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-17
- 提交紀錄：WA ×4 → AC（05-17）→ WA → TLE → AC → AC（05-18 重寫）

## 解題思路

`[l, r]` 裡的完全 k 次方數，就是「有幾個整數 `x` 滿足 `l <= x^k <= r`」。

設 `f(n)` = 最大的 `x` 使得 `x^k <= n`。那麼：

```text
答案 = f(r) - f(l - 1)
```

要注意 **`0 = 0^k` 也是完全 k 次方數**，所以 `x` 要從 0 開始算，而且 `f(-1) = -1`。

## 我的嘗試

### 第一版：用浮點數比較相等

```python
if i ** (1 / k) == int(i ** (1 / k)):
```

浮點數開根號有誤差，例如 Python 的 `64 ** (1/3)` 是 `3.9999999999999996`，跟 `int(...)` 比較會判斷成不是完全立方數。而且它在 `[l, r]` 裡逐一檢查，範圍到 `10^9` 一定太慢。

### 改成整數二分，但漏掉了 0

```python
if n == 0:
    return 0
low = 1
```

二分從 1 開始，`n == 0` 也回傳 0，等於把 `x = 0` 排除了。`l = 0` 時，0 這個完全 k 次方數就被漏掉。改成從 0 開始、`n < 0` 時回傳 `-1` 就 AC 了。

### 隔天重寫：枚舉底數

改成枚舉 `x` 從 0 到 `r^(1/k) + 1`，檢查 `l <= x^k <= r`。`k = 1` 時 `x` 要枚舉到 `10^9`，TLE，加了 `k == 1` 的特判才過。

最後一版只用浮點數估計 `x` 的範圍，再用整數修正兩端，也 AC 了。

## 正確解法

```python
class Solution:
    def countKthRoots(self, l: int, r: int, k: int) -> int:
        def floor_root(n: int) -> int:            # 最大的 x，使得 x ** k <= n
            lo, hi = 0, n + 1
            while lo < hi:
                mid = (lo + hi) // 2
                if mid ** k <= n:
                    lo = mid + 1
                else:
                    hi = mid
            return lo - 1                          # n < 0 時回傳 -1

        return floor_root(r) - floor_root(l - 1)
```

全程都是整數運算，`k = 1` 也不需要特判。

## 複雜度

時間 `O(k log r)`：二分 `log r` 次，每次算 `mid ** k`。空間 `O(1)`。

## 要特別避免的錯誤

- 用浮點數開根號再比較相等。
- 漏掉 `0`：`l = 0` 時，`0` 本身就是完全 k 次方數。
- 枚舉底數時沒考慮 `k = 1`：底數會多到 `10^9` 個。

## 面試口說整理

區間內的完全 k 次方數個數，等於 `f(r) - f(l - 1)`，`f(n)` 是滿足 `x^k <= n` 的最大整數 `x`。浮點數開根號有誤差，所以我用整數二分算 `f`，從 0 開始搜尋，這樣 0 也會被算進去，而且 `f(-1)` 自然是 `-1`。時間 `O(k log r)`。
