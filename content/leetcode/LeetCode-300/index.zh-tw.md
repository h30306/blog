---
title: "LeetCode 300: Longest Increasing Subsequence"
summary: "LeetCode 300 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-01 的 LeetCode 300 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-01
tags: ["medium", "dynamic-programming", "binary-search"]
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

- 2. Explain why `LC 300` DP state must mean "ending at i".

## 當天筆記摘錄

#### Problem 2 - LC 300 Longest Increasing Subsequence
- **Status:** Good enough for both `O(n^2)` DP and `O(n log n)` follow-up.
- **Pattern:** Sequence DP, plus greedy + binary search optimization.

#### O(n^2) DP

#### Why DP Fits
For each index `i`, the LIS ending at `i` depends on earlier indices `j < i` whose values are smaller than `nums[i]`.

#### State
```text
dp[i] = length of the longest increasing subsequence ending at index i
```

#### Base Case
```text
dp[i] = 1 for every i
```

Reason:
```text
each element alone is an increasing subsequence of length 1
```

#### Transition
```text
for each j < i:
    if nums[j] < nums[i]:
        dp[i] = max(dp[i], dp[j] + 1)
```

#### Answer
```text
max(dp)
```

#### Complexity
```text
Time: O(n^2)
Space: O(n)
```

#### Common Mistakes
- saying "choose index i as one of the elements" instead of "ending at i"
- forgetting the answer is global max, not just `dp[-1]`

#### O(n log n) Follow-Up

#### Core Idea
Keep:
```text
tails[len - 1] = the smallest possible tail value of an increasing subsequence of length len
```

Why smaller tail is better:
```text
for the same subsequence length, a smaller tail gives more future extension options
```

#### Update Rule
For each number:
- if it is larger than all tails, append it
- otherwise replace the first tail `>= num`

#### Important Nuance
```text
tails is not always the actual LIS sequence
```

But:
```text
len(tails) is the correct LIS length
```

#### Complexity
```text
Time: O(n log n)
Space: O(n)
```

#### Interview-Ready Explanation
The O(n^2) DP uses `dp[i]` as the LIS ending at `i`. The O(n log n)` follow-up keeps the smallest possible tail for each subsequence length and uses binary search to replace tails. A smaller tail is better because it leaves more room for future extension.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from bisect import bisect_left
from typing import List

class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        tails = []
        for x in nums:
            i = bisect_left(tails, x)
            if i == len(tails):
                tails.append(x)
            else:
                tails[i] = x
        return len(tails)
```

## 複雜度

Time O(n log n), Space O(n).

## 要特別避免的錯誤

- Treating equal values as increasing; use first >= x.
- Confusing tails with the actual final subsequence.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
