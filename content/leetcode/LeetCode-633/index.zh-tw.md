---
title: "LeetCode 633: Sum of Square Numbers"
summary: "LeetCode 633 解題筆記：a 從 0、b 從 isqrt(c) 開始對撞；平方和太大 b 減一，太小 a 加一；注意 0 也算、a 可以等於 b、浮點數開根號的誤差"
description: "2026-01-25 的 LeetCode 633 解題紀錄"
date: 2026-01-25
tags: ["medium", "two-pointers", "math", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-25
- 提交紀錄：Wrong Answer ×3 → Accepted ×2

## 解題思路

找非負整數 `a`、`b` 使 `a^2 + b^2 = c`。

`a` 從 `0`、`b` 從 `⌊√c⌋` 開始對撞：

- `a^2 + b^2 > c`：`b` 太大，`b -= 1`。
- `a^2 + b^2 < c`：`a` 太小，`a += 1`。
- 相等：找到了。

為什麼不會漏：每次排除的是「目前的 `b` 跟所有 `>= a` 的數都太大」或「目前的 `a` 跟所有 `<= b` 的數都太小」，跟 Two Sum II 的對撞指針一樣。

## 我的嘗試

三次 WA 都是邊界：

| 版本 | 問題 |
|---|---|
| 第一版 | `a` 從 `1` 開始，漏掉 `0`。例如 `c = 4 = 0^2 + 2^2`、`c = 0`，都回傳 `False` |
| 第二版 | `a` 從 0 開始，但條件是 `a < b`，漏掉 `a == b`。例如 `c = 2 = 1^2 + 1^2`，回傳 `False`；而且 `b` 從 `c` 開始，要走 `O(c)` 步 |
| 第三版 | `b = c ** 0.5` 是浮點數，平方回去有誤差。例如 `c = 2`：`(√2)^2` 算出來是 `2.0000000000000004`，大於 2，之後都對不上，回傳 `False` |

改成 `int(c ** 0.5)` 就 AC 了。更穩的寫法是 `math.isqrt`，完全不經過浮點數。

## 正確解法

```python
from math import isqrt

class Solution:
    def judgeSquareSum(self, c: int) -> bool:
        a, b = 0, isqrt(c)
        while a <= b:
            s = a * a + b * b
            if s == c:
                return True
            if s < c:
                a += 1
            else:
                b -= 1
        return False
```

## 複雜度

時間 `O(√c)`，空間 `O(1)`。

## 要特別避免的錯誤

- 忘了 `0` 也是平方數。
- 條件寫成 `a < b`，漏掉 `a == b`。
- 用浮點數開根號後直接平方比較。

## 面試口說整理

我讓 `a` 從 0、`b` 從 `√c` 的整數部分開始對撞：平方和太大就讓 `b` 變小，太小就讓 `a` 變大，相等就找到。邊界要注意 0 也算、`a` 可以等於 `b`，開根號用 `isqrt` 避免浮點誤差。時間 `O(√c)`。
