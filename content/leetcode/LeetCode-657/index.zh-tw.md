---
title: "LeetCode 657: Robot Return to Origin"
summary: "LeetCode 657 解題筆記：回到原點等價於上下次數相同、左右次數相同"
description: "2022-08-29 的 LeetCode 657 解題紀錄"
date: 2022-08-29
tags: ["easy", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-29
- 提交紀錄：Accepted ×3

## 解題思路

上下互相抵消、左右互相抵消，所以只要 `U` 和 `D` 的次數相同、`L` 和 `R` 的次數相同（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 計數）。順序不重要。

## 我的解法

```python
class Solution:
    def judgeCircle(self, moves: str) -> bool:
        return moves.count("U") == moves.count("D") and moves.count("L") == moves.count("R")
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只看最後的位置，移動的順序不影響答案。

## 面試口說整理

回到原點代表上下互相抵消、左右互相抵消，所以我比較 U 和 D、L 和 R 的次數是否相同。時間 `O(n)`。
