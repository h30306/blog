---
title: "LeetCode 377: Combination Sum IV"
summary: "LeetCode 377 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-03 的 LeetCode 377 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-03
tags: ["medium", "dynamic-programming", "unbounded-knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-03
來源：Day 18 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 2 - LC 377 Combination Sum IV
- **Status:** Good enough.
- **Pattern:** Unbounded counting DP for ordered sequences.

#### Why DP Fits
For each target sum `i`, we can pick any `num` as the last element of the sequence.

That means:
```text
number of sequences for i depends on number of sequences for i - num
```

It is unbounded because each number can be reused many times.

Important nuance:
```text
order matters
```

So:
```text
1 + 2 and 2 + 1 are different answers
```

#### State
```text
dp[i] = number of ordered sequences that sum to i
```

#### Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0: choose nothing
```

#### Transition
For each total `i` from `1` to `target`:
```text
for num in nums:
    if i >= num:
        dp[i] += dp[i - num]
```

#### Why Loop Order Matters
Use:
```text
outer loop on total, inner loop on nums
```

Why:
```text
for each target sum i, we try every num as the last element of the sequence
```

That counts permutations separately.

Example with `nums = [1, 2]`, `target = 3`:
- `[1, 1, 1]`
- `[1, 2]`
- `[2, 1]`

If you use coin-first loop order, you undercount by collapsing different permutations into one combination.

#### Complexity
```text
Time: O(target * len(nums))
Space: O(target)
```

#### Common Mistakes
- saying `dp[i]` is number of combinations instead of ordered sequences
- setting `dp[0] = 0` instead of `1`
- using coin-first loop order and counting combinations instead of permutations
- using min-count transition like `+ 1` instead of counting transition `+=`

#### Interview-Ready Explanation
This is an unbounded counting DP problem where order matters. I define `dp[i]` as the number of ordered sequences that sum to `i`. The base case is `dp[0] = 1`, because there is exactly one way to make sum `0`, which is choosing nothing. Then for each total `i` from `1` to `target`, I iterate through `nums`, and if `i >= num`, I do `dp[i] += dp[i - num]`. The important nuance is that looping total first and nums second counts permutations, so `[1, 2]` and `[2, 1]` are different answers. The time complexity is `O(target * len(nums))` and the space complexity is `O(target)`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def combinationSum4(self, nums: List[int], target: int) -> int:
        dp = [0] * (target + 1)
        dp[0] = 1

        for t in range(1, target + 1):
            for num in nums:
                if num <= t:
                    dp[t] += dp[t - num]

        return dp[target]
```

## 複雜度

Time O(target * len(nums)), Space O(target).

## 要特別避免的錯誤

- Using coin outer loop, which counts combinations not permutations.
- Confusing this with LC 518.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
