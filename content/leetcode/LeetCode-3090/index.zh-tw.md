---
title: "LeetCode 3090: Maximum Length Substring With Two Occurrences"
summary: "LeetCode 3090 解題筆記：「求最長」的滑動視窗，剛加進來的字元超過 2 次就縮左邊"
description: "2026-01-10 的 LeetCode 3090 解題紀錄"
date: 2026-01-10
tags: ["easy", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

視窗合法 ⇔ 每個字元最多出現 2 次。右邊界每加入一個字元，**只有這個字元可能超過**，所以縮左邊直到它回到 2 次。

[LeetCode 2958]({{< relref "/leetcode/LeetCode-2958" >}}) 是同一題，把 2 換成 `k`。

## 我的解法

```python
class Solution:
    def maximumLengthSubstring(self, s: str) -> int:
        cnt = Counter()
        left = best = 0
        for right, c in enumerate(s):
            cnt[c] += 1
            while cnt[c] > 2:                      # 只有剛加入的 c 可能超過
                cnt[s[left]] -= 1
                left += 1
            best = max(best, right - left + 1)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（最多 26 個字元）。

## 要特別避免的錯誤

- 每次都檢查整個計數表：只有剛加入的字元可能違規。

## 面試口說整理

用求最長的滑動視窗，每個字元最多出現兩次。右邊加入一個字元後，只有它可能超過兩次，所以縮左邊直到它回到兩次，記錄最長長度。時間 `O(n)`。
