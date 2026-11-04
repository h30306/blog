---
title: "LeetCode 1011: Capacity To Ship Packages Within D Days"
summary: "LeetCode 1011 解題筆記：對答案二分，容量範圍是 [max(weights), sum(weights)]，用貪心照順序裝來檢查天數"
description: "2026-11-03 的 LeetCode 1011 解題紀錄"
date: 2026-11-03
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-11-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

容量越大，需要的天數越少，有單調性，所以對答案二分（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板二）：
- **下界是 `max(weights)`**：包裹不能拆，容量比最重的包裹小就永遠裝不了。
- **上界是 `sum(weights)`**：一天就全部運完。
- **檢查**：照順序裝，裝不下就開新的一天，最後看天數有沒有超過 `days`。

要找的是可行的最小容量。

## 我的嘗試

一次通過。跟 LC 875 同一天寫，用的是同一個左閉右閉模板：可行就 `right = mid - 1`，否則 `left = mid + 1`，最後回傳 `left`。

## 正確解法

```python
class Solution:
    def shipWithinDays(self, weights: List[int], days: int) -> int:
        def valid(cap):
            need, curr = 1, 0
            for w in weights:
                if curr + w <= cap:
                    curr += w
                else:                 # 裝不下，開新的一天
                    need += 1
                    curr = w
            return need <= days

        left, right = max(weights), sum(weights)
        while left <= right:
            mid = (left + right) // 2
            if valid(mid):
                right = mid - 1
            else:
                left = mid + 1
        return left
```

## 複雜度

時間 `O(n log S)`，`S` 是 `sum(weights)`；空間 `O(1)`。

## 要特別避免的錯誤

- 下界寫成 1：`valid` 沒有檢查單一包裹比容量大的情況，開了新的一天就當作裝得下。`weights = [1, 5]`、`days = 2` 會回傳 1，答案是 5。下界設成 `max(weights)`，就不用另外檢查。
- 天數要從 1 開始算，第一天也算一天。

## 面試口說整理

容量越大天數越少，所以對答案二分。下界是最重的包裹，因為包裹不能拆；上界是全部的重量，一天就能運完。檢查時照順序裝，裝不下就開新的一天，看天數有沒有超過限制。找可行的最小容量。時間 `O(n log S)`，空間 `O(1)`。
