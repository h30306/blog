---
title: "LeetCode 836: Rectangle Overlap"
summary: "LeetCode 836 解題筆記：兩個矩形重疊等價於 x 方向和 y 方向的區間都重疊，min(右邊) > max(左邊)"
description: "2022-09-15 的 LeetCode 836 解題紀錄"
date: 2022-09-15
tags: ["easy", "math", "geometry"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-15
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer ×4 → Runtime Error ×2 → Wrong Answer ×4 → Accepted

## 解題思路

二維的重疊可以拆成兩個一維的區間重疊（[Math]({{< relref "/algorithm/Math" >}}) 模板三）：交集的寬度是 `min(x2) - max(x1)`、高度是 `min(y2) - max(y1)`，**兩者都要大於 0**（剛好碰到邊不算重疊）。不用分「誰在誰左邊」的各種情況。

## 我的嘗試

這題提交了 13 次，前面十二次都在用「某個端點落在另一個矩形的範圍內」分情況討論，每次都漏掉一種：

- 只檢查 `rec2` 的起點在 `rec1` 的終點之前：`[1, 2, 3, 4]` 和 `[2, 1, 4, 2]` 在 `y = 2` 只碰到邊，回傳 `True`。
- 只檢查 y 方向、或用嚴格不等式：兩個矩形 y 範圍完全相同時（`[1, 0, 4, 2]`、`[3, 0, 4, 2]`）回傳 `False`。
- x、y 都檢查「端點在區間裡」之後，**一個矩形包住另一個**的情況又漏了：`[3, 3, 4, 4]` 在 `[3, 2, 6, 5]` 裡面，回傳 `False`。

最後改成算交集的寬和高才 AC。

## 正確解法

```python
class Solution:
    def isRectangleOverlap(self, rec1: List[int], rec2: List[int]) -> bool:
        width = min(rec1[2], rec2[2]) - max(rec1[0], rec2[0])
        height = min(rec1[3], rec2[3]) - max(rec1[1], rec2[1])
        return width > 0 and height > 0
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- x 和 y 兩個方向都要檢查。
- 用嚴格大於，只碰到邊不算。
- 一個矩形完全包住另一個時，兩個端點都不在對方的範圍內，用「端點落在區間裡」來判斷會漏掉。

## 面試口說整理

我把重疊拆成 x 和 y 兩個方向的區間重疊，交集寬度是兩個右邊界的較小值減兩個左邊界的較大值，高度同理，兩者都大於 0 才算重疊。時間 `O(1)`。
