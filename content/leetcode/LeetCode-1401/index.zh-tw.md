---
title: "LeetCode 1401: Circle and Rectangle Overlapping"
summary: "LeetCode 1401 解題筆記：矩形裡離圓心最近的點，是把圓心的座標 clamp 到矩形範圍內；這個點到圓心的距離 <= 半徑就重疊"
description: "2026-01-05 的 LeetCode 1401 解題紀錄"
date: 2026-01-05
tags: ["medium", "math", "geometry"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-05
- 提交紀錄：Wrong Answer ×3 → Accepted

## 解題思路

圓和矩形有交集 ⇔ **矩形裡離圓心最近的點**在圓內。

最近的點很好找：x 和 y 各自獨立，把圓心的 x 夾到 `[x1, x2]`、y 夾到 `[y1, y2]`：

```text
nx = min(max(xc, x1), x2)
ny = min(max(yc, y1), y2)
```

圓心在矩形裡時，最近點就是圓心本身，距離是 0，也會判斷成重疊。

比較距離時用平方，避免開根號的浮點誤差。

## 我的嘗試

我的寫法是分成四個方向（圓心在矩形的左、下、右、上），每個方向再判斷最近的點。四個 `if` 裡有兩次寫錯：

| 版本 | 問題 |
|---|---|
| 第一版 | 沒處理圓心在矩形內；最後一個方向（上方）寫成 `yCenter < y2`，應該是 `yCenter > y2`。例如半徑 2、圓心 `(6, 4)`、矩形 `(5, 0)–(6, 2)`：上邊的 `(6, 2)` 距離剛好 2，答案是 `True`，回傳 `False` |
| 第二版 | 補上圓心在矩形內，上方的條件還是錯的，同一個例子回傳 `False` |
| 第三版 | 改成 `<=`，方向還是反的。例如半徑 3、圓心 `(3, 4)`、矩形 `(2, 2)–(5, 3)`：答案是 `True`，回傳 `False` |
| AC | 改成 `yCenter >= y2` |

clamp 的寫法不用分情況，就不會有方向寫反的問題。

## 正確解法

```python
class Solution:
    def checkOverlap(self, radius: int, xCenter: int, yCenter: int, x1: int, y1: int, x2: int, y2: int) -> bool:
        nx = min(max(xCenter, x1), x2)             # 矩形裡離圓心最近的點
        ny = min(max(yCenter, y1), y2)
        return (nx - xCenter) ** 2 + (ny - yCenter) ** 2 <= radius ** 2
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 分情況討論時把比較的方向寫反。
- 漏掉圓心在矩形內的情況。
- 用浮點數開根號比較：用平方比較比較穩。

## 面試口說整理

我找矩形裡離圓心最近的點：x 和 y 各自把圓心的座標夾到矩形的範圍內，這個點到圓心的距離平方不超過半徑平方就重疊。圓心在矩形內時最近點就是圓心，也自然成立。時間 `O(1)`。
