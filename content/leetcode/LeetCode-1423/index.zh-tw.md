---
title: "LeetCode 1423: Maximum Points You Can Obtain from Cards"
summary: "LeetCode 1423 解題筆記：從兩端拿 k 張，等於中間留下連續 n - k 張；用固定長度視窗找留下來的最小和"
description: "2025-12-24 的 LeetCode 1423 解題紀錄"
date: 2025-12-24
tags: ["medium", "sliding-window", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-12-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

每次只能從頭或尾拿，拿 `k` 張之後，**留下來的一定是中間連續的 `n - k` 張**。

所以「拿到的最大和」= 總和 −「長度 `n - k` 的連續子陣列的最小和」，用固定長度的滑動視窗就能找。

## 我的解法

```python
class Solution:
    def maxScore(self, cardPoints: List[int], k: int) -> int:
        n = len(cardPoints)
        size = n - k                               # 留下來的張數
        window = sum(cardPoints[:size])
        smallest = window
        for right in range(size, n):
            window += cardPoints[right] - cardPoints[right - size]
            smallest = min(smallest, window)
        return sum(cardPoints) - smallest
```

`k == n` 時 `size = 0`，視窗一直是 0，答案是總和。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用貪心每次拿兩端比較大的那張：前面的選擇會影響後面能拿到什麼，不一定最好。

## 面試口說整理

從兩端拿 `k` 張，留下來的是中間連續的 `n - k` 張。所以我改找長度 `n - k` 的連續子陣列最小和，用固定長度的滑動視窗，答案是總和減掉它。時間 `O(n)`。
