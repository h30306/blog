---
title: "LeetCode 3613: Minimize Maximum Component Cost"
summary: "LeetCode 3613 解題筆記：邊由小到大加進 Union-Find，剛好剩 k 塊時那條邊的權重就是答案；n <= k 時回傳 0"
description: "2025-07-13 的 LeetCode 3613 解題紀錄"
date: 2025-07-13
tags: ["medium", "union-find", "graph", "sorting", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-13
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

答案 `W` 代表「只保留權重 `<= W` 的邊，塊數 `<= k`」。保留的邊越多塊數越少，所以由小到大加邊（Kruskal，[Union-Find]({{< relref "/algorithm/Union-Find" >}}) 的「邊依權重排序」），第一次塊數降到 `k` 時的邊權就是最小的 `W`。

- 只有真的合併兩塊的邊會讓塊數減 1；同一塊裡的邊不影響答案。
- `n <= k` 時一開始就符合條件，把所有邊刪掉，答案是 0。題目保證圖是連通的，所以一定能降到 `k`。

## 我的嘗試

第一版少了 `n == k` 的情況：塊數一開始就是 `k`，迴圈裡合併後都 `< k`，永遠不會剛好等於 `k`，函式沒有回傳值。例如 `n = 1`、`edges = []`、`k = 1`：答案是 0，這版回傳 `None`。加上特判就 AC 了。

## 正確解法

```python
class Solution:
    def minCost(self, n: int, edges: List[List[int]], k: int) -> int:
        if n <= k:
            return 0
        parent = list(range(n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        groups = n
        for u, v, w in sorted(edges, key=lambda e: e[2]):
            ru, rv = find(u), find(v)
            if ru != rv:
                parent[ru] = rv
                groups -= 1
                if groups == k:
                    return w
```

## 複雜度

時間 `O(E log E + E · α(n))`，空間 `O(n)`。

## 要特別避免的錯誤

- 一開始就符合條件的情況要先處理。
- 用 `groups == k` 判斷時，要確定每次只減 1、一定會經過 `k`。

## 面試口說整理

我把邊由小到大加進 Union-Find，每真的合併一次塊數就減 1。第一次剩 `k` 塊時，用到的最大邊就是那條，答案就是它的權重。`n <= k` 時一條邊都不用留，回傳 0。時間 `O(E log E)`。
