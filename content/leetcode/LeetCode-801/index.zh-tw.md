---
title: "LeetCode 801: Minimum Swaps To Make Sequences Increasing"
summary: "LeetCode 801 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-23 的 LeetCode 801 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-23
tags: ["hard", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-05-23
來源：Day 25 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- explain `LC 801` with `keep/swap` state meaning and legal transition cases

## 當天筆記摘錄

#### Problem 2 - LC 801 Minimum Swaps To Make Sequences Increasing
- **Pattern:** DP with two prefix states per index.

#### Why This Fits
At each index, the important question is:
```text
is index i swapped or not swapped?
```

That decision changes what values the next index sees, so the state must explicitly track it.

#### Core State / Invariant
```text
keep = minimum swaps needed up to index i if index i is not swapped
swap = minimum swaps needed up to index i if index i is swapped
```

Initialize:
```text
keep = 0
swap = 1
```

Because at index `0`:
- not swapping costs `0`
- swapping costs `1`

#### Transition Logic
At each `i`, check two kinds of validity.

#### Natural Order Works
```text
A[i - 1] < A[i] and B[i - 1] < B[i]
```

Then:
- if previous state was `keep`, current `keep` stays valid
- if previous state was `swap`, current `swap` stays valid with `+1` for the current swap

So:
```text
next_keep = min(next_keep, keep)
next_swap = min(next_swap, swap + 1)
```

#### Cross Order Works
```text
A[i - 1] < B[i] and B[i - 1] < A[i]
```

Then:
- a previous `swap` can lead to current `keep`
- a previous `keep` can lead to current `swap`

So:
```text
next_keep = min(next_keep, swap)
next_swap = min(next_swap, keep + 1)
```

#### Why This Problem Is Good For Interviews
It forces you to prove:
- what your state means
- why each transition is legal
- why the answer is not greedy on one local pair only

It is a clean test of whether you can reason from invariants instead of pattern-matching syntax.

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- forgetting to reset `next_keep` and `next_swap` to infinity each round
- mixing natural-order and cross-order transitions incorrectly
- using one sequence's ordering without checking the other
- not being able to explain why the state must track swap status at index `i`

#### Strong Spoken Explanation
I use two DP states per index: the minimum swaps so far if I keep the current pair as-is, and the minimum swaps so far if I swap the current pair. The recurrence depends on whether the current values are strictly increasing in natural order, cross order, or both. Natural order lets me stay in the same swap-status pattern. Cross order lets me switch between previous swap and current keep, or previous keep and current swap. Because the legality depends on whether the previous index was swapped, I have to keep that state explicitly.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def minSwap(self, nums1: List[int], nums2: List[int]) -> int:
        keep, swap = 0, 1

        for i in range(1, len(nums1)):
            n_keep = n_swap = float('inf')
            if nums1[i] > nums1[i - 1] and nums2[i] > nums2[i - 1]:
                n_keep = min(n_keep, keep)
                n_swap = min(n_swap, swap + 1)
            if nums1[i] > nums2[i - 1] and nums2[i] > nums1[i - 1]:
                n_keep = min(n_keep, swap)
                n_swap = min(n_swap, keep + 1)
            keep, swap = n_keep, n_swap

        return min(keep, swap)
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Checking only A[i] > A[i-1] and B[i] > B[i-1].
- Forgetting crossed transitions.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
