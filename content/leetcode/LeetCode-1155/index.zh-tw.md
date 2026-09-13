---
title: "LeetCode 1155: Number of Dice Rolls With Target Sum"
summary: "LeetCode 1155 解題筆記，依照原始 learning note 重新整理"
description: "2026-08-23 的 LeetCode 1155 學習紀錄，包含筆記修正點與正確解法"
date: 2026-08-23
tags: ["medium", "dynamic-programming", "counting"]
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

- `LC 1155`: pass after state and base-case repair
- explain why `LC 1155` needs per-die layers and `newDp`
- say one clean difference between `LC 494`, `LC 518`, and `LC 1155`

## 當天筆記摘錄

#### Problem 2 - LC 1155 Number of Dice Rolls With Target Sum
- **Pattern:** layered counting DP with bounded per-step choices.

#### Why This Fits
This is not subset choice and not unbounded reuse.

The real question is:
```text
after rolling exactly d dice, how many ways produce sum s?
```

#### Core State / Invariant
2D form:
```text
dp[d][s] = number of ways to make sum s using exactly d dice
```

Compressed form:
```text
dp[s] = number of ways from the previous dice layer
newDp[s] = number of ways for the current dice layer
```

#### Base Case
Before rolling any dice:
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0 with 0 dice
```

#### Transition
For each die, for each target sum, try every face:
```text
newDp[s] += dp[s - face]
```

when:
```text
s - face >= 0
```

Apply modulo after each addition.

#### Why `newDp` Is Required
The current layer must only read:
```text
states from d - 1 dice
```

If updated in place, one die could contribute multiple times in the same layer, which is incorrect.

#### Complexity
```text
Time: O(n * target * k)
Space: O(target)
```

#### Common Mistakes
- wrong base-case explanation for `dp[0]`
- trying to reuse a single array in place like `LC 518`
- saying this is unbounded knapsack
- forgetting modulo in the recurrence

#### Strong Spoken Explanation
I model this as counting ways by dice layer. `dp[s]` means the number of ways to make sum `s` from the previous number of dice, and for each new die I build a fresh `newDp`. For each target sum and each face value from `1` to `k`, I add the number of ways to reach `s - face` from the previous layer. The key invariant is that when computing the layer for `d` dice, I must only read states from `d - 1` dice, which is why I use `newDp` instead of in-place updates.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def numRollsToTarget(self, n: int, k: int, target: int) -> int:
        mod = 10 ** 9 + 7
        dp = [0] * (target + 1)
        dp[0] = 1

        for _ in range(n):
            ndp = [0] * (target + 1)
            for s in range(target + 1):
                if dp[s] == 0:
                    continue
                for face in range(1, k + 1):
                    if s + face <= target:
                        ndp[s + face] = (ndp[s + face] + dp[s]) % mod
            dp = ndp

        return dp[target]
```

## 複雜度

Time O(n * target * k), Space O(target).

## 要特別避免的錯誤

- Updating one array in place and mixing dice layers.
- Forgetting the modulo.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
