---
title: "LeetCode 2962: Count Subarrays Where Max Element Appears at Least K Times"
summary: "LeetCode 2962 解題筆記：「至少 k 次」的計數視窗：最大值出現 k 次時一直縮左邊，縮完後左端在 [0, left) 的子陣列都合法，count += left"
description: "2026-01-19 的 LeetCode 2962 解題紀錄"
date: 2026-01-19
tags: ["medium", "sliding-window", "array"]
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

最大值 `mx` 是整個陣列的最大值，固定不變。視窗裡 `mx` 出現的次數越多越好，「至少 `k` 次」是單調的：視窗合法，往左延伸也一定合法。

「至少 K」的計數寫法：

- 右端加入，`mx` 出現 `k` 次時**一直縮左邊**，縮到剛好不到 `k` 次。
- 這時左端放在 `[0, left)` 的任何位置，子陣列都至少有 `k` 個 `mx`，所以 `count += left`。

## 我的解法

```python
class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        mx = max(nums)
        left = seen = count = 0
        for x in nums:
            seen += x == mx
            while seen >= k:                       # 合法就縮，縮到剛好不合法
                seen -= nums[left] == mx
                left += 1
            count += left                          # 左端在 [0, left) 都合法
        return count
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用 `right - left + 1`：那是「最多」型的計數，這題是「至少」。
- 最大值是**整個陣列**的最大值，不是視窗的。

## 面試口說整理

最大值固定是整個陣列的最大值，出現至少 `k` 次是單調的。我用滑動視窗，最大值出現 `k` 次時就一直縮左邊，縮到剛好不夠為止，這時左端在 0 到 `left - 1` 的子陣列都合法，所以加上 `left`。時間 `O(n)`。
