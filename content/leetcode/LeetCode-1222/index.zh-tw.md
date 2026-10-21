---
title: "LeetCode 1222: Queens That Can Attack the King"
summary: "LeetCode 1222 解題筆記：從國王往八個方向一步一步走，每個方向第一個遇到的皇后就能攻擊；皇后放進集合方便查詢"
description: "2025-07-30 的 LeetCode 1222 解題紀錄"
date: 2025-07-30
tags: ["medium", "array", "matrix", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-30
- 提交紀錄：Accepted ×2

## 解題思路

反過來從國王出發（[Array]({{< relref "/algorithm/Array" >}}) 模板五）：八個方向各走一次，遇到的第一個皇后能直接攻擊，後面的被擋住了。每個方向最多走 7 步。

## 我的解法

```python
class Solution:
    def queensAttacktheKing(self, queens: List[List[int]], king: List[int]) -> List[List[int]]:
        qs = set(map(tuple, queens))
        res = []
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                if dx == dy == 0:
                    continue
                x, y = king[0] + dx, king[1] + dy
                while 0 <= x < 8 and 0 <= y < 8:
                    if (x, y) in qs:
                        res.append([x, y])
                        break
                    x, y = x + dx, y + dy
        return res
```

我當時用 `[x, y] in queens` 在 list 上查；第二次提交把一堆 `if i == -1` 改成直接加上方向。棋盤很小所以兩版都很快，這裡改成集合。

## 複雜度

時間 `O(q + 8 × 8)`，空間 `O(q)`。

## 要特別避免的錯誤

- 每個方向找到第一個皇后就要停，後面的被擋住。

## 面試口說整理

我從國王往八個方向走，每個方向第一個遇到的皇后就是能攻擊國王的，後面的都被擋住。皇后放進集合，查詢 `O(1)`。時間 `O(q + 64)`。
