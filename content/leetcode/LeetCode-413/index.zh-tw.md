---
title: "LeetCode 413: Arithmetic Slices"
summary: "LeetCode 413 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-10 的 LeetCode 413 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-10
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
第一次嘗試：2026-05-10
來源：Day 21 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 4. Explain why `LC 413` adds previous streak plus one new length-3 slice.
- **LC 413 Arithmetic Slices:** Pass.

## 當天筆記摘錄

#### Problem 2 - LC 413 Arithmetic Slices
- **Status:** Pass.
- **Pattern:** 1D streak DP on contiguous subarrays.

#### Correct State
```text
curr = number of arithmetic slices ending at the current index
total = total number of arithmetic slices seen so far
```

#### Why This State Fits
The problem is about:
```text
contiguous subarrays
```

So at each index `i`, only the last 2 adjacent differences matter:
```text
nums[i] - nums[i - 1]
nums[i - 1] - nums[i - 2]
```

If they match, then:
- every arithmetic slice ending at `i - 1` can extend to `i`
- plus the last 3 elements form one new arithmetic slice

So:
```text
curr += 1
total += curr
```

If the difference breaks:
```text
curr = 0
```

#### Initialization
```text
curr = total = 0
```

Why:
```text
fewer than 3 elements cannot form an arithmetic slice
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- confusing contiguous subarrays with subsequences
- saying only the new length-3 slice matters and forgetting earlier slices can extend
- using extra state that duplicates the rolling DP meaning

#### Interview-Ready Explanation
This is streak DP on contiguous subarrays. I define `curr` as the number of arithmetic slices ending at the current index, and `total` as the total number of arithmetic slices seen so far. Starting from index `2`, if the last 2 adjacent differences are equal, then every arithmetic slice ending at `i - 1` can extend to `i`, and the last 3 elements form one new slice, so I do `curr += 1` and `total += curr`. Otherwise the streak breaks and `curr = 0`. The time complexity is `O(n)` and the space complexity is `O(1)`.

#### Code
```python
class Solution:
    def numberOfArithmeticSlices(self, nums: List[int]) -> int:
        total = 0
        curr = 0

        for i in range(2, len(nums)):
            if nums[i] - nums[i - 1] == nums[i - 1] - nums[i - 2]:
                curr += 1
                total += curr
            else:
                curr = 0

        return total
```

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def numberOfArithmeticSlices(self, nums: List[int]) -> int:
        curr = total = 0
        for i in range(2, len(nums)):
            if nums[i] - nums[i - 1] == nums[i - 1] - nums[i - 2]:
                curr += 1
                total += curr
            else:
                curr = 0
        return total
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Counting only length-3 slices.
- Not resetting when the difference changes.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
