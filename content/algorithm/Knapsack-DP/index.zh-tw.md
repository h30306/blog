---
title: "Knapsack DP"
summary: "0/1、unbounded、reachability、counting 與 optimization state"
description: "演算法學習"
date: 2026-09-13
tags: ["dynamic-programming", "knapsack", "subset-sum"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Knapsack DP 題目表面很像，但正確解法取決於三個問題：

1. 每個 item 只能用一次，還是可以重複使用？
2. `dp[...]` 代表 reachable、ways、minimum cost，還是 maximum value？
3. 做 1D compression 時，capacity loop 要往後還是往前？

大部分錯誤都來自這三個問題其中一個答錯。

## 0/1 Knapsack

每個 item 最多只能用一次，所以壓縮成 1D 後，capacity loop 要倒著走。

```python
from typing import List

def subset_sum(nums: List[int], target: int) -> bool:
    dp = [False] * (target + 1)
    dp[0] = True

    for num in nums:
        for s in range(target, num - 1, -1):
            dp[s] = dp[s] or dp[s - num]

    return dp[target]
```

倒著走可以避免同一輪重複使用目前 item。

## Unbounded Knapsack

每個 item 可以重複使用，所以 capacity loop 通常往前走。

```python
from typing import List

def coin_change_min(coins: List[int], amount: int) -> int:
    inf = amount + 1
    dp = [inf] * (amount + 1)
    dp[0] = 0

    for coin in coins:
        for a in range(coin, amount + 1):
            dp[a] = min(dp[a], dp[a - coin] + 1)

    return -1 if dp[amount] == inf else dp[amount]
```

## Counting Combinations vs Permutations

如果要數 combinations，items 放外層：

```text
for coin in coins:
    for amount forward:
        dp[amount] += dp[amount - coin]
```

如果要數 ordered sequences，target 放外層：

```text
for total in range(target + 1):
    for num in nums:
        dp[total] += dp[total - num]
```

這就是 `LC 518` 和 `LC 377` 最重要的差別。

## Grouped / Bounded Knapsack（分組背包）

每一組最多選**一個選項**（同一題目選幾題、同一堆拿幾個、同一個數變成哪個值）。容量一樣要**倒著走**，在裡面枚舉這一組的所有選項：

```python
dp = [0] + [inf] * target               # 或計數：[1] + [0] * target
for group in groups:
    for s in range(target, -1, -1):      # 倒著走：同一組不會被選兩次
        for weight, value in group:      # 這一組的每個選項
            if s - weight >= 0:
                dp[s] = min(dp[s], dp[s - weight] + value)
```

- **有數量上限的物品**（LC 2585）：一種題目有 `count` 題，選 `1..count` 題就是這一組的選項。
- **每堆只能拿前綴**（LC 2218）：一堆拿 `x` 個的價值是前綴和，`x` 就是選項。
- **每個數可以先變形再選**（LC 4040、4041）：先列出一個數經過幾次操作能變成哪些值、各要幾步，這些就是這個數的選項。

## 常見錯誤

- 把所有 coin problem 都當成同一個 recurrence。
- `0/1` items 用 forward loop，導致同一個 item 被重複使用。
- unbounded counting 用 backward loop，導致 reuse 被拿掉。
- 混淆 min-count 的 `dp[0] = 0` 和 counting 的 `dp[0] = 1`。
- partition 題只找 exact half，但實際可能要找最接近 half 的 reachable sum。

## 相關 LeetCode

- `LC 416` Partition Equal Subset Sum
- `LC 474` Ones and Zeroes
- `LC 494` Target Sum
- `LC 518` Coin Change 2
- `LC 879` Profitable Schemes
- `LC 1049` Last Stone Weight II
- `LC 1449` Form Largest Integer With Digits That Add Up To Target
- `LC 2585` Number of Ways to Earn Points
- `LC 2218` Maximum Value of K Coins From Piles
- `LC 4040` Minimum Operations to Form Subset Sum I
- `LC 4041` Minimum Operations to Form Subset Sum II
- `LC 4081` Prime Subset Selection II
