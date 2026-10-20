---
title: "LeetCode 3918: Sum of Primes Between Number and Its Reverse"
summary: "LeetCode 3918 解題筆記：把 n 反轉，範圍是 [min, max]，逐一試除判斷質數加總；判斷整除要用 %，不要比較 // 和 /"
description: "2026-05-03 的 LeetCode 3918 解題紀錄"
date: 2026-05-03
tags: ["medium", "math", "number-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-03
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

`r` 是 `n` 反轉後的數，範圍是 `[min(n, r), max(n, r)]`。範圍不大，逐一用試除法判斷質數，加總即可。（範圍更大時可以用埃氏篩一次算好。）

## 我的嘗試

第一版判斷質數時：

- 用 `n // i == n / i` 判斷整除，這要靠浮點數，而且
- 試除的範圍是 `range(2, ceil(√n) + 1)`，**`n = 2` 時會試到 `i = 2`**，`2 // 2 == 2 / 2`，2 被判成合數。

例如 `n = 2`：反轉還是 2，答案是 2，這版回傳 0。改成先處理 2、只試奇數、用 `%` 判斷就 AC 了。

## 正確解法

```python
from math import isqrt

class Solution:
    def sumOfPrimesInRange(self, n: int) -> int:
        def is_prime(x: int) -> bool:
            if x < 2:
                return False
            if x % 2 == 0:
                return x == 2
            for d in range(3, isqrt(x) + 1, 2):
                if x % d == 0:
                    return False
            return True

        r = int(str(n)[::-1])
        return sum(x for x in range(min(n, r), max(n, r) + 1) if is_prime(x))
```

## 複雜度

時間 `O(R √R)`，`R` 是範圍的上界；空間 `O(1)`。

## 要特別避免的錯誤

- 用浮點除法判斷整除。
- 試除的上界用 `ceil(√n)`，小的數會試到自己。用 `isqrt` 而且只試到 `√x`。

## 面試口說整理

把 `n` 反轉後得到範圍，逐一用試除法判斷質數再加總。試除只要到 `√x`、用 `%` 判斷整除，2 要先特判。範圍更大的話可以改用篩法。
