---
title: "LeetCode 2761: Prime Pairs With Target Sum"
summary: "LeetCode 2761 解題筆記：篩出 < n 的質數，x 從小到大、只看到 n / 2，x 和 n - x 都是質數就是一對"
description: "2026-10-12 的 LeetCode 2761 解題紀錄"
date: 2026-10-12
tags: ["medium", "math", "number-theory", "sieve", "enumeration", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-12
- 提交紀錄：Accepted（一次通過）

## 解題思路

1. 篩出 `< n` 的所有質數（`n` 到 `10^6`，篩法比逐一試除快）。
2. `x` 從 2 到 `n / 2`：`x` 和 `n - x` 都是質數，`[x, n - x]` 就是一對。`x <= n - x`，結果自然依 `x` 遞增排序。

## 我的解法

我 AC 的版本是線性篩之後，在質數列表上用對撞指針找和是 `n` 的配對（跟 Two Sum II 一樣），跑了 5.7 秒。直接查 `is_prime[n - x]` 更簡單：

```python
from math import isqrt

class Solution:
    def findPrimePairs(self, n: int) -> List[List[int]]:
        if n < 4:
            return []
        is_prime = [False, False] + [True] * (n - 1)
        for i in range(2, isqrt(n) + 1):
            if is_prime[i]:
                for j in range(i * i, n + 1, i):
                    is_prime[j] = False
        return [[x, n - x] for x in range(2, n // 2 + 1) if is_prime[x] and is_prime[n - x]]
```

## 複雜度

時間 `O(n log log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `x` 只要到 `n / 2`，不然同一對會出現兩次。
- `[5, 5]` 這種兩個一樣的也算。

## 面試口說整理

我用埃氏篩找出 `n` 以內的質數，再讓 `x` 從 2 走到 `n / 2`，`x` 和 `n - x` 都是質數就加進答案，順序自然是遞增的。時間 `O(n log log n)`。
