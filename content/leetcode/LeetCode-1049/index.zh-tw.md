---
title: "LeetCode 1049: Last Stone Weight II"
summary: "LeetCode 1049 解題筆記，依照原始 learning note 重新整理"
description: "2026-08-19 的 LeetCode 1049 學習紀錄，包含筆記修正點與正確解法"
date: 2026-08-19
tags: ["medium", "dynamic-programming", "knapsack", "subset-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-19
來源：Day 45 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- explain `LC 1049` as a partition problem, not a simulation problem

## 當天筆記摘錄

#### Problem 2 - LC 1049 Last Stone Weight II
- **Pattern:** `0/1` subset partition with best-half approximation.

#### Why This Fits
If the stones are partitioned into two groups with sums:
```text
A and B
```

then the final remaining weight is:
```text
|A - B|
```

So the real goal is:
```text
find a reachable subset sum as close as possible to total / 2
```

#### Core State / Invariant
```text
dp[s] = whether some subset of processed stones can make sum s
```

#### Base Case
```text
dp[0] = true
```

Reason:
```text
choosing no stones makes sum 0
```

#### Transition
For each stone, iterate backward:
```text
dp[s] |= dp[s - stone]
```

#### Final Answer
Find the largest reachable:
```text
s <= total // 2
```

Then return:
```text
total - 2 * s
```

#### Complexity
```text
Time: O(len(stones) * target)
Space: O(target)
```

#### Common Mistakes
- treating smash operations as simulation instead of partitioning
- using forward iteration and reusing one stone
- thinking maximize-value DP is required
- forgetting the final scan for best reachable half

#### Strong Spoken Explanation
I reframe the smash process as partitioning stones into two groups. If the group sums are `A` and `B`, the final leftover is `|A - B|`, so I want the two sums as close as possible. That means I only need subset sums up to `total // 2`. I use boolean `0/1` DP where `dp[s]` tells me whether sum `s` is reachable from the processed stones. After filling the table, I scan downward from `total // 2` for the largest reachable `s` and return `total - 2 * s`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def lastStoneWeightII(self, stones: List[int]) -> int:
        total = sum(stones)
        target = total // 2
        dp = [False] * (target + 1)
        dp[0] = True

        for stone in stones:
            for s in range(target, stone - 1, -1):
                dp[s] = dp[s] or dp[s - stone]

        for s in range(target, -1, -1):
            if dp[s]:
                return total - 2 * s
        return 0
```

## 複雜度

Time O(n * total_sum), Space O(total_sum).

## 要特別避免的錯誤

- Iterating forward accidentally reuses the same stone more than once.
- Optimizing for exact half only; the best answer may be below half.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
