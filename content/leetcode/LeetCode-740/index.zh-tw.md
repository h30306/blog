---
title: "LeetCode 740: Delete and Earn"
summary: "LeetCode 740 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-25 的 LeetCode 740 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-25
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-25
來源：Day 11 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 740 Delete and Earn
- **Status:** Completed.
- **Pattern:** Value bucketing -> House Robber.
- **Key insight:** The conflict is between values `x`, `x - 1`, and `x + 1`, not between original array positions.

#### Why House Robber
If I take value `x`, I cannot take `x - 1` or `x + 1`.

That is the same shape as:
```text
take current bucket -> skip adjacent bucket
skip current bucket -> keep previous answer
```

So first convert:
```text
points[x] = x * frequency(x)
```

Then solve House Robber on the `points` array.

#### State
```text
dp[i] = maximum points we can earn using values from 0 to i
```

#### Base Case
```text
dp[0] = 0
dp[1] = points[1]
```

#### Transition
```text
dp[i] = max(dp[i - 1], dp[i - 2] + points[i])
```

#### Complexity
```text
Time: O(n + m)
Space: O(m)
```

Where:
```text
n = len(nums)
m = max(nums)
```

#### Interview-Ready Explanation
I group equal values first, because taking a value deletes only its neighboring values, not neighboring positions in the original array. I build `points[x]` as the total points from taking all `x`s. After that, the problem becomes House Robber on values: if I take `x`, I cannot take `x - 1`, so the transition is `max(skip current, take current)`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def deleteAndEarn(self, nums: List[int]) -> int:
        if not nums:
            return 0
        max_val = max(nums)
        points = [0] * (max_val + 1)
        for x in nums:
            points[x] += x

        prev2 = prev1 = 0
        for gain in points:
            prev2, prev1 = prev1, max(prev1, prev2 + gain)
        return prev1
```

## 複雜度

Time O(max(nums)+n), Space O(max(nums)).

## 要特別避免的錯誤

- Thinking adjacency means array index adjacency instead of numeric value adjacency.
- Not aggregating duplicate values first.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
