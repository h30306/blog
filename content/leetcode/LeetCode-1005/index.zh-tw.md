---
title: "LeetCode 1005: Maximize Sum Of Array After K Negations"
summary: "LeetCode 1005 解題筆記：每次把最小的數變號；最小的已經是正數時，剩下的次數只要看奇偶"
description: "2022-09-27 的 LeetCode 1005 解題紀錄"
date: 2022-09-27
tags: ["easy", "array", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-27
- 提交紀錄：Runtime Error → Accepted

## 解題思路

貪心（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一）：每次把目前最小的數變號，總和增加最多。用 min-heap 做 `k` 次 `heappop`、`heappush(-x)` 就好，`O(k log n)`。也可以排序後先把負數由小到大變號，剩下的次數是奇數時，再把絕對值最小的那個變號一次。

## 我的嘗試

第一版縮排錯誤（Runtime Error），修好之後同樣的 min-heap 寫法就 AC 了。

## 正確解法

```python
class Solution:
    def largestSumAfterKNegations(self, nums: List[int], k: int) -> int:
        heapq.heapify(nums)
        for _ in range(k):
            heapq.heappush(nums, -heapq.heappop(nums))
        return sum(nums)
```

## 複雜度

時間 `O(n + k log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 同一個數可以被變號很多次，最小的是正數時會來回變號，所以 heap 寫法自然處理了奇偶。

## 面試口說整理

每次把最小的數變號能讓總和增加最多，我用 min-heap 做 k 次，取出最小的變號後放回去，最後加總。最小的是正數時會在同一個數上來回變號，等於只看剩下次數的奇偶。時間 `O(n + k log n)`。
