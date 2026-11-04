---
title: "LeetCode 134: Gas Station"
summary: "LeetCode 134 解題筆記：總油量不夠就不可能；否則從左掃，油箱變負就把起點移到下一站"
description: "2022-11-11 的 LeetCode 134 解題紀錄"
date: 2022-11-11
tags: ["medium", "array", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-11
- 提交紀錄：Accepted ×2
- 2026-11-04 重寫：Accepted

## 解題思路

兩個觀察（[Greedy]({{< relref "/algorithm/Greedy" >}})）：

1. `sum(gas) < sum(cost)` 就不可能繞一圈。
2. 從起點 `s` 出發，第一次在 `i` 油箱變負，那 `s` 到 `i` 之間的任何一站當起點也到不了 `i + 1`：從 `s` 走到中間那站時油箱是非負的，從那站重新開始只會更少。所以直接把起點跳到 `i + 1`、油箱歸零。

總油量夠的時候，最後剩下的起點就是答案（題目保證答案唯一）。

## 我的嘗試

兩次都一次 AC，都是上面這個貪心。

## 正確解法

```python
class Solution:
    def canCompleteCircuit(self, gas: List[int], cost: List[int]) -> int:
        if sum(gas) < sum(cost):
            return -1
        start = tank = 0
        for i in range(len(gas)):
            tank += gas[i] - cost[i]
            if tank < 0:
                start, tank = i + 1, 0
        return start
```

## 2026-11 重寫

2026-11-04 一次 AC，跟上面一樣。這次多想了一件事：為什麼最後留下的 `start` 繞回開頭也一定夠油？

用前綴和看最清楚。令 `P[i]` 是 `gas[0..i]` 減 `cost[0..i]` 的和。從 `s` 出發，等於把整條前綴和曲線往上平移 `-P[s-1]`。要讓每一點都不小於 0，就要把**最低點**移到 0，所以起點是前綴和最低點的下一站。

繞回開頭那段的油箱是 `P[n-1] + P[k] - P[s-1]`。`P[n-1]` 是總和，不小於 0；`P[s-1]` 是最低點，所以 `P[k] - P[s-1]` 也不小於 0。兩項加起來不小於 0，一定夠。上面的貪心每次油箱變負就重置，最後留下來的 `start` 就是最低點的下一站。

例如 `gas = [1,2,3,4,5]`、`cost = [3,4,5,1,2]`：前綴和是 `-2, -4, -6, -3, 0`，最低點在 index 2，答案是 3。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 先檢查總油量，不然最後的 `start` 不一定能繞完一圈。
- 油箱變負時起點跳到 `i + 1`，不是 `start + 1`。

## 面試口說整理

總油量比總花費少就不可能。否則我從左往右累加油量減花費，變成負的就代表從目前的起點到這裡之間都不能當起點，把起點移到下一站重新算，最後的起點就是答案。時間 `O(n)`。
