---
title: "LeetCode 3518: Smallest Palindromic Rearrangement II"
summary: "LeetCode 3518 解題筆記：回文由左半邊決定，變成「多重集合的第 k 個排列」；逐位試每個字元，用排列數判斷第 k 個落在哪個分支，排列數可以 O(1) 更新"
description: "2025-04-13 的 LeetCode 3518 解題紀錄"
date: 2025-04-13
tags: ["hard", "math", "combinatorics", "counting", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2025-04-13
- 提交紀錄：WA → TLE ×2（2025-04）→ WA → TLE → RE → TLE → AC → RE → AC（2026-09-26）

## 解題思路

`s` 本身是回文，所以每個字元的數量除了最多一個以外都是偶數。回文由**左半邊**決定（右半邊是鏡像，中間是出現奇數次的那個字元），題目變成：**左半邊這個多重集合的第 `k` 個排列**。

逐位決定：

- 剩下的排列數 = `剩下長度! / Π 每個字元剩下的數量!`。
- 這一位試字元 `c`（由小到大）：放 `c` 之後的排列數是 `目前排列數 × cnt[c] / 剩下長度`。
  - `k` 落在這個分支裡（`k <= 這個數`）：放 `c`，往下一位。
  - 否則 `k` 減掉這個數，試下一個字元。
- 一開始總排列數 `< k` 就回傳空字串。

## 我的嘗試

| 時間 | 版本 | 問題 |
|---|---|---|
| 2025-04 | WA | 只算了一次 next permutation，沒用到 `k`。例如 `s = "cc"`、`k = 6`：只有一種回文排列，答案是空字串，回傳 `"cc"` |
| 2025-04 | 兩次 TLE | 改成跑 `k - 1` 次 next permutation，`k` 到 `10^6` 太慢 |
| 2026-09 | WA | 改成逐位決定，但中間字元只看「數量 `< 2` 的字元」，**出現 3 次的字元**沒被當成中間字元。例如 `s = "ccc"`、`k = 1`：答案是 `"ccc"`，回傳 `"cc"` |
| 2026-09 | TLE ×2 | 每試一個字元都重新算一次 `factorial` 的大數除法 |
| 2026-09 | RE ×2 | 函式名稱改成了 `kthSmallestPalindrome`，LeetCode 找不到 `smallestPalindrome` |
| 2026-09 | AC | 排列數改成 `O(1)` 更新：`branch = current × cnt[c] // length` |

## 正確解法

```python
from math import factorial

class Solution:
    def smallestPalindrome(self, s: str, k: int) -> str:
        cnt = [0] * 26
        for ch in s:
            cnt[ord(ch) - 97] += 1
        mid = ""
        for i in range(26):
            if cnt[i] % 2:
                mid = chr(i + 97)                  # 出現奇數次的那個（包含 3、5 次）
            cnt[i] //= 2                           # 左半邊的數量

        length = sum(cnt)
        ways = factorial(length)
        for c in cnt:
            ways //= factorial(c)
        if ways < k:
            return ""

        left = []
        for _ in range(length):
            for i in range(26):
                if cnt[i] == 0:
                    continue
                branch = ways * cnt[i] // length   # 這一位放 i 之後的排列數
                if k <= branch:
                    left.append(chr(i + 97))
                    cnt[i] -= 1
                    ways, length = branch, length - 1
                    break
                k -= branch
        half = "".join(left)
        return half + mid + half[::-1]
```

## 複雜度

時間 `O(26 · n)` 次大整數運算（加上一開始算階乘），空間 `O(n)`。也可以在計算排列數時把超過 `k` 的值截斷成 `k`，避免大整數。

## 要特別避免的錯誤

- 中間字元是出現**奇數次**的字元，不是出現 1 次的。
- 一個一個列舉排列：`k` 很大時太慢。
- 每次都重算階乘：用比例 `cnt[c] / length` 更新就好。

## 面試口說整理

回文由左半邊決定，所以題目變成左半邊多重集合的第 `k` 個排列。我逐位決定：試每個字元，放下去之後剩下的排列數是目前排列數乘 `cnt[c]` 除以剩下長度，`k` 在這個範圍內就放它，否則扣掉再試下一個。中間字元是出現奇數次的那個。時間 `O(26n)`。
