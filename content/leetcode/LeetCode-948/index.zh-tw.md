---
title: "LeetCode 948: Bag of Tokens"
summary: "LeetCode 948 解題筆記：排序後，用最小的 token 換分數、用最大的 token 換能量；只有分數 > 0 才能換能量，換不了就停"
description: "2026-01-24 的 LeetCode 948 解題紀錄"
date: 2026-01-24
tags: ["medium", "two-pointers", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-24
- 提交紀錄：Wrong Answer → Time Limit Exceeded → Accepted

## 解題思路

每個 token 只能用一次，翻正面是「花能量換 1 分」，翻背面是「花 1 分換能量」。貪心：

- 換分數時，用**最便宜**的 token（左端）。
- 換能量時，用**最貴**的 token（右端）。

排序後用對撞指針：

1. 能量夠買左端：買下，分數 +1，更新最高分。
2. 不夠但分數 `> 0`：賣掉右端，換回能量。
3. 兩個都不行：停止。

答案是過程中的**最高分**，因為最後一步可能是賣掉 token 讓分數下降。

## 我的嘗試

1. **第一版 WA**：沒檢查分數就翻背面，分數可以變成負的。例如 `tokens = [1, 3, 9]`、`power = 0`：一個都買不起，答案是 0；這版先用負分換到 9 點能量，再買 1 和 3，回傳 1。
2. **第二版 TLE**：加上 `score > 0` 的條件，但兩個條件都不成立時沒有 `break`，指針不動，無窮迴圈。例如 `tokens = [4, 7, 9]`、`power = 1`。

## 正確解法

```python
class Solution:
    def bagOfTokensScore(self, tokens: List[int], power: int) -> int:
        tokens.sort()
        left, right = 0, len(tokens) - 1
        score = best = 0
        while left <= right:
            if power >= tokens[left]:
                power -= tokens[left]
                left += 1
                score += 1
                best = max(best, score)
            elif score > 0:
                power += tokens[right]
                right -= 1
                score -= 1
            else:
                break
        return best
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 分數是 0 時翻背面。
- 兩個動作都做不了時忘記 `break`。
- 回傳最後的分數而不是最高分。

## 面試口說整理

我把 token 排序，用最便宜的換分數、最貴的換能量。能量夠就買左端，不夠但有分數就賣右端，兩個都不行就停。最後可能是賣掉 token 讓分數下降，所以要記錄過程中的最高分。時間 `O(n log n)`。
