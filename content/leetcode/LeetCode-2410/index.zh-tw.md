---
title: "LeetCode 2410: Maximum Matching of Players With Trainers"
summary: "LeetCode 2410 解題筆記：兩邊都排序後，用同向雙指針讓最弱的球員配最小的、夠用的教練"
description: "2025-07-13 的 LeetCode 2410 解題紀錄"
date: 2025-07-13
tags: ["medium", "two-pointers", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-13
- 提交紀錄：Accepted（一次通過）

## 解題思路

貪心：**能力最弱的球員，應該配「剛好夠用」的最小教練**。把大的教練留給更強的球員，不會讓配對數變少。

把 `players` 和 `trainers` 都排序，兩個指針同向走：

- `trainers[j] < players[i]`：這個教練連目前最弱的球員都帶不動，之後的球員更強，也帶不動，跳過這個教練。
- 否則配成一對，兩個指針都前進。

最後配了幾個球員就是答案。

## 我的解法

```python
class Solution:
    def matchPlayersAndTrainers(self, players: List[int], trainers: List[int]) -> int:
        players.sort()
        trainers.sort()
        i = j = 0
        while i < len(players) and j < len(trainers):
            if trainers[j] >= players[i]:
                i += 1                     # 配成一對
            j += 1                         # 這個教練用掉或跳過
        return i
```

## 複雜度

時間 `O(n log n + m log m)`（排序），空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 讓球員去配「最大的」教練：會浪費掉能帶更強球員的教練。

## 面試口說整理

我把兩邊都排序，讓最弱的球員配最小的、能力夠的教練。教練太弱就跳過，因為後面的球員只會更強；夠的話就配對，兩個指針都往前。每個元素只看一次，時間主要是排序的 `O(n log n)`。
