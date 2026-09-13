---
title: "LeetCode 746: Min Cost Climbing Stairs"
summary: "LeetCode 746 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-25 的 LeetCode 746 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-25
tags: ["easy", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-25
來源：Day 10 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 3. Re-solve `LC 746 Min Cost Climbing Stairs` cleanly.

## 當天筆記摘錄

#### Problem 2 - LC 746 Min Cost Climbing Stairs
- **Status:** Good enough.
- **Pattern:** Fibonacci-style minimum-cost DP.

#### State
```text
dp[i] = minimum cost to reach step i
```

#### Base Case
```text
dp[0] = cost[0]
dp[1] = cost[1]
```

#### Transition
```text
dp[i] = cost[i] + min(dp[i - 1], dp[i - 2])
```

#### Final Answer
The top is one step beyond the last index, so:
```text
answer = min(dp[n - 1], dp[n - 2])
```

#### Complexity
```text
Time: O(n)
Space: O(n)
```

#### Interview-Ready Explanation
I can start from step 0 or step 1. To reach step `i`, I must come from `i - 1` or `i - 2`, so the minimum cost to reach `i` is the current step cost plus the cheaper of those two previous states. Since the top is beyond the last step, the answer is the cheaper of reaching the last or second-last step.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def minCostClimbingStairs(self, cost: List[int]) -> int:
        prev2 = prev1 = 0
        for i in range(2, len(cost) + 1):
            curr = min(prev1 + cost[i - 1], prev2 + cost[i - 2])
            prev2, prev1 = prev1, curr
        return prev1
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Paying cost for the top floor, which has no cost.
- Off-by-one between stair index and step position.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
