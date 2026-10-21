---
title: "LeetCode 3075: Maximize Happiness of Selected Children"
summary: "LeetCode 3075 解題筆記：由大到小選 k 個，第 i 個選的會被扣 i，扣到 0 為止"
description: "2024-03-10 的 LeetCode 3075 解題紀錄"
date: 2024-03-10
tags: ["medium", "array", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2024-03-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

每選一個人，其他還沒選的都減 1，所以第 `i` 個（從 0 開始）被選的人實際貢獻 `max(happiness - i, 0)`。要總和最大就由大到小選（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一）：大的先選扣得少，而且減到 0 之後就不會再變負。

## 我的嘗試

2024 年比賽時一次 AC，就是排序後由大到小選。

## 正確解法

```python
class Solution:
    def maximumHappinessSum(self, happiness: List[int], k: int) -> int:
        happiness.sort(reverse=True)
        return sum(max(h - i, 0) for i, h in enumerate(happiness[:k]))
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 減到 0 為止，不會變成負的。
- 答案可能很大，但 Python 不會溢位。

## 面試口說整理

第 i 個被選的人會被扣 i，所以我由大到小排序取前 k 個，每個貢獻它減掉 i 和 0 的較大值，加總就是答案。時間 `O(n log n)`。
