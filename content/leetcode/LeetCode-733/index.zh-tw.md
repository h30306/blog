---
title: "LeetCode 733: Flood Fill"
summary: "LeetCode 733 解題筆記：從起點 DFS / BFS，四個方向上跟起點原本顏色相同的格子都換成新顏色；新舊顏色相同時直接回傳"
description: "2022-09-03 的 LeetCode 733 解題紀錄"
date: 2022-09-03
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
第一次嘗試：2022-09-03
- 提交紀錄：Runtime Error ×6 → Accepted → Runtime Error ×12 → Accepted → Runtime Error ×5 → Accepted ×2

## 解題思路

連通塊（[BFS]({{< relref "/algorithm/BFS" >}}) 模板二）：記下起點原本的顏色 `old`，從起點往上下左右擴散，只有在範圍內**而且**顏色是 `old` 的格子才換色並繼續。`old == color` 時要直接回傳，不然換完的格子還是 `old`，會一直重複走下去。

## 我的嘗試

這題在同一個晚上提交了 27 次，幾乎全部是 Runtime Error：

- 第一版用 queue 但檢查的是**對角線**的四個方向。
- 改成遞迴 DFS 之後，邊界寫成 `x > row and y > column`：**用了 `and`**（應該是 `or`），而且 `row`、`column` 對調了，一直 IndexError。
- 中間幾版沒有處理「新顏色跟舊顏色一樣」，換完的格子還是會被當成要換的，**無限遞迴**。
- 最後把邊界改成四個 `or`，並加上 `image[r][c] == color` 就停，才 AC。

## 正確解法

```python
class Solution:
    def floodFill(self, image: List[List[int]], sr: int, sc: int, color: int) -> List[List[int]]:
        old = image[sr][sc]
        if old == color:
            return image
        m, n = len(image), len(image[0])
        stack = [(sr, sc)]
        image[sr][sc] = color
        while stack:
            i, j = stack.pop()
            for x, y in ((i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)):
                if 0 <= x < m and 0 <= y < n and image[x][y] == old:
                    image[x][y] = color
                    stack.append((x, y))
        return image
```

## 複雜度

時間 `O(mn)`，空間 `O(mn)`。

## 要特別避免的錯誤

- 邊界檢查是 `x < 0 or y < 0 or x >= m or y >= n`，四個條件用 `or`，不是 `and`。
- 列數是 `len(image)`，欄數是 `len(image[0])`，不要對調。
- 新舊顏色相同時直接回傳。
- 只有上下左右四個方向，不是對角線。

## 面試口說整理

我記下起點原本的顏色，從起點往上下左右擴散，在範圍內而且顏色相同的格子就換色並繼續；新舊顏色一樣時直接回傳，避免無限迴圈。時間 `O(mn)`。
