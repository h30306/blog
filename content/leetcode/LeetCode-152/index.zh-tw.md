---
title: "LeetCode 152: Maximum Product Subarray"
summary: "LeetCode 152 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-01 的 LeetCode 152 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-01
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
第一次嘗試：2026-05-01
來源：Day 17 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 1. Explain why `LC 152` needs both `cur_max` and `cur_min`.

## 當天筆記摘錄

#### Problem 1 - LC 152 Maximum Product Subarray
- **Status:** Good enough.
- **Pattern:** Rolling DP with max/min state.

#### Why DP Fits
Product behaves differently from sum because a negative number can flip:
- a very small negative product into the new maximum
- a previous maximum into the new minimum

So one rolling state is not enough.

#### State
```text
cur_max = maximum product of a subarray ending at current index
cur_min = minimum product of a subarray ending at current index
```

Important nuance:
```text
"max" and "min" are value-based, not sign-based labels
```

#### Base Case
```text
cur_max = cur_min = nums[0]
answer = nums[0]
```

#### Transition
For current number `x`, compute from:
- `x`
- previous `cur_max * x`
- previous `cur_min * x`

So:
```text
new_max = max(x, cur_max * x, cur_min * x)
new_min = min(x, cur_max * x, cur_min * x)
```

Then:
```text
cur_max = new_max
cur_min = new_min
answer = max(answer, cur_max)
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- tracking only one running product
- forgetting that the DP boundary is "ending at i"
- returning the final `cur_max` instead of a global answer

#### Interview-Ready Explanation
I track both the maximum and minimum product ending at each index, because multiplying by a negative can swap their roles. At each number, I either start a new subarray or extend the previous max/min product. I keep a separate global answer because the best subarray may end before the last index.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maxProduct(self, nums: List[int]) -> int:
        max_here = min_here = ans = nums[0]

        for x in nums[1:]:
            a = x * max_here
            b = x * min_here
            max_here = max(x, a, b)
            min_here = min(x, a, b)
            ans = max(ans, max_here)

        return ans
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Tracking only the maximum product.
- Resetting on negative numbers instead of using min_here.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
