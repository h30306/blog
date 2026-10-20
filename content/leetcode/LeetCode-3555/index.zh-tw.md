---
title: "LeetCode 3555: Smallest Subarray to Sort in Every Sliding Window"
summary: "LeetCode 3555 解題筆記：每個長度 k 的視窗都是一次 LeetCode 581；n 只有 1000，對每個視窗跑 O(k) 的兩次掃描即可"
description: "2026-01-29 的 LeetCode 3555 解題紀錄"
date: 2026-01-29
tags: ["medium", "two-pointers", "greedy", "sorting", "array", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-29
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個視窗要回答的問題，就是 [LeetCode 581]({{< relref "/leetcode/LeetCode-581" >}})：最短要排序哪一段，整個視窗才會非遞減。

- 從左往右記最大值，最後一個 `< 最大值` 的位置是右界。
- 從右往左記最小值，最後一個 `> 最小值` 的位置是左界。

`n <= 1000`，共 `n - k + 1` 個視窗，每個 `O(k)`，總共最多約 `n^2 / 4` 次運算，夠快。

## 我的解法

```python
class Solution:
    def minSubarraySort(self, nums: List[int], k: int) -> List[int]:
        def unsorted_len(lo: int, hi: int) -> int:     # nums[lo..hi] 的 581
            max_seen, end = float("-inf"), -1
            for i in range(lo, hi + 1):
                if nums[i] < max_seen:
                    end = i
                else:
                    max_seen = nums[i]
            if end == -1:
                return 0
            min_seen, start = float("inf"), -1
            for i in range(hi, lo - 1, -1):
                if nums[i] > min_seen:
                    start = i
                else:
                    min_seen = nums[i]
            return end - start + 1

        return [unsorted_len(i, i + k - 1) for i in range(len(nums) - k + 1)]
```

原本的版本每個視窗用切片 `nums[i:i + k]` 複製一份再算，這裡改成直接傳索引，省掉複製。

## 複雜度

時間 `O((n - k + 1) · k)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 已經排好的視窗要回傳 0。
- 視窗的左界、右界要用視窗內的索引範圍，不是整個陣列。

## 面試口說整理

每個視窗就是一次 581：從左往右記最大值找右界，從右往左記最小值找左界。`n` 只有 1000，所以對每個視窗做兩次 `O(k)` 掃描，總共 `O(n · k)`。如果 `n` 很大，就要想辦法在視窗滑動時增量維護邊界。
