---
title: "LeetCode 3842: Toggle Light Bulbs"
summary: "LeetCode 3842 解題筆記：用集合切換開關，或數出現奇數次的燈泡；最後要排序"
description: "2026-02-16 的 LeetCode 3842 解題紀錄"
date: 2026-02-16
tags: ["easy", "hash-table", "simulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-02-16
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

每出現一次就切換一次，所以最後亮著的是**出現奇數次**的燈泡。用集合模擬：在集合裡就拿掉，不在就加進去（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。題目要由小到大回傳。

## 我的嘗試

第一版回傳 `list(light)`，**集合沒有順序**。例如 `[8, 1]`：答案是 `[1, 8]`，這版回傳 `[8, 1]`。加上 `sorted` 就 AC 了。

## 正確解法

```python
class Solution:
    def toggleLightBulbs(self, bulbs: List[int]) -> List[int]:
        on = set()
        for b in bulbs:
            on ^= {b}                      # 在就拿掉，不在就加入
        return sorted(on)
```

## 複雜度

時間 `O(n + k log k)`，`k` 是最後亮著的數量，空間 `O(k)`。

## 要特別避免的錯誤

- 集合轉 list 不保證順序，題目要排序就要自己排。

## 面試口說整理

每次出現都切換，所以最後亮著的是出現奇數次的燈泡。我用集合做對稱差來切換，最後排序回傳。時間 `O(n log n)`。
