---
title: "LeetCode 55: Jump Game"
summary: "LeetCode 55 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-01 的 LeetCode 55 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-01
tags: ["medium", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-01
來源：Day 16 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 1. Explain why `LC 55` is greedy, not DP.

## 當天筆記摘錄

#### Problem 1 - LC 55 Jump Game
- **Status:** Good enough after greedy correction.
- **Pattern:** Greedy reachable frontier.

#### Why Greedy Fits
At each index, the only future-relevant information is:
```text
how far to the right we can reach so far
```

We do not need to try every jump path. If an index is reachable, then the exact path that reached it no longer matters; only the farthest frontier matters.

#### Core Invariant
```text
farthest = farthest index reachable after scanning positions up to i
```

#### Failure Condition
```text
if i > farthest:
    current index is unreachable -> return False
```

#### Update Rule
```text
farthest = max(farthest, i + nums[i])
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- calling the best solution DP just because it scans left to right
- thinking greedy means "always physically take the biggest jump now"
- storing per-index state when only one frontier variable is needed

#### Interview-Ready Explanation
I scan left to right and keep the farthest index reachable so far. If I ever reach an index beyond that frontier, the answer is false. Otherwise I extend the frontier with `i + nums[i]`. If the frontier reaches the last index, the array is solvable.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def canJump(self, nums: List[int]) -> bool:
        farthest = 0
        for i, jump in enumerate(nums):
            if i > farthest:
                return False
            farthest = max(farthest, i + jump)
        return True
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Doing exhaustive DFS.
- Updating farthest from an unreachable index.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
