---
title: "LeetCode 45: Jump Game II"
summary: "LeetCode 45 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-01 的 LeetCode 45 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-01
tags: ["medium", "greedy", "bfs"]
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

- 2. Explain `current_end` vs `farthest` in `LC 45`.
- 1. Re-explain why `LC 45` is greedy instead of defaulting to DP language.

## 當天筆記摘錄

#### Problem 2 - LC 45 Jump Game II
- **Status:** Good enough after BFS-layer greedy correction.
- **Pattern:** Greedy / BFS-layer frontier expansion.

#### Why Greedy Fits
This problem asks for:
```text
minimum number of jumps
```

The clean way to think about it is BFS by layers:
- all indices up to `current_end` are reachable with the current number of jumps
- while scanning that layer, compute the farthest index reachable with one more jump
- when the layer ends, commit one jump

#### Core Invariants
```text
current_end = farthest index reachable with current jump count
farthest = farthest index reachable while scanning the current layer
jumps = number of committed layers / jumps
```

#### Layer Transition
```text
for i in range(len(nums) - 1):
    farthest = max(farthest, i + nums[i])
    if i == current_end:
        jumps += 1
        current_end = farthest
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- defaulting to `O(n^2)` DP even though a linear greedy solution exists
- incrementing `jumps` when `farthest` changes instead of when the current layer ends
- iterating through the last index and adding one unnecessary jump

#### Interview-Ready Explanation
I treat the array like BFS layers. `current_end` is the farthest index reachable with the current number of jumps, and `farthest` is the farthest position I can reach while scanning that layer. When I finish the layer, I increment `jumps` and move `current_end` to `farthest`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def jump(self, nums: List[int]) -> int:
        jumps = 0
        current_end = 0
        farthest = 0

        for i in range(len(nums) - 1):
            farthest = max(farthest, i + nums[i])
            if i == current_end:
                jumps += 1
                current_end = farthest

        return jumps
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Doing O(n^2) DP unnecessarily.
- Incrementing jumps after reaching the last index.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
