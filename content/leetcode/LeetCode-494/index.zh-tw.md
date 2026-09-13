---
title: "LeetCode 494: Target Sum"
summary: "LeetCode 494 解題筆記，依照原始 learning note 重新整理"
description: "2026-08-23 的 LeetCode 494 學習紀錄，包含筆記修正點與正確解法"
date: 2026-08-23
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
第一次嘗試：2026-08-23
來源：Day 44 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 494`: pass after algebra repair
- say one clean difference between `LC 494`, `LC 518`, and `LC 1155`

## 當天筆記摘錄

#### Problem 1 - LC 494 Target Sum
- **Pattern:** `0/1` subset-sum counting after algebra reduction.

#### Why This Fits
Each number is used exactly once, but can land in either:
- the `+` set
- the `-` set

Let:
```text
P = sum of plus-assigned numbers
N = sum of minus-assigned numbers
```

Then:
```text
P - N = target
P + N = total
=> N = (total - target) / 2
```

So the real question is:
```text
how many subsets sum to (total - target) / 2?
```

#### Core State / Invariant
```text
dp[s] = number of ways to form sum s using the numbers processed so far
```

#### Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0 before using any numbers:
choose nothing
```

#### Transition
For each `num`, iterate sum backward:
```text
dp[s] += dp[s - num]
```

#### Why Backward
Backward iteration preserves the `0/1` rule:
```text
the current number must not be reused again in the same iteration
```

#### Immediate Zero Cases
```text
abs(target) > total
```

or:
```text
(total - target) is odd
```

#### Complexity
```text
Time: O(len(nums) * reduced_target)
Space: O(reduced_target)
```

#### Common Mistakes
- getting the algebra reduction sign wrong
- forgetting the `abs(target) > total` rejection
- saying `dp[s]` is only `possible or not` instead of `number of ways`
- iterating the sum forward and accidentally reusing one number multiple times

#### Strong Spoken Explanation
I convert the sign-assignment problem into subset-sum counting. If `P` is the plus set and `N` is the minus set, then `P - N = target` and `P + N = total`, so `N = (total - target) / 2`. That means I just need to count how many subsets sum to that reduced target. If the reduced target is negative or not an integer, the answer is `0`. Then I use `0/1` counting DP where `dp[s]` is the number of ways to form sum `s` using the numbers processed so far. I initialize `dp[0] = 1`, iterate each number once, and update sums backward with `dp[s] += dp[s - num]`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def findTargetSumWays(self, nums: List[int], target: int) -> int:
        total = sum(nums)
        if abs(target) > total or (total + target) % 2:
            return 0
        subset = (total + target) // 2
        dp = [0] * (subset + 1)
        dp[0] = 1

        for num in nums:
            for s in range(subset, num - 1, -1):
                dp[s] += dp[s - num]

        return dp[subset]
```

## 複雜度

Time O(n * subset_target), Space O(subset_target).

## 要特別避免的錯誤

- Missing the parity check.
- Iterating forward and reusing one number.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
