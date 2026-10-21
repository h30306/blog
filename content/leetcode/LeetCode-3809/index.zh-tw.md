---
title: "LeetCode 3809: Best Reachable Tower"
summary: "LeetCode 3809 解題筆記：先過濾曼哈頓距離在半徑內的塔，用 (-品質, x, y) 當 key 取最小，就同時處理了平手"
description: "2026-01-17 的 LeetCode 3809 解題紀錄"
date: 2026-01-17
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-17
- 提交紀錄：Accepted（一次通過）

## 解題思路

「品質最大，平手時座標字典序最小」可以合成一個 key：`(-q, x, y)` 取最小（[Array]({{< relref "/algorithm/Array" >}}) 模板四）。只看曼哈頓距離 `|x - cx| + |y - cy| <= radius` 的塔，沒有就回傳 `[-1, -1]`。

## 我的解法

```python
class Solution:
    def bestTower(self, towers: List[List[int]], center: List[int], radius: int) -> List[int]:
        cx, cy = center
        reachable = [(-q, x, y) for x, y, q in towers if abs(x - cx) + abs(y - cy) <= radius]
        if not reachable:
            return [-1, -1]
        _, x, y = min(reachable)
        return [x, y]
```

我當時用 if / elif 一個一個比較品質、x、y；用 tuple 當 key 比較不容易漏情況。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 品質要最大，所以 key 用 `-q` 才能跟座標一起取最小。

## 面試口說整理

我先留下距離在半徑內的塔，再用（負品質, x, y）取最小，品質最高、平手時座標最小的就會被選出來；沒有塔就回傳 `[-1, -1]`。時間 `O(n)`。
