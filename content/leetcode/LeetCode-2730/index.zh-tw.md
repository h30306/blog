---
title: "LeetCode 2730: Find the Longest Semi-Repetitive Substring"
summary: "LeetCode 2730 解題筆記：視窗裡最多一組相鄰相同的數字；新的一組進來就縮左邊，直到移出前一組"
description: "2026-01-11 的 LeetCode 2730 解題紀錄"
date: 2026-01-11
tags: ["medium", "sliding-window", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

視窗合法 ⇔ 視窗裡最多一組相鄰相同的數字（`s[i] == s[i + 1]`）。

- 右邊界加入 `s[right]` 時，如果 `s[right] == s[right - 1]`，相鄰相同的組數 +1。
- 超過 1 組就縮左邊。左邊界移出 `s[left]` 時，如果 `s[left] == s[left + 1]`，那一組也跟著離開，組數 -1。

## 我的解法

```python
class Solution:
    def longestSemiRepetitiveSubstring(self, s: str) -> int:
        left = pairs = best = 0
        for right in range(len(s)):
            if right > 0 and s[right] == s[right - 1]:
                pairs += 1
            while pairs > 1:
                if s[left] == s[left + 1]:
                    pairs -= 1                     # 這一組離開視窗
                left += 1
            best = max(best, right - left + 1)
        return best
```

`pairs > 1` 時視窗裡至少有兩組，`left + 1 <= right`，所以 `s[left + 1]` 不會越界。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 移出左邊時，要看的是 `s[left]` 和 `s[left + 1]` 這一組，不是 `s[left - 1]`。

## 面試口說整理

視窗裡最多一組相鄰相同的數字。右邊加入時跟前一個字元相同就加一組，超過一組就縮左邊，左邊移出時如果它跟下一個相同，那一組就離開了。記錄最長長度，時間 `O(n)`。
