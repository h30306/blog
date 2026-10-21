---
title: "LeetCode 424: Longest Repeating Character Replacement"
summary: "LeetCode 424 解題筆記：可變長度滑動視窗，視窗長度減掉最多的字元次數就是要替換的數量，超過 k 就縮左邊"
description: "2022-10-28 的 LeetCode 424 解題紀錄"
date: 2022-10-28
tags: ["medium", "hash-table", "string", "sliding-window"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-28
- 提交紀錄：Accepted ×4 → Runtime Error → Accepted

## 解題思路

視窗裡要全部變成同一個字元，最省的做法是保留出現最多的那個，替換其他 `長度 - 最多次數` 個。右邊每次擴張一格，如果需要替換的數量超過 `k` 就把左邊縮一格（[Sliding Window]({{< relref "/algorithm/Sliding-Window" >}}) 模板二）。字母只有 26 個，每次取 `max(count.values())` 是 `O(26)`。

## 我的嘗試

2022 年就 AC 了，2026 年重寫時一次 RE：寫成 `max(count)`（拿到的是字元 key，跟整數比較 TypeError），縮左邊時也寫成 `count[i]`（index 而不是字元），兩個都改掉才 AC。

## 正確解法

```python
class Solution:
    def characterReplacement(self, s: str, k: int) -> int:
        count = defaultdict(int)
        res = l = 0
        for r, ch in enumerate(s):
            count[ch] += 1
            while (r - l + 1) - max(count.values()) > k:
                count[s[l]] -= 1
                l += 1
            res = max(res, r - l + 1)
        return res
```

## 複雜度

時間 `O(26n)`，空間 `O(26)`。

## 要特別避免的錯誤

- 縮左邊時要減的是 `count[s[l]]`（字元），不是 `count[l]`（index）。
- `max(count)` 取的是 key 的最大值，要取次數得用 `max(count.values())`。

## 面試口說整理

我用可變長度的滑動視窗，視窗長度減掉最多的字元次數就是需要替換的數量，超過 k 就縮左邊，過程中記錄最長的視窗。字母只有 26 個，時間 `O(26n)`。
