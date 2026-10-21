---
title: "LeetCode 661: Image Smoother"
summary: "LeetCode 661 解題筆記：每格取周圍 3 × 3 範圍內存在的格子平均，向下取整；結果要寫到新的矩陣"
description: "2022-08-29 的 LeetCode 661 解題紀錄"
date: 2022-08-29
tags: ["easy", "array", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-29
- 提交紀錄：Runtime Error → Wrong Answer ×3 → Runtime Error ×4 → Accepted ×2

## 解題思路

對每一格枚舉 `dx, dy ∈ {-1, 0, 1}`（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板三），只算在範圍內的鄰居，總和 `//` 個數。結果要寫到**新的矩陣**，不然後面的格子會讀到已經平滑過的值。建新矩陣時要用 list comprehension，`[[0] * n] * m` 的每一列是同一個 list。

## 我的嘗試

這題提交了 10 次：

- 結果矩陣寫成 `[[0] * n] * m`，**每一列都是同一個 list**，最後一列算完會蓋掉全部：`[[45], [69], [2]]` 回傳三列都是 35。另外第一版用 `/` 得到 41.5 這種小數。
- 改成邊算邊 `append` 之後，判斷要開新的一列還是接在舊的後面的條件寫錯，一直 IndexError；改成 `i == len(res)` 才 AC。

## 正確解法

```python
class Solution:
    def imageSmoother(self, img: List[List[int]]) -> List[List[int]]:
        m, n = len(img), len(img[0])
        res = [[0] * n for _ in range(m)]
        for i in range(m):
            for j in range(n):
                total = count = 0
                for x in range(i - 1, i + 2):
                    for y in range(j - 1, j + 2):
                        if 0 <= x < m and 0 <= y < n:
                            total += img[x][y]
                            count += 1
                res[i][j] = total // count
        return res
```

## 複雜度

時間 `O(9mn)`，空間 `O(mn)`（輸出）。

## 要特別避免的錯誤

- `[[0] * n] * m` 的每一列是同一個 list，改一列等於全部都改。
- 平均要向下取整，用 `//`。

## 面試口說整理

我對每一格枚舉周圍 3 × 3 的位置，只算在範圍內的格子，總和除以個數向下取整，寫進新的矩陣。時間 `O(9mn)`。
