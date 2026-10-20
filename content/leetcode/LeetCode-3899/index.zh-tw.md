---
title: "LeetCode 3899: Angles of a Triangle"
summary: "LeetCode 3899 解題筆記：先用三角不等式判斷能不能組成三角形，再用餘弦定理算三個角，記得排序"
description: "2026-04-12 的 LeetCode 3899 解題紀錄"
date: 2026-04-12
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
第一次嘗試：2026-04-12
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

1. **三角不等式**：面積大於 0 ⇔ 任兩邊之和大於第三邊（嚴格大於；等於的話三點共線，面積是 0）。
2. **餘弦定理**：`cos A = (b² + c² - a²) / (2bc)`，`A = acos(cos A)`，轉成角度。
3. 題目要求**由小到大**輸出。

## 我的嘗試

第一版角度算對了，但直接依 `a, b, c` 的順序回傳，沒有排序。例如 `sides = [4, 4, 1]`：回傳 `[82.8, 82.8, 14.4]`，要的是 `[14.4, 82.8, 82.8]`。加上 `sorted` 就 AC 了。

## 正確解法

```python
from math import acos, degrees

class Solution:
    def internalAngles(self, sides: List[int]) -> List[float]:
        a, b, c = sorted(sides)
        if a + b <= c:
            return []                              # 面積是 0 或組不成
        def angle(opp: int, x: int, y: int) -> float:
            cos_v = (x * x + y * y - opp * opp) / (2 * x * y)
            return degrees(acos(max(-1.0, min(1.0, cos_v))))   # 防止浮點誤差超出 [-1, 1]
        return sorted([angle(a, b, c), angle(b, a, c), angle(c, a, b)])
```

先排序的話，三角不等式只要檢查最短的兩邊之和是否大於最長邊。

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 輸出要排序。
- 三角不等式要嚴格大於。
- `acos` 的參數可能因為浮點誤差稍微超出 `[-1, 1]`，夾一下比較保險。

## 面試口說整理

先排序三邊，最短的兩邊之和要嚴格大於最長邊才是三角形。再用餘弦定理算三個角、轉成角度，最後排序輸出。時間 `O(1)`。
