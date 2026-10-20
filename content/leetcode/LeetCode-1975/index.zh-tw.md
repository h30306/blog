---
title: "LeetCode 1975: Maximum Matrix Sum"
summary: "LeetCode 1975 解題筆記：負號可以兩兩搬到任何位置，但負數個數的奇偶不變；奇數個時留一個在絕對值最小的位置"
description: "2026-01-06 的 LeetCode 1975 解題紀錄"
date: 2026-01-06
tags: ["medium", "greedy", "matrix", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-06
- 提交紀錄：Accepted（一次通過）

## 解題思路

對相鄰兩格同時乘 -1：

- 如果一格是負的、旁邊是正的，做完負號就「移到」旁邊。沿著路徑一直做，負號可以搬到任何格子。
- 兩個負號碰在一起時一次消掉兩個。
- 每次操作改變兩格的正負，所以**負數個數的奇偶不變**（把 0 當成可以吸收負號的格子）。

所以：負數個數是偶數，全部都能變正，答案是絕對值總和；是奇數，最後一定剩一個負的，把它放在絕對值最小的格子，答案是 `總和 - 2 × 最小絕對值`。有 0 的話最小絕對值就是 0，自動處理。

## 我的解法

```python
class Solution:
    def maxMatrixSum(self, matrix: List[List[int]]) -> int:
        total, smallest, neg = 0, inf, 0
        for row in matrix:
            for x in row:
                total += abs(x)
                smallest = min(smallest, abs(x))
                neg += x < 0
        return total if neg % 2 == 0 else total - 2 * smallest
```

我當時另外記了一個 `zero` 旗標；有 0 的時候 `smallest` 就是 0，減掉也不影響，所以不需要。

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 留下的負號要放在**絕對值**最小的格子，不是值最小的。

## 面試口說整理

操作可以把負號沿著路徑搬到任何位置，兩個相遇就抵銷，但負數個數的奇偶不變。所以偶數個時答案是絕對值總和，奇數個時要扣掉兩倍的最小絕對值。時間 `O(n²)`。
