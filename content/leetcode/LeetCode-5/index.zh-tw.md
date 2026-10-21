---
title: "LeetCode 5: Longest Palindromic Substring"
summary: "LeetCode 5 解題筆記：中心擴展，每個位置當奇數和偶數長度的中心往外擴；區間 DP 的話 i 要從大到小"
description: "2022-10-20 的 LeetCode 5 解題紀錄"
date: 2022-10-20
tags: ["medium", "two-pointers", "string", "dynamic-programming", "manacher"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-20
- 提交紀錄：Accepted ×3 → Runtime Error → Accepted ×2 → Wrong Answer → Runtime Error → Wrong Answer → Accepted ×4 → Wrong Answer → Accepted

## 解題思路

中心擴展：回文以某個中心對稱，中心可以是一個字元（奇數長度）或兩個字元之間（偶數長度），共 `2n - 1` 個。每個中心往外擴到不對稱為止，記錄最長的，`O(n²)` 時間、`O(1)` 空間。

區間 DP（[Interval DP]({{< relref "/algorithm/Interval-DP" >}})）：`dp[i][j] = s[i] == s[j] and dp[i + 1][j - 1]`，因為依賴 `i + 1`，**`i` 要從大到小算**。

## 我的嘗試

這題 2022 年和 2026 年都寫過：

- 2022-11-15 重寫中心擴展時，第一版 helper 回傳的是**長度**，最後也回傳長度；改成回傳子字串之後，又把 `res = longest`（整數）寫成了答案，應該是 `res = length`（子字串）。
- 2026-08 練區間 DP，有一版外層 `i` 從小到大，**`dp[i + 1][j - 1]` 還沒算**就被拿來用，結果錯了；改回 `i` 從大到小就 AC 了。

## 正確解法

```python
class Solution:
    def longestPalindrome(self, s: str) -> str:
        def expand(l, r):
            while l >= 0 and r < len(s) and s[l] == s[r]:
                l, r = l - 1, r + 1
            return l + 1, r
        best = (0, 1)
        for i in range(len(s)):
            for l, r in (expand(i, i), expand(i, i + 1)):
                if r - l > best[1] - best[0]:
                    best = (l, r)
        return s[best[0]:best[1]]
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 偶數長度的中心也要試。
- 回傳子字串，不是長度。
- 區間 DP 依賴 `dp[i + 1][j - 1]`，`i` 要倒著算。

## 面試口說整理

我用中心擴展，每個字元和每兩個字元之間都當成中心往外擴，記錄最長的回文。時間 `O(n²)`、空間 `O(1)`。如果用區間 DP，dp[i][j] 依賴 dp[i + 1][j - 1]，i 要從後往前算。
