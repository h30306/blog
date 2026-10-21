---
title: "LeetCode 347: Top K Frequent Elements"
summary: "LeetCode 347 解題筆記：先計數，再用大小為 k 的 heap 或 bucket sort（次數當 index）取出次數最多的 k 個"
description: "2022-10-27 的 LeetCode 347 解題紀錄"
date: 2022-10-27
tags: ["medium", "array", "hash-table", "divide-and-conquer", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-27
- 提交紀錄：Runtime Error → Accepted ×2

## 解題思路

先用 `Counter` 計數。取次數最多的 `k` 個：

- 大小為 `k` 的 min-heap，以次數比較（[Heap]({{< relref "/algorithm/Heap" >}}) 模板一），`O(n log k)`。
- Bucket sort（[Bucket Sort]({{< relref "/algorithm/Bucket-Sort" >}})）：次數最多是 `n`，開 `n + 1` 個桶，`bucket[c]` 放次數是 `c` 的數，從大的桶往下收集到 `k` 個，`O(n)`。

## 我的嘗試

第一版寫成 `Counter(nums).most_common().keys()`，`most_common()` 回傳的是 list（AttributeError）。改成 `[x for x, _ in Counter(nums).most_common(k)]` 就 AC 了，這是 `O(n log n)`。

## 正確解法

```python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        cnt = Counter(nums)
        buckets = [[] for _ in range(len(nums) + 1)]
        for x, c in cnt.items():
            buckets[c].append(x)
        res = []
        for c in range(len(nums), 0, -1):
            res += buckets[c]
            if len(res) >= k:
                return res[:k]
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `most_common()` 回傳的是 list，沒有 `.keys()`。
- 題目要求比 `O(n log n)` 快，直接排序不符合進階要求。

## 面試口說整理

我先計數，次數最多是 n，所以開 n + 1 個桶，把每個數放進它次數的桶，再從次數最大的桶往下收集到 k 個。時間 `O(n)`；也可以用大小為 k 的 heap，`O(n log k)`。
