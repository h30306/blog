---
title: "LeetCode 410: Split Array Largest Sum"
summary: "LeetCode 410 解題筆記：對答案二分搜尋；給定上限 mid，貪心地能塞就塞，數出最少要切幾段，段數 <= k 就表示 mid 可行"
description: "2026-08-26 的 LeetCode 410 解題紀錄"
date: 2026-08-26
tags: ["hard", "dynamic-programming", "binary-search", "greedy", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-26
- 提交紀錄：Accepted（一次通過）

## 解題思路

這題可以用切 `k` 段的分割 DP（`O(k · n^2)`），但有更快的做法：**對答案二分搜尋**。

答案（最大段的和）有單調性：上限 `mid` 越大，越容易切成 `k` 段以內。給定 `mid`：

- **貪心**：從左往右，能塞進目前這段就塞，塞不下就開新的一段。這樣切出來的段數是最少的。
- 段數 `<= k`：`mid` 可行，往小找。否則往大找。

搜尋範圍：下界是 `max(nums)`（每段至少要放得下最大的那個），上界是 `sum(nums)`（只切一段）。

段數比 `k` 少也沒關係：可以把某些段再拆開，最大值不會變大（數字都非負）。

## 我的解法

```python
class Solution:
    def splitArray(self, nums: List[int], k: int) -> int:
        def pieces(limit: int) -> int:             # 每段不超過 limit 時，最少切幾段
            count, cur = 1, 0
            for x in nums:
                if cur + x > limit:
                    count += 1
                    cur = 0
                cur += x
            return count

        lo, hi = max(nums), sum(nums)
        while lo < hi:
            mid = (lo + hi) // 2
            if pieces(mid) <= k:
                hi = mid                           # 可行，試更小的
            else:
                lo = mid + 1
        return lo
```

## 複雜度

時間 `O(n log(sum))`，空間 `O(1)`。

## 要特別避免的錯誤

- 下界用 0 或 1：上限比最大的數還小時，那個數放不進任何一段，貪心會算錯。
- 可行時是 `hi = mid`，不是 `mid - 1`：`mid` 本身可能就是答案。

## 面試口說整理

最大段的和有單調性：上限越大越容易切成 `k` 段以內，所以我對答案二分搜尋。給定上限，從左往右能塞就塞，塞不下就開新的一段，得到最少段數；段數不超過 `k` 就往小找。下界是最大的數，上界是總和。時間 `O(n log(sum))`。也可以用切 `k` 段的 DP，但比較慢。
