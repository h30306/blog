---
title: "LeetCode 703: Kth Largest Element in a Stream"
summary: "LeetCode 703 解題筆記：維持一個大小為 k 的最小堆，堆頂就是第 k 大"
description: "2022-08-31 的 LeetCode 703 解題紀錄"
date: 2022-08-31
tags: ["easy", "tree", "design", "binary-search-tree", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-31
- 提交紀錄：Accepted（一次通過）

## 解題思路

只要記住目前最大的 `k` 個數。用最小堆（[Heap]({{< relref "/algorithm/Heap" >}}) 模板一），超過 `k` 個就把最小的彈掉，堆頂就是這 `k` 個裡最小的，也就是第 `k` 大。

## 我的解法

```python
class KthLargest:
    def __init__(self, k: int, nums: List[int]):
        self.k, self.heap = k, []
        for x in nums:
            self.add(x)

    def add(self, val: int) -> int:
        heapq.heappush(self.heap, val)
        if len(self.heap) > self.k:
            heapq.heappop(self.heap)
        return self.heap[0]
```

## 複雜度

每次 `add` 是 `O(log k)`，空間 `O(k)`。

## 要特別避免的錯誤

- 初始的 `nums` 可能少於 `k` 個，所以不能在建構時就假設堆是滿的。

## 面試口說整理

我維持一個大小最多 `k` 的最小堆，加入新的數之後如果超過 `k` 個就彈出最小的，堆頂就是第 `k` 大。每次 `O(log k)`。
