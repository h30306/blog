---
title: "LeetCode 492: Construct the Rectangle"
summary: "LeetCode 492 解題筆記：寬度從 √area 往下找，第一個能整除 area 的就是最接近正方形的寬"
description: "2022-08-24 的 LeetCode 492 解題紀錄"
date: 2022-08-24
tags: ["easy", "math"]
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
- 提交紀錄：Runtime Error → Wrong Answer ×3 → Accepted ×3 → Wrong Answer → Runtime Error → Accepted

## 解題思路

`L >= W` 而且 `L - W` 越小越好，代表 `W` 要盡量大但不超過 `√area`（[Math]({{< relref "/algorithm/Math" >}}) 模板四）。從 `int(√area)` 往下找，第一個整除 `area` 的 `W` 就是答案，`L = area // W`。`W = 1` 一定整除，所以一定找得到。

## 我的嘗試

這題提交了 10 次：

- 第一版 `range(area // 2)` 從 0 開始，`area % 0` 直接 ZeroDivisionError。
- 改成 `range(1, area // 2)` 之後**上界錯了**：`area = 4` 只試了 1，回傳 `[4, 1]`，答案 `[2, 2]`；`area` 是 1、2、3 時範圍是空的，`w` 還是 0。
- 改成以 `√area` 為上界就 AC 了。之後重寫成「從 `√area` 往下找，第一個整除的就回傳」，中間有一版找不到時沒有回傳（`None`）、一版變數名稱錯誤，第三次才 AC。

## 正確解法

```python
class Solution:
    def constructRectangle(self, area: int) -> List[int]:
        w = isqrt(area)
        while area % w:
            w -= 1
        return [area // w, w]
```

## 複雜度

時間 `O(√area)`，空間 `O(1)`。

## 要特別避免的錯誤

- 寬度的上限是 `√area`，不是 `area // 2`：`area = 4` 時 `range(1, 2)` 只會試到 1。
- `range` 從 0 開始會除以 0。

## 面試口說整理

L 要大於等於 W 而且差距最小，所以 W 要盡量接近根號 area。我從根號 area 往下找第一個能整除的 W，L 就是 area 除以 W。時間 `O(√area)`。
