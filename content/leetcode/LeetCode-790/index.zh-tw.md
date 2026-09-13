---
title: "LeetCode 790: Domino and Tromino Tiling"
summary: "LeetCode 790 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-24 的 LeetCode 790 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-24
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
第一次嘗試：2026-05-24
來源：Day 27 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 2 - LC 790 Domino and Tromino Tiling
- **Pattern:** profile DP / full-state plus gap-state compression.

#### Why This Fits
The hard part of this problem is not counting tiles.

It is recognizing that when tiling a `2 x n` board, the frontier can end in only a small number of meaningful shapes:
- fully filled
- one corner missing

That is exactly profile-DP reasoning.

#### Core State / Invariant
```text
full[i] = number of ways to fully tile a 2 x i board
gap[i]  = number of ways to tile a 2 x i board with exactly one corner missing
```

The `gap` state uses symmetry:
- top-missing and bottom-missing have the same count
- so one variable is enough, and the factor `2` appears in `full`

#### Base Cases
```text
full[0] = 1
full[1] = 1
gap[0] = 0
gap[1] = 0
```

Why:
- empty board has one valid tiling: do nothing
- `2 x 1` board has one vertical domino tiling
- you cannot create a one-corner-missing board of width `0` or `1` under the recurrence start

#### Transition
```text
full[i] = full[i - 1] + full[i - 2] + 2 * gap[i - 1]
gap[i] = gap[i - 1] + full[i - 2]
```

#### Why These Transitions Make Sense
For `full[i]`:
- place one vertical domino after a full `2 x (i - 1)` board
- place two horizontal dominoes after a full `2 x (i - 2)` board
- place one tromino to close a previous gap; there are 2 mirrored gap orientations

For `gap[i]`:
- extend an earlier gap with one horizontal domino
- create a new gap by attaching one tromino to a full `2 x (i - 2)` board

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- treating the problem like plain Fibonacci without explaining the gap state
- forgetting why the `2 * gap[i - 1]` term exists
- using a gap state but not defining what shape it means
- shaky base cases around `full[0]`

#### Strong Spoken Explanation
I model the board frontier, not individual tile placements. The board can end either fully covered or with exactly one corner missing, so I use `full[i]` and `gap[i]`. A full board of width `i` can come from a full board of width `i - 1` plus one vertical domino, from a full board of width `i - 2` plus two horizontal dominoes, or from closing one of the 2 mirrored gap states at width `i - 1` with a tromino. A gap board of width `i` can either extend a previous gap or be created from a full board of width `i - 2` with one tromino.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def numTilings(self, n: int) -> int:
        mod = 10 ** 9 + 7
        if n <= 2:
            return n
        a, b, c = 1, 1, 2  # dp[0], dp[1], dp[2]
        for _ in range(3, n + 1):
            a, b, c = b, c, (2 * c + a) % mod
        return c
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Forgetting modulo.
- Using only domino recurrence like Fibonacci and missing tromino shapes.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
