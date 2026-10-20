---
title: "LeetCode 3493: Properties Graph"
summary: "LeetCode 3493 解題筆記：先把每列轉成 set，兩兩比較交集大小建邊，再數連通塊"
description: "2025-03-23 的 LeetCode 3493 解題紀錄"
date: 2025-03-23
tags: ["medium", "graph", "dfs", "union-find", "hash-map"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-03-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩列 `i`、`j` 之間有邊，條件是它們的**相異數字**交集至少 `k` 個。建好圖之後數連通塊。

`n, m <= 100`，兩兩比較是 `O(n^2)` 對，每對算交集 `O(m)`，總共 `10^6` 等級，夠快。

## 我的解法

```python
class Solution:
    def numberOfComponents(self, properties: List[List[int]], k: int) -> int:
        n = len(properties)
        sets = [set(p) for p in properties]       # 先轉一次 set，不要每次比較都重轉

        parent = list(range(n))

        def find(x: int) -> int:
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        components = n
        for i in range(n):
            for j in range(i + 1, n):
                if len(sets[i] & sets[j]) >= k:
                    ri, rj = find(i), find(j)
                    if ri != rj:
                        parent[ri] = rj
                        components -= 1
        return components
```

原本的版本建鄰接表再用遞迴 DFS 數連通塊，結果一樣。有兩個地方可以改：

- `intersect(a, b)` 每次比較都重新 `set(a)`、`set(b)`，同一列會被轉換 `n` 次。先轉一次存起來就好。
- `graph[i] = graph.get(i, []) + [j]` 每次都建一個新 list，鄰接表越長越慢；用 `append` 就好。

這裡直接改用 Union-Find，邊算邊合併，不用建鄰接表。

## 複雜度

時間 `O(n^2 · m)`，空間 `O(n · m)`。

## 要特別避免的錯誤

- 交集用原本的 list 算：要先去重，題目算的是**相異**數字。
- 每次比較都重新建 set。
- 用 `list + [x]` 累加鄰接表。

## 面試口說整理

我先把每列轉成 set，兩兩比較交集大小，至少 `k` 就把兩列用 Union-Find 合併，每次真的合併兩塊就把連通塊數減 1。`n` 和 `m` 都只有 100，兩兩比較的 `O(n^2 m)` 足夠快。
