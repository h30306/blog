---
title: "LeetCode 213: House Robber II"
summary: "LeetCode 213 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-25 的 LeetCode 213 學習紀錄，包含筆記修正點與正確解法"
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

#### Problem 2 - LC 213 House Robber II Timed Re-Solve
- **Status:** Good enough.
- **Pattern:** Circular array -> split into two linear robber problems.

#### Key Constraint
```text
first house and last house are adjacent
```

So a valid answer must be one of:
```text
exclude last house
exclude first house
```

#### Interview-Ready Explanation
Because the houses are arranged in a circle, the first and last houses are adjacent, so I cannot rob both. I split the problem into two linear House Robber I cases: rob `nums[:-1]` or rob `nums[1:]`, then take the maximum of those two answers.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def rob(self, nums: List[int]) -> int:
        if len(nums) == 1:
            return nums[0]

        def rob_line(arr):
            prev2 = prev1 = 0
            for x in arr:
                prev2, prev1 = prev1, max(prev1, prev2 + x)
            return prev1

        return max(rob_line(nums[:-1]), rob_line(nums[1:]))
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Running LC 198 directly on a circle.
- Forgetting n=1.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
