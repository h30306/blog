---
title: "LeetCode 198: House Robber"
summary: "LeetCode 198 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-17 的 LeetCode 198 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-17
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
第一次嘗試：2026-05-17
來源：Day 22 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 3 - LC 198 House Robber Review
- **Pattern:** 1D DP / choose-skip recurrence.

#### Why This Review Matters
Week 5 starts a harder DP derivation week, so one stable 1D DP review keeps the baseline clean:
```text
dp[i] = max(dp[i - 1], nums[i] + dp[i - 2])
```

#### Interview-Ready Explanation
For each house, I either skip it and keep the best result up to `i - 1`, or rob it and add `nums[i]` to the best result up to `i - 2`. The recurrence is a clean choose-vs-skip DP.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def rob(self, nums: List[int]) -> int:
        prev2 = prev1 = 0
        for x in nums:
            prev2, prev1 = prev1, max(prev1, prev2 + x)
        return prev1
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Robbing adjacent houses.
- Building a full array when two variables are enough.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
