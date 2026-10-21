---
title: "LeetCode 463: Island Perimeter"
summary: "LeetCode 463 解題筆記：每格陸地貢獻 4 條邊，每跟上方或左方的陸地相鄰一次就少 2 條"
description: "2022-08-24 的 LeetCode 463 解題紀錄"
date: 2022-08-24
tags: ["easy", "array", "depth-first-search", "breadth-first-search", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-24
- 提交紀錄：Runtime Error ×6 → Wrong Answer ×3 → Runtime Error → Accepted → Runtime Error → Accepted ×2

## 解題思路

不用 DFS（[BFS]({{< relref "/algorithm/BFS" >}}) 模板二）。每格陸地有 4 條邊；兩格相鄰時共用的那條邊兩邊都不算，周長少 2。每格只檢查**上方和左方**，每對相鄰的格子就只會扣一次。

## 我的嘗試

這題 2022-08 錯了 11 次：

- 前幾版邊界沒檢查，`grid[row - 1]` 在第一列時繞到最後一列，或者 `row + 1` 超出範圍。
- 接下來兩版**檢查了對角線**（`grid[row + 1][s + 1]`、`grid[row - 1][s - 1]`），每個相鄰只扣 1：第一版沒檢查邊界，單獨一格 `[[1]]` 讀到 `grid[-1][-1]`（自己）回傳 2；第二版補上邊界後，`[[1, 1]]` 回傳 8，答案 6。
- 2024 年重寫成「每格 +4、跟上方左方相鄰各 -2」才 AC。

## 正確解法

```python
class Solution:
    def islandPerimeter(self, grid: List[List[int]]) -> int:
        res = 0
        for i in range(len(grid)):
            for j in range(len(grid[0])):
                if grid[i][j]:
                    res += 4
                    if i and grid[i - 1][j]:
                        res -= 2
                    if j and grid[i][j - 1]:
                        res -= 2
        return res
```

## 複雜度

時間 `O(mn)`，空間 `O(1)`。

## 要特別避免的錯誤

- 相鄰只看上下左右，不看對角線。
- 每對相鄰扣 2，只檢查上方和左方避免重複。
- `grid[i - 1]` 在 `i = 0` 時是最後一列，要先檢查 `i > 0`。

## 面試口說整理

每格陸地有四條邊，跟另一格陸地相鄰時共用的邊兩邊都不算，周長少二。我每格只看上方和左方，避免重複扣。時間 `O(mn)`、空間 `O(1)`。
