---
title: "LeetCode 2762: Continuous Subarrays"
summary: "LeetCode 2762 解題筆記：滑動窗口加兩個單調隊列，隨時拿到窗口的最大值和最小值"
description: "2026-01-19 的 LeetCode 2762 解題紀錄"
date: 2026-01-19
tags: ["medium", "sliding-window", "monotonic-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-19
- 提交紀錄：Accepted（一次通過）

## 解題思路

子陣列中任兩個數的差都不超過 2，等於 **`max - min <= 2`**。

這個條件有單調性：一個子陣列合法，它的任何子陣列也合法。所以用滑動窗口：右端每往右一格，就把左端往右推到窗口重新合法為止。以 `right` 結尾的合法子陣列有 `right - left + 1` 個。

問題是要隨時知道窗口的最大值和最小值。用 heap 可以做到 `O(log n)`，但用**兩個單調隊列**可以做到均攤 `O(1)`：

- `max_q`：存 index，對應的值**遞減**，隊首就是窗口最大值。
- `min_q`：存 index，對應的值**遞增**，隊首就是窗口最小值。

LeetCode 把這題標成 heap，但單調隊列更快也更簡單。

## 我的解法

```python
from collections import deque

class Solution:
    def continuousSubarrays(self, nums: List[int]) -> int:
        max_q, min_q = deque(), deque()
        left = count = 0
        for right, x in enumerate(nums):
            while max_q and nums[max_q[-1]] < x:
                max_q.pop()
            max_q.append(right)
            while min_q and nums[min_q[-1]] > x:
                min_q.pop()
            min_q.append(right)

            while nums[max_q[0]] - nums[min_q[0]] > 2:
                if max_q[0] == left:
                    max_q.popleft()
                if min_q[0] == left:
                    min_q.popleft()
                left += 1

            count += right - left + 1
        return count
```

`left` 往右移時，只有剛好等於 `left` 的隊首需要移除；其他元素的 index 都比 `left` 大，還在窗口裡。

## 複雜度

時間 `O(n)`：每個 index 最多進出每個隊列各一次。空間 `O(n)`。

## 要特別避免的錯誤

- 每次都對窗口取 `max()` 和 `min()`：`O(n^2)`。
- 單調隊列存值而不是 index：沒辦法判斷隊首是不是已經離開窗口。
- 計數用 `+1` 而不是 `+ (right - left + 1)`：要數的是所有以 `right` 結尾的子陣列。

## 面試口說整理

條件等價於窗口最大值減最小值不超過 2，而且合法子陣列的子陣列也合法，所以用滑動窗口。我維護兩個存 index 的單調隊列，一個遞減、一個遞增，隊首分別是窗口最大值和最小值。右端每加入一個數，就把左端推到窗口合法為止，再加上以 `right` 結尾的子陣列數 `right - left + 1`。每個 index 進出隊列各一次，時間 `O(n)`。
