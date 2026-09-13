---
title: "LeetCode 376: Wiggle Subsequence"
summary: "LeetCode 376 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-23 的 LeetCode 376 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-23
tags: ["medium", "dynamic-programming", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-23
來源：Day 25 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- explain `LC 376` as alternating-direction state tracking, not vague greedy intuition

## 當天筆記摘錄

#### Problem 1 - LC 376 Wiggle Subsequence
- **Pattern:** state-machine DP / greedy over alternating direction.

#### Why This Fits
At each position, the only thing that matters is:
```text
what is the best wiggle subsequence length if my last step was up or down?
```

That is a clean exact-end-state question, so state-machine reasoning fits naturally.

#### Core State / Invariant
```text
up   = best wiggle length ending at current index with last difference positive
down = best wiggle length ending at current index with last difference negative
```

If:
- `nums[i] > nums[i - 1]`, a positive jump can extend a sequence whose last jump was negative:
  - `up = down + 1`
- `nums[i] < nums[i - 1]`, a negative jump can extend a sequence whose last jump was positive:
  - `down = up + 1`
- equal values do not help either direction

#### Why Greedy Compression Works
For wiggle behavior, only turning points matter.

If you already have an upward move, keeping a more extreme endpoint is always at least as good as keeping a weaker one, because it preserves or improves the chance of a future alternating move.

That is why the full DP collapses cleanly into rolling `up/down`.

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- treating equal adjacent values as a valid wiggle step
- forgetting that `up` and `down` are lengths, not differences
- trying to keep the full subsequence instead of the best length under each ending direction
- giving a greedy answer without being able to justify why local compression is safe

#### Strong Spoken Explanation
I track two exact states: the best wiggle length ending here if the last movement is up, and the best if the last movement is down. When I see a larger value than the previous one, I can extend a sequence whose last movement was down; when I see a smaller value, I can extend one whose last movement was up. Equal values do not change either state. The reason the solution compresses to two variables is that for future wiggles only the best length under each ending direction matters.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def wiggleMaxLength(self, nums: List[int]) -> int:
        up = down = 1
        for i in range(1, len(nums)):
            if nums[i] > nums[i - 1]:
                up = down + 1
            elif nums[i] < nums[i - 1]:
                down = up + 1
        return max(up, down)
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Counting zero differences.
- Needing the actual subsequence; only length is required.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
