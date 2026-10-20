---
title: "LeetCode 1320: Minimum Distance to Type a Word Using Two Fingers"
summary: "LeetCode 1320 解題筆記：打完 word[i] 時，一定有一根手指在 word[i] 上，狀態只要記另一根手指在哪；dp[other] 是另一根手指在 other 的最小距離"
description: "2026-08-25 的 LeetCode 1320 解題紀錄"
date: 2026-08-25
tags: ["hard", "dynamic-programming", "state-machine", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-25
- 提交紀錄：Accepted ×2（三維 DP → 一維 DP）

## 解題思路

鍵盤是 6 欄的格子，字母 `c` 的位置是 `(c // 6, c % 6)`，距離是曼哈頓距離。手指一開始可以放在任何地方，第一次移動不算距離，用一個特別的位置 `26` 代表「還沒用過」，從 26 出發的距離是 0。

最直接的狀態是 `dp[i][f1][f2]`（打完第 `i` 個字母，兩根手指的位置），`27 × 27 × n`。

**觀察**：打完 `word[i]` 時，一定有一根手指正在 `word[i]` 上。所以只要記**另一根手指**在哪：`dp[other]`。打 `word[i]` 時（上一個字母是 `prev = word[i - 1]`）：

- **用剛剛打 `prev` 的那根手指**：另一根手指不動，`dp'[other] = dp[other] + dist(prev, cur)`。
- **用另一根手指**：它從 `other` 移到 `cur`，原本在 `prev` 上的那根變成「另一根」，`dp'[prev] = dp[other] + dist(other, cur)`。

## 我的解法

```python
class Solution:
    def minimumDistance(self, word: str) -> int:
        def dist(a: int, b: int) -> int:
            if a == 26:
                return 0                           # 還沒用過的手指，第一次移動不算
            return abs(a // 6 - b // 6) + abs(a % 6 - b % 6)

        INF = float("inf")
        dp = [INF] * 27                            # dp[other]：另一根手指在 other
        dp[26] = 0
        for i in range(1, len(word)):
            prev, cur = ord(word[i - 1]) - 65, ord(word[i]) - 65
            ndp = [INF] * 27
            for other in range(27):
                if dp[other] == INF:
                    continue
                ndp[other] = min(ndp[other], dp[other] + dist(prev, cur))   # 同一根手指
                ndp[prev] = min(ndp[prev], dp[other] + dist(other, cur))    # 換另一根
            dp = ndp
        return min(dp)
```

我第一次 AC 是三維的 `dp[i][f1][f2]`，跑了 277ms；觀察到「一定有一根手指在上一個字母上」之後壓成一維，50ms。

## 複雜度

時間 `O(27 · n)`，空間 `O(27)`。

## 要特別避免的錯誤

- 手指的初始位置不算距離：用一個「還沒用過」的狀態處理。
- 換手指之後，原本打 `prev` 的那根變成「另一根」，狀態是 `prev`。

## 面試口說整理

打完一個字母時一定有一根手指在它上面，所以狀態只要記另一根手指的位置，用 26 代表還沒用過。打下一個字母時，可以用剛剛那根手指移過去，另一根不動；或用另一根移過去，這時剛剛那根變成另一根。兩種轉移取最小，時間 `O(27n)`。
