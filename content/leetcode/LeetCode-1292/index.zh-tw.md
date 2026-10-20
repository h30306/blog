---
title: "LeetCode 1292: Maximum Side Length of a Square with Sum Less than or Equal to Threshold"
summary: "LeetCode 1292 解題筆記：二維前綴和加上對邊長二分；兩種二分寫法不能混用"
description: "2026-08-30 的 LeetCode 1292 解題紀錄"
date: 2026-08-30
tags: ["medium", "binary-search", "prefix-sum", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-30
- 提交紀錄：Accepted → Wrong Answer（改了迴圈條件）

## 解題思路

1. **二維前綴和**：`P[i][j]` 是左上角 `(0, 0)` 到 `(i-1, j-1)` 的總和，任何正方形的和都能 `O(1)` 算出來。
2. **對邊長二分**：矩陣的值都非負，邊長 `L` 的正方形可行時，它裡面任何邊長 `L - 1` 的正方形和也不會更大，所以 `L - 1` 也可行。條件是單調的。

`check(L)` 掃過所有右下角，看有沒有任何邊長 `L` 的正方形和 `<= threshold`，`O(mn)`。

## 我的嘗試：改了迴圈條件，沒改更新方式

第一次用左閉右閉的寫法 AC：

```python
while left <= right:
    ...
    if valid:
        left = mid + 1
    else:
        right = mid - 1
```

之後想改成 `while left < right`，但更新方式還是 `right = mid - 1`。左閉右開的寫法要搭配 `hi = mid`，混在一起就會漏掉答案，WA。

## 正確解法

用「找最大的可行值」的寫法：找第一個**不可行**的邊長，再減 1。

```python
class Solution:
    def maxSideLength(self, mat: List[List[int]], threshold: int) -> int:
        m, n = len(mat), len(mat[0])
        P = [[0] * (n + 1) for _ in range(m + 1)]
        for i in range(m):
            for j in range(n):
                P[i + 1][j + 1] = P[i][j + 1] + P[i + 1][j] - P[i][j] + mat[i][j]

        def ok(L: int) -> bool:
            for i in range(L, m + 1):
                for j in range(L, n + 1):
                    if P[i][j] - P[i - L][j] - P[i][j - L] + P[i - L][j - L] <= threshold:
                        return True
            return False

        lo, hi = 1, min(m, n) + 1          # 找第一個不可行的邊長
        while lo < hi:
            mid = (lo + hi) // 2
            if ok(mid):
                lo = mid + 1
            else:
                hi = mid
        return lo - 1
```

`ok` 找到一個可行的正方形就馬上回傳，不用掃完。

## 複雜度

時間 `O(mn log(min(m, n)))`，空間 `O(mn)`。

## 要特別避免的錯誤

- 兩種二分寫法混用：只改迴圈條件，沒改更新方式。
- 二維前綴和的加減寫錯：`P[i][j] - P[i-L][j] - P[i][j-L] + P[i-L][j-L]`，最後一項要加回來。
- 忘記答案可能是 0：連邊長 1 都不可行時要回傳 0。

## 面試口說整理

我先建二維前綴和，讓任何正方形的和都能 `O(1)` 算出。因為值都非負，邊長 `L` 可行時更小的邊長也可行，所以對邊長二分；`check` 掃過所有右下角，找到一個和不超過門檻的正方形就回傳。我用「找第一個不可行的邊長再減 1」的寫法，時間 `O(mn log(min(m, n)))`。
