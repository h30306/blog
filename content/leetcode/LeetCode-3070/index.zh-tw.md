---
title: "LeetCode 3070: Count Submatrices with Top-Left Element and Sum Less Than k"
summary: "LeetCode 3070 解題筆記：包含左上角的子矩陣就是二維前綴和 P[i][j]，數有幾個 <= k"
description: "2024-03-03 的 LeetCode 3070 解題紀錄"
date: 2024-03-03
tags: ["medium", "array", "matrix", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2024-03-03
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

包含 `(0, 0)` 的子矩陣由右下角 `(i, j)` 決定，總和就是二維前綴和 `P[i][j] = grid[i][j] + P[i - 1][j] + P[i][j - 1] - P[i - 1][j - 1]`（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})）。**要減掉重複加的左上角 `P[i - 1][j - 1]`**。數有幾個 `P[i][j] <= k`。

## 我的嘗試

2024 年比賽時錯了兩次：

- 第一版原地累加上面和左邊，**沒有減掉左上角**，重疊的部分算了兩次：`[[1, 0], [4, 4]]`、`k = 9` 右下角算成 10，回傳 3，答案 4。
- 改成先算每一列的前綴和、再加上上一列的結果（等於沒有重複），但條件寫成 `< k`：`[[3]]`、`k = 3` 回傳 0。改成 `<=` 就 AC 了。

## 正確解法

```python
class Solution:
    def countSubmatrices(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        P = [[0] * (n + 1) for _ in range(m + 1)]
        count = 0
        for i in range(m):
            for j in range(n):
                P[i + 1][j + 1] = grid[i][j] + P[i][j + 1] + P[i + 1][j] - P[i][j]
                count += P[i + 1][j + 1] <= k
        return count
```

## 複雜度

時間 `O(mn)`，空間 `O(mn)`。

## 要特別避免的錯誤

- 二維前綴和要減掉左上角，不然重疊的部分算了兩次。
- 條件是 `<= k`。

## 面試口說整理

包含左上角的子矩陣就是以每一格為右下角的二維前綴和，我用上面加左邊減左上角的公式算出來，數有幾個不超過 k。時間 `O(mn)`。
