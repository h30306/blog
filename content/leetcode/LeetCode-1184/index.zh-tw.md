---
title: "LeetCode 1184: Distance Between Bus Stops"
summary: "LeetCode 1184 解題筆記：環狀路線只有兩個方向，順時針是 start 到 destination 之間的和，逆時針是總和減掉它"
description: "2022-10-18 的 LeetCode 1184 解題紀錄"
date: 2022-10-18
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-10-18
- 提交紀錄：Wrong Answer ×4 → Accepted ×4

## 解題思路

環上只有兩條路：順時針走過 `distance[a:b]`（`a = min(start, destination)`、`b = max(...)`），逆時針是 `總和 - 順時針`，取比較短的。**先把兩個端點排好**，不然 `start > destination` 時切片是空的。

## 我的嘗試

前四版都沒有處理 `start > destination`，**切片 `distance[start:destination]` 是空的**，順時針算成 0：`[2, 2]`、`start = 1`、`destination = 0` 回傳 0，答案 2。加上交換就 AC 了。

## 正確解法

```python
class Solution:
    def distanceBetweenBusStops(self, distance: List[int], start: int, destination: int) -> int:
        a, b = min(start, destination), max(start, destination)
        clockwise = sum(distance[a:b])
        return min(clockwise, sum(distance) - clockwise)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（切片 `O(n)`）。

## 要特別避免的錯誤

- `start` 可能比 `destination` 大，要先交換。

## 面試口說整理

環狀路線只有兩個方向，我先把起點終點排好，順時針是兩點之間的距離和，逆時針是總和減掉它，取較小的。時間 `O(n)`。
