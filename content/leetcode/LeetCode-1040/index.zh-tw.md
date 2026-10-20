---
title: "LeetCode 1040: Moving Stones Until Consecutive II"
summary: "LeetCode 1040 解題筆記：最多步數 = 總空位 − 第一步會浪費掉的那一邊空隙；最少步數用長度 n 的視窗找最多石頭，n - 1 顆已連續、剩一顆在遠處時要特判成 2"
description: "2026-01-18 的 LeetCode 1040 解題紀錄"
date: 2026-01-18
tags: ["medium", "sliding-window", "math", "sorting", "array"]
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

先排序。每次只能移動端點石頭，而且移完它不能還是端點。

### 最多步數

最後石頭會連在一起，所以理想上每一步只填一個空位。第一步必須移動最左或最右的那顆：

- 移最左邊的：`stones[0]` 和 `stones[1]` 之間的空位就再也用不到了。
- 移最右邊的：同理，浪費 `stones[-1]` 和 `stones[-2]` 之間的空位。

之後每一步都可以只往內填一格。所以最多步數 = `總空位 − min(左邊空隙, 右邊空隙)`，總空位是 `(stones[-1] - stones[0] + 1) - n`。

### 最少步數

最後石頭佔一段長度 `n` 的連續位置。用滑動視窗找**哪一段長度 `n` 的區間裡已經有最多石頭**，其他的都要搬進來，`n - count` 步。

特例：如果視窗裡有 `n - 1` 顆石頭而且**已經連續**（剛好佔滿長度 `n - 1`），剩下一顆在遠處，例如 `[1, 2, 3, 4, 10]`。直接把 10 搬到 5 是不行的（搬過去還是端點），要 2 步：先搬 1 到 6，再搬 10 到 5。

## 我的解法

```python
class Solution:
    def numMovesStonesII(self, stones: List[int]) -> List[int]:
        stones.sort()
        n = len(stones)

        total_gap = (stones[-1] - stones[0] + 1) - n
        max_moves = total_gap - min(stones[1] - stones[0] - 1, stones[-1] - stones[-2] - 1)

        min_moves = n
        left = 0
        for right in range(n):
            while stones[right] - stones[left] + 1 > n:
                left += 1                          # 視窗寬度不超過 n
            count = right - left + 1
            if count == n - 1 and stones[right] - stones[left] + 1 == n - 1:
                min_moves = min(min_moves, 2)      # n - 1 顆已連續，剩一顆在遠處
            else:
                min_moves = min(min_moves, n - count)
        return [min_moves, max_moves]
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 最多步數沒扣掉第一步浪費的空隙。
- 最少步數漏掉「`n - 1` 顆已連續」的特例。

## 面試口說整理

最多步數：第一步一定要移最左或最右的石頭，它旁邊的空隙就浪費了，之後每步只填一格，所以是總空位減掉比較小的那個邊緣空隙。最少步數：用長度 `n` 的滑動視窗找已經有最多石頭的區間，剩下的都要搬進來；但如果 `n - 1` 顆已經連續、剩一顆在遠處，要特判成 2 步。時間 `O(n log n)`。
