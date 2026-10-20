---
title: "LeetCode 2968: Apply Operations to Maximize Frequency Score"
summary: "LeetCode 2968 解題筆記：排序後，把一段全部變成同一個值，最省的目標是中位數；用前綴和 O(1) 算花費，花費隨視窗變大而變大，可以滑動"
description: "2026-01-18 的 LeetCode 2968 解題紀錄"
date: 2026-01-18
tags: ["hard", "sliding-window", "sorting", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-18
- 提交紀錄：Accepted（一次通過）

## 解題思路

跟 [LeetCode 1838]({{< relref "/leetcode/LeetCode-1838" >}}) 很像，但這題可以加也可以減。

1. 要變成同一個值的那些數，排序後一定是**連續的一段**。
2. 把一段數都變成同一個值，花費是 `Σ |x - target|`，**最省的 `target` 是中位數**。
3. 用前綴和 `O(1)` 算花費，`mid = (left + right) // 2`：

```text
左半：nums[mid] × (mid - left + 1) − sum(nums[left..mid])
右半：sum(nums[mid+1..right]) − nums[mid] × (right - mid)
```

視窗變大時花費不會變小，所以用「求最長」的滑動視窗：花費 `> k` 就縮左邊。

## 我的解法

```python
class Solution:
    def maxFrequencyScore(self, nums: List[int], k: int) -> int:
        nums.sort()
        prefix = [0]
        for x in nums:
            prefix.append(prefix[-1] + x)

        def cost(lo: int, hi: int) -> int:         # 把 nums[lo..hi] 都變成中位數
            mid = (lo + hi) // 2
            target = nums[mid]
            left_cost = target * (mid - lo + 1) - (prefix[mid + 1] - prefix[lo])
            right_cost = (prefix[hi + 1] - prefix[mid + 1]) - target * (hi - mid)
            return left_cost + right_cost

        left = best = 0
        for right in range(len(nums)):
            while cost(left, right) > k:
                left += 1
            best = max(best, right - left + 1)
        return best
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 目標值用平均數：絕對值總和的最小值在中位數，不是平均數。
- 每次重新加總視窗：要用前綴和。

## 面試口說整理

要變成同一個值的數，排序後一定是連續的一段，而絕對值總和最小的目標是中位數。我用前綴和 `O(1)` 算把一段變成中位數的花費，這個花費隨視窗變大而變大，所以用滑動視窗，超過 `k` 就縮左邊。時間由排序決定，`O(n log n)`。
