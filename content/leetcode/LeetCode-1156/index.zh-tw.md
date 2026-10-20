---
title: "LeetCode 1156: Swap For Longest Repeated Character Substring"
summary: "LeetCode 1156 解題筆記：對每個字元 c 找「最多一個不是 c」的最長視窗，換進來的 c 必須來自別處，所以長度不能超過 c 的總數"
description: "2026-01-23 的 LeetCode 1156 解題紀錄"
date: 2026-01-23
tags: ["medium", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

最多交換一次，最後的連續段是某個字元 `c`。對每個 `c` 分別處理：

- 找**最多只有一個字元不是 `c`** 的最長視窗，那個字元可以跟別處的 `c` 交換。
- 但換進來的 `c` 必須來自視窗外。如果所有的 `c` 都已經在視窗裡，就沒有 `c` 可以換進來，只能把視窗邊上的 `c` 移到中間，長度是 `c` 的總數。
- 所以這個 `c` 的答案是 `min(視窗長度, total[c])`。

最多 26 種字元，每種一次 `O(n)` 的滑動視窗。

## 我的解法

```python
class Solution:
    def maxRepOpt1(self, text: str) -> int:
        total = Counter(text)
        best = 0
        for c in total:
            left = other = 0
            for right, ch in enumerate(text):
                other += ch != c
                while other > 1:                   # 最多一個不是 c
                    other -= text[left] != c
                    left += 1
                best = max(best, min(right - left + 1, total[c]))
        return best
```

## 複雜度

時間 `O(26 · n)`，空間 `O(26)`。

## 要特別避免的錯誤

- 忘了長度上限是 `c` 的總數：例如 `"aaabaaa"` 只有 6 個 `a`，答案是 6 不是 7。

## 面試口說整理

最後的連續段是某個字元 `c`，所以我對每個字元找最多一個不是 `c` 的最長視窗，那一個可以跟別處的 `c` 交換。但換進來的 `c` 要來自別處，所以長度不能超過 `c` 的總數，取兩者的較小值。26 個字元各一次滑動視窗，`O(26n)`。
