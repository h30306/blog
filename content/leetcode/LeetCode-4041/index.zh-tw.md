---
title: "LeetCode 4041: Minimum Operations to Form Subset Sum II"
summary: "LeetCode 4041 解題筆記：乘除可以任意順序，用 BFS 找每個數能變成的所有值（不超過 sum）和最少步數，再做跟 4040 一樣的分組 0/1 背包"
description: "2026-08-30 的 LeetCode 4041 解題紀錄"
date: 2026-08-30
tags: ["hard", "dynamic-programming", "knapsack", "breadth-first-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-30
- 提交紀錄：Accepted（一次通過）

## 解題思路

跟 [LeetCode 4040]({{< relref "/leetcode/LeetCode-4040" >}}) 一樣是分組 0/1 背包，差別是乘除可以**任意順序**。先除再乘可以得到新的值，例如 `5 → 2 → 4`，只乘或只除都到不了 4。

所以每個數的選項改用 **BFS** 找：從 `x` 出發，每一步乘 2 或除 2，記錄每個值的最少步數。

- 乘 2 超過 `sum` 就不用走了：之後再除回來，不會比不乘更好（`2v // 2 = v`，只是多花兩步）。
- 除 2 會到 0，0 對子集和沒有幫助，但放進選項也不影響答案。

## 我的解法

```python
from collections import deque

class Solution:
    def minOperations(self, nums: List[int], sum: int) -> int:
        INF = float("inf")
        dp = [0] + [INF] * sum
        for x in nums:
            dist = {x: 0}                          # BFS：x 能變成的值 -> 最少步數
            queue = deque([x])
            while queue:
                v = queue.popleft()
                for nv, ok in ((v * 2, v * 2 <= sum), (v // 2, True)):
                    if ok and nv not in dist:           # 乘 2 不能超過 sum；除 2 一定可以
                        dist[nv] = dist[v] + 1
                        queue.append(nv)

            for s in range(sum, -1, -1):           # 分組 0/1 背包
                if dp[s] == INF:
                    continue
                for v, cost in dist.items():
                    if 0 < v and s + v <= sum:
                        dp[s + v] = min(dp[s + v], dp[s] + cost)
        return dp[sum] if dp[sum] < INF else -1
```

起始的 `x` 本身可能大於 `sum`，它在 `dist` 裡，但 `s + v <= sum` 會擋掉；它除下來的值還是可以用。

## 複雜度

每個數能變成的值大約是 `O(log^2 sum)` 個，時間 `O(n · sum · log^2 sum)`，空間 `O(sum)`。我 AC 的版本跑了 14 秒，這題的時限很寬。

## 要特別避免的錯誤

- 只考慮只乘或只除：順序任意時，先除再乘可以得到新的值。
- BFS 時乘 2 超過 `sum` 的值不用繼續走，但**除 2 不能加這個限制**：起始值可能比 `sum` 大，要先除下來。

## 面試口說整理

這題跟 4040 一樣是分組 0/1 背包，差別在於乘除可以任意順序，先除再乘會得到新的值。所以每個數的選項我用 BFS 找：每一步乘 2 或除 2，超過 `sum` 就不走，記錄每個值的最少步數。之後一樣容量倒著走，每個數最多選一個選項。
