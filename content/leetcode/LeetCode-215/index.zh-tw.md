---
title: "LeetCode 215: Kth Largest Element in an Array"
summary: "LeetCode 215 解題筆記：維持大小為 k 的 min-heap，堆頂就是第 k 大；或用 quickselect 平均 O(n)"
description: "2022-10-29 的 LeetCode 215 解題紀錄"
date: 2022-10-29
tags: ["medium", "array", "divide-and-conquer", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-29
- 提交紀錄：Wrong Answer ×3 → Output Limit Exceeded → Accepted ×3

## 解題思路

Top-K（[Heap]({{< relref "/algorithm/Heap" >}}) 模板一）：用 min-heap 存目前最大的 `k` 個數。heap 還沒滿就 `push`；滿了就 `heappushpop`，新的數比堆頂小時會馬上被彈出，比較大時會取代堆頂。掃完之後堆頂就是第 `k` 大，`O(n log k)`。另一種是 quickselect：用 partition 只往答案所在的那一邊遞迴，平均 `O(n)`。

## 我的嘗試

前三版的條件寫成 `if len(heap) > k: heappop else: heappush`：heap 會先長到 `k + 1` 個，之後**遇到新的數只彈出、沒有把它放進去**，最後回傳的也不是第 `k` 大：`[1, 7]`、`k = 1` 回傳 1，答案 7。接著一版留了 `print`（Output Limit Exceeded），改成 `len(heap) == k` 時 `heappushpop` 才 AC。

## 正確解法

```python
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        heap = []
        for x in nums:
            if len(heap) < k:
                heapq.heappush(heap, x)
            else:
                heapq.heappushpop(heap, x)
        return heap[0]
```

## 複雜度

時間 `O(n log k)`，空間 `O(k)`。

## 要特別避免的錯誤

- heap 滿了之後也要處理新的數：先放進去再彈出最小的，不能直接跳過。
- 大小上限是 `k`，條件寫成 `> k` 會多存一個。

## 面試口說整理

我用一個大小為 k 的 min-heap 存目前最大的 k 個數，滿了之後每個新的數都 pushpop，堆頂就是這 k 個裡最小的，也就是第 k 大。時間 `O(n log k)`；quickselect 可以做到平均 `O(n)`。
