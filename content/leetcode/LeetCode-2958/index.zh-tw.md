---
title: "LeetCode 2958: Length of Longest Subarray With at Most K Frequency"
summary: "LeetCode 2958 解題筆記：「求最長」的滑動視窗，剛加入的數字出現超過 k 次就縮左邊"
description: "2026-01-10 的 LeetCode 2958 解題紀錄"
date: 2026-01-10
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

跟 [LeetCode 3090]({{< relref "/leetcode/LeetCode-3090" >}}) 同一個模板，只是上限從 2 變成 `k`、字元換成整數。

右邊界加入 `x` 後，只有 `x` 可能超過 `k` 次，縮左邊直到它回到 `k` 次。

## 我的解法

```python
class Solution:
    def maxSubarrayLength(self, nums: List[int], k: int) -> int:
        cnt = Counter()
        left = best = 0
        for right, x in enumerate(nums):
            cnt[x] += 1
            while cnt[x] > k:
                cnt[nums[left]] -= 1
                left += 1
            best = max(best, right - left + 1)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 縮視窗的條件寫成檢查左邊的元素：要看的是剛加入的 `x`。

## 面試口說整理

求最長的滑動視窗，每個數字最多 `k` 次。右邊加入 `x` 之後，只有 `x` 可能超過，所以縮左邊直到 `x` 回到 `k` 次，記錄最長長度。時間 `O(n)`。
