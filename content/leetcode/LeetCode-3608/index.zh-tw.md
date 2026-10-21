---
title: "LeetCode 3608: Minimum Time for K Connected Components"
summary: "LeetCode 3608 解題筆記：倒過來從時間大的邊開始加回去，第一次讓連通塊數少於 k 的那條邊的時間就是答案"
description: "2025-07-06 的 LeetCode 3608 解題紀錄"
date: 2025-07-06
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
第一次嘗試：2025-07-06
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

刪掉所有時間 `<= t` 的邊之後，留下的是時間 `> t` 的邊。`t` 越大留下越少，塊數越多，所以有單調性，可以二分；但更直接的是**倒過來加邊**（[Union-Find]({{< relref "/algorithm/Union-Find" >}}) 的「邊依權重排序」）：

- 邊依時間由大到小加進 Union-Find。
- 加某條時間 `t` 的邊之前，圖裡只有時間 `>= t` 的邊，塊數還 `>= k`。
- 加完這條邊，塊數第一次 `< k`：代表只要保留它，塊數就不夠，所以 `t` 這條邊一定要刪，答案是 `t`。
- 全部加完都還 `>= k`，代表一條都不用刪，答案是 0。

## 我的嘗試

第一版的 `union` 寫成 `parent[x] = root_y`，**接的是節點 `x`，不是它的根**。例如 `n = 3`、`edges = [[0, 2, 3], [0, 1, 6], [2, 1, 1]]`、`k = 1`：本來就只有 1 塊，答案是 0。

依時間由大到小，先合併 0 和 1（`parent[0] = 1`），再合併 0 和 2 時把 `parent[0]` 改成 2，**1 被留在原地**。最後合併 2 和 1 時兩個根不同，又算了一次合併，塊數變成 0，回傳 1。改成 `parent[root_x] = root_y` 就 AC 了。

## 正確解法

```python
class Solution:
    def minTime(self, n: int, edges: List[List[int]], k: int) -> int:
        parent = list(range(n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        groups = n
        for u, v, t in sorted(edges, key=lambda e: -e[2]):
            ru, rv = find(u), find(v)
            if ru != rv:
                parent[ru] = rv
                groups -= 1
                if groups < k:
                    return t
        return 0
```

## 複雜度

時間 `O(E log E + E · α(n))`，空間 `O(n)`。

## 要特別避免的錯誤

- `union` 要把**根**接到另一個根上。
- 塊數只會在真的合併時減少，同一塊裡的邊不用算。

## 面試口說整理

刪除不好做，所以我倒過來，依時間由大到小把邊加回去。加某條邊之前圖裡只有時間更大的邊，塊數還夠；加完之後第一次不夠，就代表這條邊一定要刪，答案是它的時間。全部加完都夠就回傳 0。時間 `O(E log E)`。
