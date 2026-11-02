---
title: "LeetCode 4099: Minimum Operations to Sort With Locked Indices"
summary: "LeetCode 4099 解題筆記：交換次數就是逆序數；有元素要跨過的上鎖位置一定要解鎖，數出來和 k 比，加上 merge sort 算的逆序數"
description: "2026-11-02 的 LeetCode 4099 解題紀錄"
date: 2026-11-02
tags: ["medium", "array", "merge-sort", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-11-02
- 提交紀錄：Accepted ×2

## 解題思路

兩部分分開算：

**1. 交換次數**：只能交換相鄰元素時，排好序最少要的交換次數就是**逆序數**，只要需要的位置都解鎖了就做得到。逆序數用 merge sort 算（[Merge Sort]({{< relref "/algorithm/Merge-Sort" >}})），`O(n log n)`。

**2. 一定要解鎖的位置**：位置 `i` 上鎖時，任何元素都不能跨過它。`nums[i]` 的值大於 `i + 1` 代表它要往右移到 `nums[i] - 1`，路上 `i` 到 `nums[i] - 1` 這段都必須解鎖。所以掃一遍，維護目前最遠要解鎖到哪裡 `reach`，上鎖而且在 `reach` 範圍內的位置就要解鎖。

往左移的元素不用另外處理：位置 `i` 上的值如果小於 `i + 1`，前 `i + 1` 個位置裡一定有某個值大於 `i`，它要往右跨過 `i`，已經被算到了。

必須解鎖的數量超過 `k` 就回傳 -1；否則答案是解鎖數加逆序數。

## 我的嘗試

兩次都一次通過。第一版的 merge sort 是包含右端點的寫法，另外複製陣列；第二版改成半開區間、直接在 `nums` 上排序，和 LC 493 用的模板一樣。

## 正確解法

```python
class Solution:
    def minOperations(self, nums: List[int], locked: List[int], k: int) -> int:
        unlocks = 0
        reach = -1
        for i, num in enumerate(nums):
            if num > i + 1:
                reach = max(reach, num - 1)
            if locked[i] and i <= reach:
                unlocks += 1
        if unlocks > k:
            return -1

        temp = [0] * len(nums)

        def sort_count(lo, hi):
            if hi - lo <= 1:
                return 0
            mid = (lo + hi) // 2
            count = sort_count(lo, mid) + sort_count(mid, hi)
            i, j, t = lo, mid, lo
            while i < mid or j < hi:
                if j >= hi or (i < mid and nums[i] <= nums[j]):
                    temp[t] = nums[i]
                    i += 1
                else:
                    temp[t] = nums[j]
                    count += mid - i
                    j += 1
                t += 1
            nums[lo:hi] = temp[lo:hi]
            return count

        return unlocks + sort_count(0, len(nums))
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。`n` 只到 2000，`O(n^2)` 直接數逆序數也會過，但題目要求 `O(n log n)`。

## 要特別避免的錯誤

- 解鎖數要先算，因為 merge sort 會把 `nums` 排好序。
- 位置 `i` 自己的值要往右移時，`i` 本身也要解鎖（範圍包含 `i`）。
- 交換和解鎖都算操作次數，兩個要相加。

## 面試口說整理

相鄰交換的最少次數是逆序數，我用 merge sort 在 `O(n log n)` 算。另外，有元素要跨過的上鎖位置一定要解鎖：掃一遍，值大於 `i + 1` 的元素要往右移到 `num - 1`，維護最遠要解鎖到哪，在範圍內的上鎖位置都要解。往左移的元素一定伴隨某個往右跨的元素，所以不用另外算。解鎖數超過 `k` 回傳 -1，否則答案是解鎖數加逆序數。
