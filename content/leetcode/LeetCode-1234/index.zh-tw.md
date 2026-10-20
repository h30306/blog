---
title: "LeetCode 1234: Replace the Substring for Balanced String"
summary: "LeetCode 1234 解題筆記：替換一段之後，視窗外的每個字元都不能超過 n / 4；用「求最短」的滑動視窗維護視窗外的數量"
description: "2026-01-18 的 LeetCode 1234 解題紀錄"
date: 2026-01-18
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
第一次嘗試：2026-01-18
- 提交紀錄：Accepted（一次通過）

## 解題思路

替換視窗裡的字元時，視窗**外面**的字元不能動。要讓整個字串平衡，視窗外的每種字元都必須 `<= n / 4`（多出來的才有辦法在視窗裡補成其他字元）。

反過來，只要視窗外每種都 `<= n / 4`，就一定能把視窗填成平衡的樣子。所以：

- 維護 `outside[c]` = 視窗外的數量。
- 用「求最短」的滑動視窗：右端加入（`outside` 減一），合法時更新答案，再試著縮左邊（`outside` 加一）。

一開始就平衡時答案是 0。

## 我的解法

```python
class Solution:
    def balancedString(self, s: str) -> int:
        n = len(s)
        target = n // 4
        outside = Counter(s)                       # 視窗外的數量
        if all(outside[c] <= target for c in "QWER"):
            return 0

        left = 0
        best = n
        for right, c in enumerate(s):
            outside[c] -= 1
            while left <= right and all(outside[ch] <= target for ch in "QWER"):
                best = min(best, right - left + 1)
                outside[s[left]] += 1
                left += 1
        return best
```

我原本的寫法是先算出每種字元多了幾個，視窗裡要包含這些多出來的字元，用 `meet_count` 記錄有幾種已經包含夠了。意思一樣，但「視窗外不能超過 `n / 4`」的寫法比較短。

## 複雜度

時間 `O(n)`（每次檢查 4 種字元），空間 `O(1)`。

## 要特別避免的錯誤

- 一開始就平衡時要回傳 0。
- 合法條件看的是視窗**外**，不是視窗內。

## 面試口說整理

替換一段時，視窗外的字元不能動，所以整個字串能變平衡，等價於視窗外每種字元都不超過 `n / 4`。我維護視窗外的數量，用求最短的滑動視窗，合法時更新答案再縮左邊。一開始就平衡就回傳 0。時間 `O(n)`。
