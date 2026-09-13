---
title: "LeetCode 416: Partition Equal Subset Sum"
summary: "LeetCode 416 解題筆記，依照原始 learning note 重新整理"
description: "2026-08-23 的 LeetCode 416 學習紀錄，包含筆記修正點與正確解法"
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
來源：Day 43 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 416` is the clean `0/1` reachability anchor.
- I do not classify knapsack problems by surface wording alone. I ask three things: can each item be reused, what exactly does `dp[...]` represent, and what loop direction preserves that meaning in 1D compression. `LC 416` is `0/1` reachability so the target loop goes backward. `LC 518` is unbounded counting so the amount loop goes forward. `LC 322` is also unbounded, but its state is minimum coins, so the recurrence and invalid-state handling are different.
- explain `LC 416` as `0/1` reachability with backward loop direction

## 當天筆記摘錄

#### Problem 1 - LC 416 Partition Equal Subset Sum
- **Pattern:** `0/1` knapsack / subset-sum reachability

#### Why This Fits
Each number can be used:
```text
either once or not at all
```

The question becomes:
```text
can I reach total / 2?
```

That is classic `0/1` subset selection.

#### Core State / Invariant
2D form:
```text
dp[i][s] = whether some subset from the first i numbers can make sum s
```

Compressed form:
```text
dp[s] = whether the numbers processed so far can make sum s
```

#### Base Case
```text
dp[0] = true
```

Reason:
```text
choosing nothing always makes sum 0
```

#### Transition
For each `num`:
```text
dp[s] = dp[s] or dp[s - num]
```

when:
```text
s >= num
```

#### Why Loop Direction Matters
In 1D compression, iterate `s` backward:
```text
for s from target down to num
```

Reason:
```text
backward iteration prevents the current number from being reused in the same round
```

#### Complexity
```text
Time: O(n * target)
Space: O(target)
```

#### Common Mistakes
- forgetting the odd-total early exit
- iterating `s` forward and accidentally reusing one number in the same round
- saying `dp[s]` is a best value instead of a reachable-state boolean
- failing to explain why `dp[0] = true`

#### Strong Spoken Explanation
I first reduce the problem to whether some subset reaches `total / 2`, because equal partition means both sides must sum the same. Then I use `0/1` subset-sum DP where `dp[s]` means whether the processed numbers can make sum `s`. The base case is `dp[0] = true`, since choosing nothing makes sum zero. For each number I update the target sum backward so the current number is used at most once. If `dp[target]` is true at the end, an equal partition exists.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def canPartition(self, nums: List[int]) -> bool:
        total = sum(nums)
        if total % 2:
            return False
        target = total // 2
        dp = [False] * (target + 1)
        dp[0] = True

        for num in nums:
            for s in range(target, num - 1, -1):
                dp[s] = dp[s] or dp[s - num]

        return dp[target]
```

## 複雜度

Time O(n * target), Space O(target).

## 要特別避免的錯誤

- Not rejecting odd total first.
- Iterating forward and reusing the same number.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
