---
title: "LeetCode 313: Super Ugly Number"
summary: "LeetCode 313 解題筆記：LC 264 的推廣，每個質數一個指針；用 heap 的話要避免同一個數被推進去很多次"
description: "2022-11-16 的 LeetCode 313 解題紀錄"
date: 2022-11-16
tags: ["medium", "array", "math", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-16
- 提交紀錄：Wrong Answer ×2 → Output Limit Exceeded → Accepted → Wrong Answer → Accepted → Output Limit Exceeded → Wrong Answer → Output Limit Exceeded → Wrong Answer

## 解題思路

跟 LC 264 一樣，每個質數 `p` 有一個指針 `idx[p]`，下一個數是所有 `u[idx[p]] * p` 的最小值，等於它的指針都前進，`O(nk)`。

用 heap 的寫法要處理重複：例如 `6` 會從 `2 × 3` 和 `3 × 2` 各被推一次。一個技巧是彈出 `x` 之後只乘上**不超過 `x` 最小質因數**的質數（遇到 `x % p == 0` 就停），這樣每個數只會被它「最小質因數 × 剩下的部分」產生一次（[Heap]({{< relref "/algorithm/Heap" >}})）。

## 我的嘗試

這題用 heap 寫，錯了 8 次，都跟重複有關：

- 2022-11-16：彈出 `p` 後把它乘上每個質數推進去，只在 `p == prime` 時停，**這只有在 `p` 本身是質數時才會停**，像 6 這種合數還是會產生重複，同一個數被彈出兩次，答案往前錯位。
- 2022-11-26：有幾版拿掉了停止條件，重複更多；把條件改成 `p % prime == 0`（乘到 `p` 的最小質因數就停）才 AC。中間還有三次是 `print` 造成的 Output Limit Exceeded。

## 正確解法

```python
class Solution:
    def nthSuperUglyNumber(self, n: int, primes: List[int]) -> int:
        u = [1]
        idx = [0] * len(primes)
        while len(u) < n:
            nxt = min(u[idx[k]] * p for k, p in enumerate(primes))
            u.append(nxt)
            for k, p in enumerate(primes):
                if u[idx[k]] * p == nxt:
                    idx[k] += 1
        return u[-1]
```

## 複雜度

時間 `O(nk)`（`k` 是質數個數），空間 `O(n + k)`。

## 要特別避免的錯誤

- heap 的寫法沒有去重時，同一個數會被彈出很多次。
- 去重的停止條件是 `x % p == 0`（`p` 是 `x` 的最小質因數），不是 `x == p`。

## 面試口說整理

這是 LC 264 的推廣，我讓每個質數有一個指針，指向下一個要乘的醜數，每次取所有乘積的最小值，等於它的指針都前進。時間 `O(nk)`。用 heap 也可以，但要避免同一個數被推進去很多次。
