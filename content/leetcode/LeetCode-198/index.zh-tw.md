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

## 整理補充

這題是 choose-or-skip DP 的基準題。掃過一段 houses 後，`prev1` 代表目前 prefix 的最佳答案，`prev2` 代表前一間以前的最佳答案。遇到新 house 時，合法選擇只有兩個：skip 它並保留 `prev1`，或 rob 它並加上 `prev2`。所以兩變數寫法只是把 `dp[i] = max(dp[i - 1], dp[i - 2] + nums[i])` 壓縮掉。

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

我會把這題講成 choose-or-skip DP。每一間房子只有兩種合法選擇：不偷它，保留目前最佳；或偷它，加上前前一間以前的最佳。兩變數版本就是 `dp[i] = max(dp[i - 1], dp[i - 2] + nums[i])` 的壓縮。
