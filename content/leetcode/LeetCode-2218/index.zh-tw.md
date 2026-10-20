---
title: "LeetCode 2218: Maximum Value of K Coins From Piles"
summary: "LeetCode 2218 解題筆記：每一堆只能從上面拿，拿 x 個的價值是前綴和；分組背包，dp[j] = 前幾堆總共拿 j 個的最大價值，每一堆枚舉拿幾個"
description: "2026-09-14 的 LeetCode 2218 解題紀錄"
date: 2026-09-14
tags: ["hard", "dynamic-programming", "knapsack", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-14
- 提交紀錄：Accepted ×5（二維 → 一維，逐步優化）

## 解題思路

每一堆只能從上面拿，所以從一堆拿 `x` 個，一定是**最上面的 `x` 個**，價值是這堆的前綴和 `prefix[x]`。

每一堆就是一組，選項是「拿 `0..len(pile)` 個」，這是**分組背包**：

```text
dp_i[j] = max over x of dp_{i-1}[j - x] + prefix_i[x]
```

`dp[j]` = 前 `i` 堆總共拿 `j` 個的最大價值。初始 `dp[0] = 0`、其他是負無限大（還沒辦法剛好拿 `j` 個）。

## 我的解法

```python
class Solution:
    def maxValueOfCoins(self, piles: List[List[int]], k: int) -> int:
        NEG = float("-inf")
        dp = [0] + [NEG] * k                       # dp[j]：目前為止總共拿 j 個
        for pile in piles:
            prefix = [0]
            for v in pile[:k]:                     # 一堆最多拿 k 個
                prefix.append(prefix[-1] + v)
            ndp = [NEG] * (k + 1)
            for j in range(k + 1):
                for x, val in enumerate(prefix):   # 這堆拿 x 個
                    if x > j:
                        break
                    ndp[j] = max(ndp[j], dp[j - x] + val)
            dp = ndp
        return dp[k]
```

我從二維 `dp[i][j]` 開始，逐步改成一維、每一堆再算前綴和；用新的 `ndp` 是為了避免同一堆被用兩次（也可以 `j` 倒著走、原地更新）。

## 複雜度

時間 `O(k · Σ min(len(pile), k))`，空間 `O(k)`。

## 要特別避免的錯誤

- 以為可以從任意位置拿：只能拿最上面的，所以價值是前綴和。
- 同一堆的選項互斥：要用新的陣列，或容量倒著走。

## 面試口說整理

每一堆只能從上面拿，拿 `x` 個的價值是這堆的前綴和，所以每一堆是一組、選項是拿幾個，這是分組背包。`dp[j]` 是目前為止總共拿 `j` 個的最大價值，每一堆枚舉拿幾個更新到新的陣列。時間 `O(k · 總硬幣數)`。
