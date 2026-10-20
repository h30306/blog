---
title: "LeetCode 2024: Maximize the Confusion of an Exam"
summary: "LeetCode 2024 解題筆記：視窗合法的條件是 T 和 F 比較少的那個 <= k（把少的全部改掉）；不合法就縮左邊"
description: "2026-01-10 的 LeetCode 2024 解題紀錄"
date: 2026-01-10
tags: ["medium", "sliding-window", "string", "binary-search", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

一段連續的答案要變成全部相同，最少要改的數量是 **T 和 F 裡比較少的那個**。所以視窗合法 ⇔ `min(T 的數量, F 的數量) <= k`。

視窗變大時少的那個只會變多或不變，條件單調，用「求最長」的滑動視窗：不合法就縮左邊。

## 我的解法

```python
class Solution:
    def maxConsecutiveAnswers(self, answerKey: str, k: int) -> int:
        cnt = Counter()
        left = best = 0
        for right, c in enumerate(answerKey):
            cnt[c] += 1
            while min(cnt["T"], cnt["F"]) > k:     # 兩種都超過 k 才不合法
                cnt[answerKey[left]] -= 1
                left += 1
            best = max(best, right - left + 1)
        return best
```

我原本的寫法只數 `T`，條件寫成 `count_true > k and (長度 - count_true) > k`，意思一樣。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 分別對「全變 T」和「全變 F」跑兩次也可以，但只用一個視窗、看少的那個就夠了。

## 面試口說整理

一段要全部改成一樣，最少要改的是 T 和 F 裡比較少的那個，所以視窗合法的條件是少的那個 `<= k`。這個條件隨視窗變大而單調，我用滑動視窗，不合法就縮左邊，記錄最長長度。時間 `O(n)`。
