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

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 先檢查總油量，不然最後的 `start` 不一定能繞完一圈。
- 油箱變負時起點跳到 `i + 1`，不是 `start + 1`。

## 面試口說整理

總油量比總花費少就不可能。否則我從左往右累加油量減花費，變成負的就代表從目前的起點到這裡之間都不能當起點，把起點移到下一站重新算，最後的起點就是答案。時間 `O(n)`。
