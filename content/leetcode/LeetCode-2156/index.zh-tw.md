---
title: "LeetCode 2156: Find Substring With Given Hash Value"
summary: "LeetCode 2156 解題筆記：雜湊的第一個字元乘 p^0，從右往左滑動時只要乘 p 再加新字元、扣掉 p^k 倍的出去字元，不需要除法；modulo 不一定是質數，不能用模反元素"
description: "2026-01-04 的 LeetCode 2156 解題紀錄"
date: 2026-01-04
tags: ["hard", "sliding-window", "rolling-hash", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-04
- 提交紀錄：TLE → Accepted → TLE → Accepted

## 解題思路

`hash(s) = Σ val(s[i]) · p^i mod m`，**第一個字元的權重是 `p^0`**。

如果從左往右滑，視窗往右移一格時，所有字元的權重都要**除以 `p`**。但 `m` 不一定是質數，`p` 在模 `m` 下不一定有反元素，沒辦法做除法。

反過來**從右往左滑**就只需要乘法：

```text
新的 hash = 舊的 hash · p + val(新的左端字元) − val(出去的右端字元) · p^k
```

`p^k mod m` 先用 `pow(p, k, m)` 算好。從右往左掃，最後一次（最左邊）符合的就是答案。

## 我的嘗試

1. **第一版 TLE**：從左往右滑，每次用 `power ** (right - left)` 算權重、移出時 `//= power`，沒有取模，數字越來越大。整數除法在沒取模時是對的，但大整數運算太慢。
2. **AC**：改成從右往左滑，`pk = pow(power, k, modulo)`。
3. **TLE**：重寫時把 `pk` 寫成每一步都算 `power ** k % modulo`，`power ** k` 是個巨大的整數。
4. **AC**：改回事先用 `pow` 取模算好。

## 正確解法

```python
class Solution:
    def subStrHash(self, s: str, power: int, modulo: int, k: int, hashValue: int) -> str:
        n = len(s)
        pk = pow(power, k, modulo)                 # 事先算好，不要每步重算
        h = 0
        ans = 0
        for left in range(n - 1, -1, -1):
            h = (h * power + ord(s[left]) - 96) % modulo
            if left + k < n:
                h = (h - (ord(s[left + k]) - 96) * pk) % modulo
            if left + k <= n and h == hashValue:
                ans = left                         # 越左邊越晚更新，最後留下第一個
        return s[ans:ans + k]
```

Python 的 `%` 對負數會回傳非負的結果，所以扣完不用另外加 `modulo`。

## 複雜度

時間 `O(n)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 從左往右滑需要除以 `p`，但 `modulo` 不一定是質數。
- 每一步都算 `power ** k`：大整數，TLE。
- 題目要的是**第一個**符合的子字串，從右往左掃時要一直更新到最左邊。

## 面試口說整理

這個雜湊的第一個字元權重是 `p^0`，從左往右滑需要除以 `p`，但模數不一定是質數，沒有反元素。所以我從右往左滑：舊的雜湊乘 `p` 加上新字元，再扣掉出去字元乘 `p^k`，`p^k` 事先取模算好。因為要第一個符合的，從右往左一路更新到最左邊。時間 `O(n)`。
