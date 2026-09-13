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

## 整理補充

這題的重點就是 circular constraint。因為 house `0` 和 house `n - 1` 相鄰，直接跑 linear robber 可能同時選到兩端。把問題拆成 `nums[:-1]` 和 `nums[1:]` 兩個線性子問題，就完整覆蓋所有合法最佳解：最佳解不是排除最後一間，就是排除第一間。`n == 1` 要先處理，否則 slice 會變成空陣列問題。

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

我會先指出第一間和最後一間相鄰，所以不能直接套線性 House Robber。最佳解一定屬於兩種情況之一：排除最後一間，或排除第一間。分別跑 `LC 198` 的 helper 後取最大值，並先處理單一房子的 edge case。
