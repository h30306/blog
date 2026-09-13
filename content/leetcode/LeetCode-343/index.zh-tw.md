---
title: "LeetCode 343: Integer Break"
summary: "LeetCode 343 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-07 的 LeetCode 343 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-07
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
第一次嘗試：2026-05-07
來源：Day 20 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 343 Integer Break
- **Status:** Good enough.
- **Pattern:** Partition DP / max-product DP.

#### Why DP Fits
For each integer `i`, we try every split:
```text
i = j + (i - j)
```

The best product for `i` depends on smaller integers, so this has overlapping subproblems.

Important nuance:
```text
each side of the split may be kept raw or broken further
```

#### State
```text
dp[i] = maximum product obtainable by breaking integer i into at least two positive integers
```

#### Base Case
```text
dp[1] = 1
dp[2] = 1
```

#### Transition
For each split `j` from `1` to `i - 1`:
```text
dp[i] = max(dp[i], max(j, dp[j]) * max(i - j, dp[i - j]))
```

Why `max(raw, dp)` matters:
- sometimes a side should stay as the raw number
- sometimes a side should be broken further

Counterexample to `dp[j] * dp[i-j]` only:
```text
i = 3, split = 2 + 1
correct product is 2 * 1 = 2
but dp[2] * dp[1] = 1 * 1 = 1
```

#### Complexity
```text
Time: O(n^2)
Space: O(n)
```

#### Common Mistakes
- forcing both sides to use `dp[...]` instead of allowing raw factors
- forgetting that the problem requires at least one break
- using `j = 0` split even though all parts must be positive

#### Interview-Ready Explanation
This is partition DP. I define `dp[i]` as the maximum product obtainable by breaking integer `i` into at least two positive integers. For each `i`, I try every split `j` and `i - j`. For each side, I choose either to keep it as a raw number or break it further, so the transition is `dp[i] = max(dp[i], max(j, dp[j]) * max(i - j, dp[i - j]))`. The time complexity is `O(n^2)` and the space complexity is `O(n)`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def integerBreak(self, n: int) -> int:
        dp = [0] * (n + 1)
        for x in range(2, n + 1):
            for a in range(1, x):
                b = x - a
                dp[x] = max(dp[x], max(a, dp[a]) * max(b, dp[b]))
        return dp[n]
```

## 複雜度

Time O(n^2), Space O(n).

## 要特別避免的錯誤

- Forgetting n must be broken into at least two positive integers.
- Only considering fully broken subparts.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
