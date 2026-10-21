---
title: "LeetCode 495: Teemo Attacking"
summary: "LeetCode 495 解題筆記：每次攻擊貢獻 min(到下一次攻擊的間隔, duration)，最後一次貢獻完整的 duration"
description: "2022-08-24 的 LeetCode 495 解題紀錄"
date: 2022-08-24
tags: ["easy", "array", "simulation"]
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
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Accepted ×3

## 解題思路

中毒時間會被下一次攻擊重設。第 `i` 次攻擊實際的效果是 `min(t[i + 1] - t[i], duration)`：間隔比 duration 長就是完整的 duration，比較短就只到下一次攻擊為止。最後一次攻擊沒有被打斷，貢獻完整的 `duration`（[Array]({{< relref "/algorithm/Array" >}}) 模板五）。

## 我的嘗試

第一版 `range(len(timeSeries))` 存取 `i + 1` 超出範圍。第二版**兩個分支寫反了**：間隔比 duration 長時加的是間隔，應該加 duration：`[2, 7]`、`duration = 0` 回傳 5，答案 0。改成算重疊的部分扣掉才 AC。

## 正確解法

```python
class Solution:
    def findPoisonedDuration(self, timeSeries: List[int], duration: int) -> int:
        total = duration
        for i in range(len(timeSeries) - 1):
            total += min(timeSeries[i + 1] - timeSeries[i], duration)
        return total
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 取的是間隔和 duration 的**較小值**；間隔比較大時效果是 duration，不是間隔。
- 最後一次攻擊要另外加上 duration。

## 面試口說整理

每次攻擊的效果會被下一次攻擊打斷，所以實際中毒時間是間隔和 duration 的較小值，最後一次攻擊沒有被打斷，加上完整的 duration。時間 `O(n)`。
