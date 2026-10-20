---
title: "LeetCode 1878: Get Biggest Three Rhombus Sums in a Grid"
summary: "LeetCode 1878 解題筆記：枚舉每個頂點和大小，沿四條邊走一圈加總，取前三大的不同值"
description: "2026-06-23 的 LeetCode 1878 解題紀錄"
date: 2026-06-23
tags: ["medium", "matrix", "enumeration", "heap"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

菱形以**上方頂點** `(i, j)` 和大小 `l` 決定，四個頂點分別是：

```text
上 (i, j)、右 (i + l, j + l)、下 (i + 2l, j)、左 (i + l, j - l)
```

只要四個頂點都在格子裡就是合法的菱形。大小 0 的菱形就是單一格子。

`m, n <= 50`，直接枚舉每個上頂點和每個大小，沿著四條邊走一圈把邊框加總就好。

答案要「前三大的**不同**值」，所以用 set 去重後排序取前三。

## 我的解法

```python
class Solution:
    def getBiggestThree(self, grid: List[List[int]]) -> List[int]:
        m, n = len(grid), len(grid[0])
        sums = set()
        for i in range(m):
            for j in range(n):
                sums.add(grid[i][j])                       # 大小 0
                l = 1
                while i + 2 * l < m and j - l >= 0 and j + l < n:
                    total = 0
                    r, c = i, j
                    for dr, dc in ((1, 1), (1, -1), (-1, -1), (-1, 1)):
                        for _ in range(l):                 # 每條邊走 l 步
                            total += grid[r][c]
                            r += dr
                            c += dc
                    sums.add(total)
                    l += 1
        return sorted(sums, reverse=True)[:3]
```

每條邊走 `l` 步、從起點開始算，四條邊剛好把 `4l` 個邊框格子各加一次，回到起點時不會重複。

原本的版本把四條邊寫成四個獨立的迴圈，邏輯一樣；這裡用方向陣列合併。

## 複雜度

時間 `O(m * n * min(m, n)^2)`：每個頂點最多 `min(m, n)` 種大小，每個菱形走 `O(l)` 步。空間 `O(m * n * min(m, n))`，存所有不同的和。

如果要更快，可以用兩條對角線方向的前綴和，讓每條邊 `O(1)` 算出來，總時間降到 `O(m * n * min(m, n))`。另外只需要前三大，也可以用大小 3 的 min-heap 取代整個 set。

## 要特別避免的錯誤

- 漏掉大小為 0 的菱形。
- 四條邊各走 `l + 1` 步：頂點會被重複加。
- 回傳時沒有去重：題目要的是不同的值。

## 面試口說整理

菱形由上頂點和大小決定，`m` 和 `n` 都不超過 50，所以我枚舉每個上頂點和每個合法大小，用四個方向沿邊框各走 `l` 步加總，這樣每個邊框格子剛好加一次。大小 0 就是格子本身。所有和放進 set 去重，排序後取前三。如果要優化，可以用對角線前綴和讓每條邊 `O(1)`。
