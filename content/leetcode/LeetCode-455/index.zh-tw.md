---
title: "LeetCode 455: Assign Cookies"
summary: "LeetCode 455 解題筆記：小孩和餅乾都排序，用最小的、夠大的餅乾滿足最小的小孩；兩個指標各走一次"
description: "2022-08-24 的 LeetCode 455 解題紀錄"
date: 2022-08-24
tags: ["easy", "array", "two-pointers", "greedy", "sorting"]
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
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Accepted

## 解題思路

貪心：胃口最小的小孩最容易滿足，用「剛好夠」的最小餅乾給他，把大的留給後面（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板二）。兩邊都排序後，餅乾一塊一塊看：夠目前這個小孩就給他（小孩指標前進），不夠就換下一塊更大的。

## 我的嘗試

2022 年提交了 10 次：

- 第一版把排序後的兩個陣列 `zip` 起來一對一比，不夠大的餅乾會讓那個小孩直接沒得吃。例如胃口 `[5]`、餅乾 `[5, 4]`：排序後 4 配 5 不夠，回傳 0，答案 1。
- 之後改成迴圈，但小孩都吃完之後還在取 `g[0]`，或是餅乾陣列是空的時候還是算了 1，index 超出範圍或多算。

## 正確解法

```python
class Solution:
    def findContentChildren(self, g: List[int], s: List[int]) -> int:
        g.sort()
        s.sort()
        i = 0
        for size in s:
            if i < len(g) and size >= g[i]:
                i += 1
        return i
```

## 複雜度

時間 `O(m log m + n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 不能把排序後的兩個陣列直接 `zip` 一對一配：不夠大的餅乾要跳過，不是讓那個小孩放棄。
- 小孩都滿足之後要停，不要繼續取 `g[i]`。

## 面試口說整理

我把小孩的胃口和餅乾都排序，從最小的餅乾開始看，夠目前胃口最小的小孩就給他，不夠就換下一塊更大的。每個指標只走一次，時間是排序的 `O(n log n)`。
