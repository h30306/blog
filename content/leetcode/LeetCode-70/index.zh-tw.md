---
title: "LeetCode 70: Climbing Stairs"
summary: "LeetCode 70 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-20 的 LeetCode 70 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-20
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
第一次嘗試：2026-04-20
來源：Day 9 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 70 - Climbing Stairs
- **Status:** Completed.
- **Pattern:** Fibonacci-style 1D DP.

#### State
```text
dp[i] = number of distinct ways to reach step i
```

#### Base Case
```text
dp[0] = 1
dp[1] = 1
```

`dp[0] = 1` means there is one way to start before taking any steps: do nothing.

#### Transition
```text
dp[i] = dp[i - 1] + dp[i - 2]
```

To reach step `i`, the last move must come from step `i - 1` with one step or from step `i - 2` with two steps.

#### Complexity
```text
Time: O(n)
Space: O(n) with array, O(1) with two variables
```

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        if n <= 2:
            return n
        prev2, prev1 = 1, 2
        for _ in range(3, n + 1):
            prev2, prev1 = prev1, prev1 + prev2
        return prev1
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Off-by-one base cases.
- Thinking order does not matter; sequences of 1/2 steps are distinct.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
