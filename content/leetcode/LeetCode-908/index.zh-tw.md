---
title: "LeetCode 908: Smallest Range I"
summary: "LeetCode 908 解題筆記：最大值往下調 k、最小值往上調 k，答案是 max(0, max - min - 2k)"
description: "2022-09-25 的 LeetCode 908 解題紀錄"
date: 2022-09-25
tags: ["easy", "array", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-25
- 提交紀錄：Wrong Answer ×5 → Accepted

## 解題思路

只有最大值和最小值重要（[Math]({{< relref "/algorithm/Math" >}}) 模板四）：最大值最多降 `k`、最小值最多升 `k`，差距最多縮小 `2k`；其他數都夾在中間，可以跟著調到範圍內。差距不會小於 0。

## 我的嘗試

前四版寫成 `max + min` 而不是 `max - min`；改成相減之後，**差距大於 `2k` 時忘了扣掉 `2k`**：`[9, 0]`、`k = 3` 答案 3，回傳 9。

## 正確解法

```python
class Solution:
    def smallestRangeI(self, nums: List[int], k: int) -> int:
        return max(0, max(nums) - min(nums) - 2 * k)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 是最大值減最小值，再扣掉 `2k`。

## 面試口說整理

只有最大值和最小值重要，最大值往下 k、最小值往上 k，差距最多縮小 2k，不會小於 0，所以答案是 max(0, max - min - 2k)。時間 `O(n)`。
