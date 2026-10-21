---
title: "LeetCode 204: Count Primes"
summary: "LeetCode 204 解題筆記：埃氏篩，只用質數 p 從 p² 開始把倍數劃掉，外層只要到 √n"
description: "2022-11-11 的 LeetCode 204 解題紀錄"
date: 2022-11-11
tags: ["medium", "array", "math", "enumeration", "number-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-11
- 提交紀錄：Output Limit Exceeded → Time Limit Exceeded ×4 → Runtime Error ×2 → Accepted → Wrong Answer → Accepted ×2

## 解題思路

埃氏篩（[Number Theory]({{< relref "/algorithm/Number-Theory" >}}) 模板三）：`is_prime` 初始都是 `True`，從 2 開始，**只有還是質數的 `p`** 才去劃掉倍數，而且從 `p²` 開始（更小的倍數已經被更小的質因數劃過了）；`p` 只要跑到 `√n`。Python 用切片賦值 `is_prime[p*p::p] = ...` 比內層迴圈快很多。

## 我的嘗試

這題提交了 11 次：

- 2022-11-11 第一版留了 `print`（Output Limit Exceeded）。之後幾版雖然有篩，但條件寫成 `if num:`，**每個數都會去劃倍數**，不管它是不是質數，外層也跑到 `n`，TLE 了四次。
- 2022-11-17 改成外層到 `√n`、用切片賦值，先是變數打錯（NameError）、`n < 2` 時 `prime[1]` 超出範圍（IndexError），補上特例就 AC 了。
- 2026 年重寫成線性篩，第一次把條件寫成 `if is_composite[i]`，**意思剛好相反**，一個質數都沒加進去：`n = 3` 回傳 0，答案 1。

## 正確解法

```python
class Solution:
    def countPrimes(self, n: int) -> int:
        if n < 3:
            return 0
        is_prime = [True] * n
        is_prime[0] = is_prime[1] = False
        for p in range(2, int(n ** 0.5) + 1):
            if is_prime[p]:
                is_prime[p * p::p] = [False] * len(range(p * p, n, p))
        return sum(is_prime)
```

## 複雜度

時間 `O(n log log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只用質數去篩：合數的倍數早就被它的質因數劃掉了。
- 外層到 `√n` 就夠。
- `n < 2` 時陣列太短，`is_prime[1]` 會超出範圍。
- 線性篩的條件是「**不是**合數就加入質數表」，寫反了一個質數都找不到。

## 面試口說整理

我用埃氏篩，從 2 到根號 n，遇到還是質數的 p 就從 p 平方開始把它的倍數劃掉，最後數還剩幾個 True。時間 `O(n log log n)`。
