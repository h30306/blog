---
title: "LeetCode 1449: Form Largest Integer With Digits That Add Up To Target"
summary: "LeetCode 1449 解題筆記，依照原始 learning note 重新整理"
description: "2026-08-19 的 LeetCode 1449 學習紀錄，包含筆記修正點與正確解法"
date: 2026-08-19
tags: ["hard", "dynamic-programming", "knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-19
來源：Day 46 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- explain `LC 1449` as unbounded cost DP plus greedy reconstruction

## 當天筆記摘錄

#### Problem 2 - LC 1449 Form Largest Integer With Digits That Add Up To Target
- **Pattern:** unbounded knapsack optimization plus greedy reconstruction.

#### Why This Fits
Each digit `1..9` has:
- a cost
- unlimited reuse

The objective is not just:
```text
can I hit target?
```

It is:
```text
form the numerically largest integer whose total cost is target
```

That means:
1. maximize digit count first
2. among equal-length answers, reconstruct the lexicographically largest digit sequence

#### Core State / Invariant
```text
dp[t] = maximum number of digits we can build with total cost t
```

Use a very negative sentinel for unreachable states.

#### Base Case
```text
dp[0] = 0
```

Reason:
```text
cost 0 can form a number with 0 digits
```

#### Transition
For a digit with cost `c`:
```text
dp[t] = max(dp[t], dp[t - c] + 1)
```

Iterate target cost forward because digit reuse is allowed.

#### Reconstruction
After DP, rebuild from digit `9` down to `1`.

Greedy rule:
```text
take digit d if its cost fits and dp[remaining] == dp[remaining - cost[d]] + 1
```

This preserves max length while making the leftmost digits as large as possible.

#### Complexity
```text
Time: O(9 * target)
Space: O(target)
```

#### Common Mistakes
- solving only feasibility and forgetting reconstruction
- optimizing digit value directly instead of digit count first
- using backward loop and accidentally turning it into `0/1`
- not handling unreachable target cleanly

#### Strong Spoken Explanation
This is an unbounded knapsack on digit cost. I first use DP to maximize how many digits can be formed for each total cost, because any number with more digits is always numerically larger than a shorter valid number. So `dp[t]` stores the maximum digit count for cost `t`, with `dp[0] = 0` and unreachable states set to negative infinity. Since digits can be reused, the transition is unbounded: `dp[t] = max(dp[t], dp[t - cost] + 1)`. After I know the maximum digit count for the target, I reconstruct greedily from digit `9` down to `1`, taking a digit whenever it preserves the optimal count. That gives the lexicographically largest number among all max-length answers.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List, Optional

class Solution:
    def largestNumber(self, cost: List[int], target: int) -> str:
        dp: List[Optional[str]] = [None] * (target + 1)
        dp[0] = ''

        def better(a: str, b: Optional[str]) -> str:
            if b is None or len(a) > len(b) or (len(a) == len(b) and a > b):
                return a
            return b

        for t in range(1, target + 1):
            for digit in range(1, 10):
                c = cost[digit - 1]
                if t >= c and dp[t - c] is not None:
                    dp[t] = better(dp[t - c] + str(digit), dp[t])

        return dp[target] if dp[target] is not None else '0'
```

## 複雜度

Time O(9 * target * answer_length), Space O(target * answer_length).

## 要特別避免的錯誤

- Maximizing digit value before length; a longer number is always larger.
- Forgetting unreachable states.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
