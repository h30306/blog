---
title: "LeetCode 1791: Find Center of Star Graph"
summary: "LeetCode 1791 解題筆記：中心點出現在每一條邊上，所以只要看前兩條邊的共同點"
description: "2022-11-22 的 LeetCode 1791 解題紀錄"
date: 2022-11-22
tags: ["easy", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

星狀圖的中心連到其他每個點，所以**每一條邊**都包含中心。前兩條邊共同的那個端點就是中心，`O(1)`，不用建圖或數 degree（[BFS]({{< relref "/algorithm/BFS" >}}) 一篇的圖論基礎）。

## 我的解法

```python
class Solution:
    def findCenter(self, edges: List[List[int]]) -> int:
        a, b = edges[0]
        return a if a in edges[1] else b
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 數 degree 也可以，但只需要兩條邊。

## 面試口說整理

中心點出現在每一條邊上，所以我只看前兩條邊，共同的那個端點就是答案。時間 `O(1)`。
