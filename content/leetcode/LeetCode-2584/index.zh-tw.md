---
title: "LeetCode 2584: Split the Array to Make Coprime Products"
summary: "LeetCode 2584 解題筆記：兩段乘積互質 ⇔ 沒有質因數同時出現在兩段；記下每個質因數最後出現的 index，從左往右擴張 reach，reach == i 時就能在 i 後面切"
description: "2026-10-13 的 LeetCode 2584 解題紀錄"
date: 2026-10-13
tags: ["hard", "math", "number-theory", "sieve", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-13
- 提交紀錄：AC → WA → AC ×2

## 解題思路

不能真的算乘積（會很大）。兩段乘積互質 ⇔ **沒有任何質因數同時出現在左右兩段**。

1. 用 SPF 篩法分解每個數，記下每個質因數**最後出現的 index** `last[p]`。
2. 從左往右掃，`reach` = 到目前為止看過的所有質因數，最後出現的位置最遠到哪。左段如果在 `i` 結束，右段不能再出現左段的質因數，所以要 `reach == i`。
3. 第一個 `reach == i`（`i <= n - 2`）的位置就是答案，沒有就回傳 -1。

這跟「劃分字母區間」（LC 763）是同一個想法：每個質因數是一個區間，要切在所有區間的外面。

## 我的嘗試

第一版 AC 之後重寫，把 `reach` 的初始值寫成 `-1`。如果第一個數是 1（沒有質因數），`reach` 一直是 -1，`reach == 0` 不成立，第一個位置就切不出來。例如 `[1, 1]`：在 0 後面切，`1` 和 `1` 互質，答案是 0，回傳 -1。

初始值改回 0 就 AC 了：左段至少包含 index 0，`reach` 最少就是 0。

## 正確解法

```python
class Solution:
    def findValidSplit(self, nums: List[int]) -> int:
        m = max(nums)
        spf = list(range(m + 1))
        for i in range(2, int(m ** 0.5) + 1):
            if spf[i] == i:
                for j in range(i * i, m + 1, i):
                    if spf[j] == j:
                        spf[j] = i

        def primes_of(x: int) -> List[int]:
            out = []
            while x > 1:
                p = spf[x]
                out.append(p)
                while x % p == 0:
                    x //= p
            return out

        last = {}
        for i, x in enumerate(nums):
            for p in primes_of(x):
                last[p] = i                        # 每個質因數最後出現的位置

        reach = 0                                  # 左段至少到 index 0
        for i in range(len(nums) - 1):
            for p in primes_of(nums[i]):
                reach = max(reach, last[p])
            if reach == i:
                return i
        return -1
```

## 複雜度

時間 `O(M log log M + n log M)`，空間 `O(M)`。

## 要特別避免的錯誤

- 直接算乘積：數字會非常大。
- `reach` 的初始值要是 0，不是 -1：`1` 沒有質因數。
- 最後一個位置不能切，`i` 只到 `n - 2`。

## 面試口說整理

乘積互質等於沒有質因數同時出現在兩段。我先用 SPF 篩法分解每個數，記下每個質因數最後出現的位置。從左往右掃，維護目前看過的質因數最遠延伸到哪；這個位置剛好等於 `i` 時，右邊不會再出現左邊的質因數，就能在 `i` 後面切。時間 `O(M log log M + n log M)`。
