---
title: "LeetCode 53: Maximum Subarray"
summary: "LeetCode 53 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-10 的 LeetCode 53 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-10
tags: ["medium", "dynamic-programming", "kadane"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-10
來源：Day 21 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 1. Explain `LC 53` with the exact ending-here invariant and correct initialization.
- 2. Explain why `LC 53` needs `best` separately from `curr`.
- **LC 53 Maximum Subarray:** Pass.
- 1. Re-answer `LC 53` once more later with no wording drift on the invariant.

## 當天筆記摘錄

#### Problem 1 - LC 53 Maximum Subarray
- **Status:** Pass.
- **Pattern:** 1D DP with rolling state / Kadane's algorithm.

#### Correct State
```text
curr = maximum subarray sum ending at the current index
best = maximum subarray sum seen so far
```

#### Why This State Fits
For any index `i`, the best subarray ending at `i` has only 2 possibilities:
- start fresh at `nums[i]`
- extend the best subarray ending at `i - 1`

That gives the recurrence:
```text
curr = max(nums[i], curr + nums[i])
best = max(best, curr)
```

#### Initialization
```text
curr = best = nums[0]
```

Why:
```text
all-negative arrays are valid, so initializing to 0 would be wrong
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- saying `curr` is just "current subarray sum" instead of the exact ending-here invariant
- initializing to `0`, which breaks all-negative arrays
- returning `curr` instead of `best`

#### Interview-Ready Explanation
This is 1D DP with rolling state, also known as Kadane's algorithm. I define `curr` as the maximum subarray sum ending at the current index, and `best` as the maximum subarray sum seen so far. For each element, the best subarray ending here either starts fresh at this element or extends the previous ending-here subarray, so `curr = max(nums[i], curr + nums[i])`. Then I update `best = max(best, curr)`. I initialize both to `nums[0]` so all-negative arrays are handled correctly. The time complexity is `O(n)` and the space complexity is `O(1)`.

#### Code
```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        curr = best = nums[0]

        for i in range(1, len(nums)):
            curr = max(nums[i], curr + nums[i])
            best = max(best, curr)

        return best
```

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        curr = best = nums[0]
        for x in nums[1:]:
            curr = max(x, curr + x)
            best = max(best, curr)
        return best
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Resetting to zero when all numbers are negative.
- Returning the current sum instead of global best.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
