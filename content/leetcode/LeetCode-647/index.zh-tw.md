---
title: "LeetCode 647: Palindromic Substrings"
summary: "LeetCode 647 解題筆記：中心擴展，每擴展成功一次就是一個回文子字串"
description: "2022-11-01 的 LeetCode 647 解題紀錄"
date: 2022-11-01
tags: ["medium", "two-pointers", "string", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-01
- 提交紀錄：Accepted（一次通過）
- 2026-11-02 重寫：Accepted

## 解題思路

跟 LC 5 一樣用中心擴展，`2n - 1` 個中心（字元和字元之間），往外擴的每一步只要兩端相同，就多了一個回文子字串。

## 我的嘗試

一次 AC，跟 LC 5 一樣用奇數、偶數兩個中心各擴展一次。

## 正確解法

```python
class Solution:
    def countSubstrings(self, s: str) -> int:
        count = 0
        for center in range(2 * len(s) - 1):
            l, r = center // 2, center // 2 + center % 2
            while l >= 0 and r < len(s) and s[l] == s[r]:
                count += 1
                l, r = l - 1, r + 1
        return count
```

## 2026-11 重寫

2026-11-02 改用區間 DP，一次 AC（[Interval DP]({{< relref "/algorithm/Interval-DP" >}})）：`dp[i][j]` 表示 `s[i..j]` 是不是回文。`s[i] == s[j]`，而且裡面那段 `dp[i+1][j-1]` 也是回文，`s[i..j]` 就是回文；長度 2 以內只要兩端相同就是。`dp[i][j]` 會用到 `i + 1`，所以 `i` 要由大到小跑。

跟上面的中心擴展比，時間一樣是 `O(n^2)`，但 DP 要 `O(n^2)` 空間，中心擴展只要 `O(1)`。面試時先講中心擴展。

另外外層寫成 `range(n, -1, -1)`，從 `n` 開始多跑了一輪。那一輪的內層迴圈是空的，所以沒出錯，但應該從 `n - 1` 開始。

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 奇數和偶數長度的中心都要算。

## 面試口說整理

我用中心擴展，每個字元和每兩個字元之間都當成中心，往外擴的每一步兩端相同就多一個回文子字串。時間 `O(n²)`、空間 `O(1)`。
