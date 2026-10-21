---
title: "LeetCode 973: K Closest Points to Origin"
summary: "LeetCode 973 解題筆記：跟 Top-K 一樣，用大小為 k 的 max-heap（存負的距離）保留最近的 k 個點"
description: "2022-10-29 的 LeetCode 973 解題紀錄"
date: 2022-10-29
tags: ["medium", "array", "math", "divide-and-conquer", "geometry"]
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
- 提交紀錄：Runtime Error → Accepted

## 解題思路

要最近的 `k` 個，就維持一個大小為 `k`、堆頂是「目前最遠」的 heap（[Heap]({{< relref "/algorithm/Heap" >}}) 模板一）。Python 只有 min-heap，所以存 `-(x² + y²)`。heap 滿了之後 `heappushpop`，比堆頂更遠的點會馬上被彈出。距離比較用平方就好，不用開根號。

## 我的嘗試

第一版用了舊版題目的參數名稱 `K`（NameError），改成 `k` 就 AC 了。

## 正確解法

```python
class Solution:
    def kClosest(self, points: List[List[int]], k: int) -> List[List[int]]:
        heap = []
        for x, y in points:
            item = (-(x * x + y * y), x, y)
            if len(heap) < k:
                heapq.heappush(heap, item)
            else:
                heapq.heappushpop(heap, item)
        return [[x, y] for _, x, y in heap]
```

## 複雜度

時間 `O(n log k)`，空間 `O(k)`。

## 要特別避免的錯誤

- 要保留最近的，所以 heap 的堆頂要是最遠的：存負的距離。
- 比較平方距離就好。

## 面試口說整理

我維持一個大小為 k 的 heap，存負的平方距離，所以堆頂是目前最遠的點；滿了之後每個新點都 pushpop，最後留下的就是最近的 k 個。時間 `O(n log k)`。
