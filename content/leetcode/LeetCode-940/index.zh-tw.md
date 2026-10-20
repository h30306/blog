---
title: "LeetCode 940: Distinct Subsequences II"
summary: "LeetCode 940 解題筆記：依最後一個字元分類；以 c 結尾的不同子序列 = 目前所有不同子序列後面接 c，再加上 c 本身，直接覆蓋舊的值"
description: "2026-09-12 的 LeetCode 940 解題紀錄"
date: 2026-09-12
tags: ["hard", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-12
- 提交紀錄：Accepted（一次通過）

## 解題思路

如果直接用「每個字元選或不選」，相同的子序列會被算很多次（`"aa"` 選第一個 `a` 或第二個 `a` 都是 `"a"`）。

**依最後一個字元分類**：`end[c]` = 以 `c` 結尾的不同子序列數。讀到新的字元 `c` 時：

- 目前所有不同的子序列（`sum(end.values())` 個），後面都可以接上 `c`，得到以 `c` 結尾的子序列。
- 再加上單獨的 `"c"`。

這些新算出來的子序列，**已經包含了所有舊的以 `c` 結尾的子序列**（舊的是接在更早的子序列後面，那些更早的子序列現在也還在），所以直接覆蓋 `end[c]`，不用加。

答案是 `sum(end.values())`。

## 我的解法

```python
class Solution:
    def distinctSubseqII(self, s: str) -> int:
        MOD = 10 ** 9 + 7
        end = {}                                   # 以每個字元結尾的不同子序列數
        for c in s:
            end[c] = (sum(end.values()) + 1) % MOD # 全部接上 c，再加上 "c" 本身
        return sum(end.values()) % MOD
```

## 複雜度

時間 `O(26 · n)`，空間 `O(26)`。

## 要特別避免的錯誤

- `end[c]` 要覆蓋，不是累加：累加會重複算舊的以 `c` 結尾的子序列。
- 題目要的是非空的子序列，不用加上空字串。

## 面試口說整理

我依最後一個字元把不同的子序列分類。讀到字元 `c` 時，目前所有不同的子序列後面接上 `c`，再加上 `c` 本身，就是以 `c` 結尾的所有不同子序列，而且已經包含舊的那些，所以直接覆蓋。最後把 26 個加起來。時間 `O(26n)`。
