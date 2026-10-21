---
title: "LeetCode 1046: Last Stone Weight"
summary: "LeetCode 1046 解題筆記：max-heap（存負數）每次拿出最重的兩顆，不一樣重就把差放回去，最後剩一顆或沒有"
description: "2022-09-30 的 LeetCode 1046 解題紀錄"
date: 2022-09-30
tags: ["easy", "array", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-30
- 提交紀錄：Wrong Answer → Runtime Error → Accepted → Runtime Error → Wrong Answer → Accepted → Runtime Error → Accepted ×2

## 解題思路

每次都要最重的兩顆，用 max-heap（[Heap]({{< relref "/algorithm/Heap" >}})，Python 存負數）。拿出 `y >= x`，不相等就放回 `y - x`。存的是負數時，`-a`、`-b` 拿出來後**差的正負號要注意**：`a - b`（兩個負數相減，較重的先出來）會是負的，剛好就是要放回去的負數。最後 heap 空了回傳 0。

## 我的嘗試

這題寫了四次（2022-09、2022-11 兩次、2025），錯了 5 次：

- 2022-09 第一版放回 `x - y`，**存的是負數，這個差是正的**，被當成很輕的石頭：`[2, 7]` 回傳 -5，答案 5。改成 `y - x` 之後，兩顆一樣重全部消掉時 `h[0]` 超出範圍（IndexError）。
- 2022-11 重寫時，條件寫反成 `if heaviest != second_heaviest: continue`，**不一樣重的反而直接丟掉**：`[2, 7]` 回傳 0。另外兩次是 heap 空了的 IndexError。

## 正確解法

```python
class Solution:
    def lastStoneWeight(self, stones: List[int]) -> int:
        h = [-s for s in stones]
        heapq.heapify(h)
        while len(h) > 1:
            a = heapq.heappop(h)
            b = heapq.heappop(h)
            if a != b:
                heapq.heappush(h, a - b)
        return -h[0] if h else 0
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 存負數時差的正負號要對：放回去的也要是負數。
- 最後可能一顆都不剩，要回傳 0。

## 面試口說整理

每次都要最重的兩顆，我用存負數的 max-heap，拿出兩顆，不一樣重就把差放回去，最後剩一顆就回傳它，沒有就回傳 0。時間 `O(n log n)`。
