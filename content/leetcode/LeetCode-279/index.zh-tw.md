---
title: "LeetCode 279: Perfect Squares"
summary: "LeetCode 279 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-03 的 LeetCode 279 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-03
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
第一次嘗試：2026-05-03
來源：Day 18 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 279 Perfect Squares
- **Status:** Good enough.
- **Pattern:** Unbounded min-count DP.

#### Why DP Fits
For each target sum `i`, we can choose any perfect square `sq <= i` as the last piece.

That means:
```text
answer for i depends on best answer for i - sq
```

It is unbounded because the same perfect square can be reused multiple times, such as:
```text
12 = 4 + 4 + 4
```

#### State
```text
dp[i] = minimum number of perfect squares needed to sum to i
```

#### Base Case
```text
dp[0] = 0
```

Reason:
```text
zero needs zero numbers
```

Initialize all other states as:
```text
dp[i] = +infinity
```

#### Transition
For each total `i` from `1` to `n`, try every perfect square `sq <= i`:
```text
dp[i] = min(dp[i], dp[i - sq] + 1)
```

#### Complexity
```text
Time: O(n * sqrt(n))
Space: O(n)
```

#### Common Mistakes
- treating it like a counting problem instead of a min-count problem
- writing `dp[0] = 1` instead of `0`
- saying the inner loop is over all integers instead of only perfect squares
- assuming greedy always works

#### Greedy Counterexample
For:
```text
n = 12
```

greedy picks:
```text
9 + 1 + 1 + 1
```

which uses `4` numbers, but optimal is:
```text
4 + 4 + 4
```

which uses `3`.

#### Interview-Ready Explanation
This is a min-count unbounded DP problem. For each target sum `i`, I try every perfect square `sq <= i` as the last piece and combine it with the best answer for `i - sq`. I define `dp[i]` as the minimum number of perfect squares needed to sum to `i`, with base case `dp[0] = 0`. Then for each `i` from `1` to `n`, I iterate through all perfect squares up to `i` and do `dp[i] = min(dp[i], dp[i - sq] + 1)`. It is unbounded because the same square can be reused multiple times. The time complexity is `O(n * sqrt(n))` and the space complexity is `O(n)`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def numSquares(self, n: int) -> int:
        squares = [i * i for i in range(1, int(n ** 0.5) + 1)]
        dp = [0] + [float('inf')] * n

        for x in range(1, n + 1):
            for sq in squares:
                if sq > x:
                    break
                dp[x] = min(dp[x], dp[x - sq] + 1)

        return dp[n]
```

## 複雜度

Time O(n sqrt n), Space O(n).

## 要特別避免的錯誤

- Using each square at most once.
- Forgetting dp[0]=0.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
